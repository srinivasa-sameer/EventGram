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
        buttonLogout.setTitleColor(UIColor(red: 190/255, green: 40/255, blue: 60/255, alpha: 1.0), for: .normal)

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
            
            if let document = document, let data = document.data(), let userRole = data["role"] as? String{
                // Populate profile data
                DispatchQueue.main.async {
                    self?.profileScreen.nameLabel.text = data["name"] as? String ?? "Name not available"
                    self?.profileScreen.universityLabel.text = data["university"] as? String ?? "University not available"
                }
                
                self?.fetchEventsBasedOnRole(userRole: userRole)
            }
        }
    }
    
    func fetchEventsBasedOnRole(userRole:String) {
        
        if userRole == "Student" {
            self.profileScreen.myEventsLabel.text = "My Bookings"
            fetchStudentEvents()
        } else if userRole == "Club Admin" {
            self.profileScreen.myEventsLabel.text = "My Events"
            fetchAdminEvents()
        } else {
            showAlert(message: "Invalid user role.")
        }
    }
    
    func fetchStudentEvents() {
        let db = Firestore.firestore()
        guard let user = Auth.auth().currentUser else {
            showAlert(message: "No user logged in.")
            return
        }
        
        let userRef = db.collection("users").document(user.uid)
        
        userRef.getDocument { [weak self] document, error in
            if let error = error {
                self?.showAlert(message: "Error fetching data: \(error.localizedDescription)")
                return
            }
            
            if let document = document, let registeredEventIds = document["registeredEvents"] as? [String] {
                self?.fetchRegisteredEvents(eventIds: registeredEventIds)
            }
        }
    }
    
    func fetchAdminEvents() {
        let db = Firestore.firestore()
        let eventsCollection = db.collection("events")
        
        eventsCollection.whereField("userId", isEqualTo: Auth.auth().currentUser?.uid ?? "").getDocuments { [weak self] snapshot, error in
            if let error = error {
                self?.showAlert(message: "Error fetching events for admin role: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                self?.showAlert(message: "No events found.")
                return
            }
            
            let events = documents.compactMap { Event(dictionary: $0.data()) }
            self?.registeredEvents = events
            DispatchQueue.main.async {
                self?.profileScreen.eventsTableView.reloadData()
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
                let loginViewController = LoginViewController()
                let navigationController = UINavigationController(rootViewController: loginViewController)
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

