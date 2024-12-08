//
//  ProfileViewController.swift
//  EventGram
//
//  Created by Srinivasa Sameer Addepalli on 11/29/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController {
    
    let profileScreen = ProfileView()
    var registeredEvents: [Event] = [] // Array to hold registered events
    
    override func loadView() {
        view = profileScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonLogout = UIButton(type: .system)
        buttonLogout.setTitle("Logout", for: .normal)
        buttonLogout.titleLabel?.font = .boldSystemFont(ofSize: 16)
        buttonLogout.titleLabel?.textColor = .systemRed

        buttonLogout.addTarget(self, action: #selector(onButtonLogoutTapped), for: .touchUpInside)
        let logoutBarButtonItem = UIBarButtonItem(customView: buttonLogout)
                
        navigationItem.rightBarButtonItem = logoutBarButtonItem
        
        profileScreen.eventsTableView.delegate = self
        profileScreen.eventsTableView.dataSource = self
        profileScreen.eventsTableView.register(TableViewEventCell.self, forCellReuseIdentifier: "eventCell")
        
    }
    
    // This is called every time the tab is selected
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            fetchUserProfile()
        }
    
    // Fetch user profile and registered events from Firestore
    func fetchUserProfile() {
        guard let user = Auth.auth().currentUser else {
            showAlert(message: "You need to sign in to view your profile.")
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)
        
        userRef.getDocument { [weak self] document, error in
            if let error = error {
                self?.showAlert(message: "Failed to fetch user data: \(error.localizedDescription)")
                return
            }
            
            if let document = document, let data = document.data() {
                // Populate profile data
                DispatchQueue.main.async {
                    self?.profileScreen.nameLabel.text = data["name"] as? String ?? "Name not available"
                    self?.profileScreen.universityLabel.text = data["university"] as? String ?? "University not available"
                }
                
                // Fetch registered events
                if let registeredEventIds = data["registeredEvents"] as? [String] {
                    self?.fetchRegisteredEvents(eventIds: registeredEventIds)
                }
            }
        }
    }
    
    func fetchRegisteredEvents(eventIds: [String]) {
        let db = Firestore.firestore()
            let eventsCollection = db.collection("events")
            
            let dispatchGroup = DispatchGroup()
            var fetchedEvents: [Event] = []
            
            for eventId in eventIds {
                dispatchGroup.enter()
                
                // Query the events collection where `eventId` matches
                eventsCollection.whereField("eventId", isEqualTo: eventId).getDocuments { snapshot, error in
                    if let error = error {
                        print("Error fetching event with ID \(eventId): \(error.localizedDescription)")
                        dispatchGroup.leave()
                        return
                    }
                    
                    guard let documents = snapshot?.documents, !documents.isEmpty else {
                        print("No event found with eventId: \(eventId)")
                        dispatchGroup.leave()
                        return
                    }
                    
                    // Assuming there is only one document per `eventId`
                    for document in documents {
                        let data = document.data()
                        let event = Event(dictionary: data)
                        fetchedEvents.append(event)
                    }
                    
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) { [weak self] in
                self?.registeredEvents = fetchedEvents
                self?.profileScreen.eventsTableView.reloadData()
            }
    }
    
    // Show alert messages
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Profile Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc func onButtonLogoutTapped(){
        let logoutAlert = UIAlertController(title: "Logging out!", message: "Are you sure want to log out?",
            preferredStyle: .actionSheet)
        logoutAlert.addAction(UIAlertAction(title: "Yes, log out!", style: .default, handler: {(_) in
            do {
                try Auth.auth().signOut()
                let viewController = ViewController()
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.setNavigationBarHidden(true, animated: false)

                // Find the active UIWindowScene
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.rootViewController = navigationController
                    window.makeKeyAndVisible()
                }
            } catch {
                print("Error occurred during logout!")
            }
        }))
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(logoutAlert, animated: true)
    }
    
    
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registeredEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "events", for: indexPath) as! TableViewEventCell
                cell.labelTitle.text = registeredEvents[indexPath.row].title
                cell.labelLocation.text = registeredEvents[indexPath.row].location
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd" // Set the desired date format
                cell.labelDate.text = dateFormatter.string(from: registeredEvents[indexPath.row].date)
        
                if let imageUrl = registeredEvents[indexPath.row].imageUrl, let url = URL(string: imageUrl) {
                    cell.imageReceipt.af.setImage(withURL: url, placeholderImage: UIImage(systemName: "photo"))
                } else {
                    cell.imageReceipt.image = UIImage(systemName: "photo")
                }
               
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Get the selected event
        let selectedEvent = registeredEvents[indexPath.row]
        
        // Initialize EventDetailsViewController
        let eventDetailsVC = EventDetailsViewController()
        
        // Pass the selected event data to EventDetailsViewController
        eventDetailsVC.event = selectedEvent
        
        // Push the EventDetailsViewController onto the navigation stack
        navigationController?.pushViewController(eventDetailsVC, animated: true)
    }
}

