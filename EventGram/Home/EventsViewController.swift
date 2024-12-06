//
//  EventsViewController.swift
//  EventGram
//
//  Created by Nallapu Srikar on 12/4/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class EventsViewController: UIViewController {
    
    let mainScreen = EventsView()
    
    var events: [Event] = []
    
    override func loadView() {
        view = mainScreen
        self.navigationItem.setHidesBackButton(true, animated:true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //createSampleEvents()
        
        title = "Upcoming Events"
        mainScreen.tableViewEvents.dataSource = self
        mainScreen.tableViewEvents.delegate = self
        mainScreen.tableViewEvents.separatorStyle = .none
        
        fetchUpcomingEvents()
        
        
        let buttonLogout = UIButton(type: .system)
        buttonLogout.setTitle("Logout", for: .normal)
        buttonLogout.titleLabel?.font = .boldSystemFont(ofSize: 16)

        buttonLogout.addTarget(self, action: #selector(onButtonLogoutTapped), for: .touchUpInside)
        let logoutBarButtonItem = UIBarButtonItem(customView: buttonLogout)
                
        navigationItem.leftBarButtonItem = logoutBarButtonItem
        
        
        
    }
    
    @objc func onButtonLogoutTapped(){
        let logoutAlert = UIAlertController(title: "Logging out!", message: "Are you sure want to log out?",
            preferredStyle: .actionSheet)
        logoutAlert.addAction(UIAlertAction(title: "Yes, log out!", style: .default, handler: {(_) in
                do{
                    try Auth.auth().signOut()
                    let viewController = ViewController()
                    self.navigationController?.pushViewController(viewController, animated: true)
                }catch{
                    print("Error occured!")
                }
            })
        )
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(logoutAlert, animated: true)
    }
    
    private func fetchUpcomingEvents() {
        let db = Firestore.firestore()
        db.collection("events")
            .whereField("date", isGreaterThanOrEqualTo: Date())
            .order(by: "date")
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching events: \(error)")
                    return
                }
                
                self.events = snapshot?.documents.compactMap { document in
                    return Event(dictionary: document.data())
                } ?? []
                
                // Reload the table view on the main thread
                DispatchQueue.main.async {
                    self.mainScreen.tableViewEvents.reloadData()
                }
                print(self.events)
                //self.mainView.tableView.reloadData()
            }
    }
}

extension EventsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "events", for: indexPath) as! TableViewEventCell
                cell.labelTitle.text = events[indexPath.row].title
                cell.labelLocation.text = events[indexPath.row].location
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd" // Set the desired date format
                cell.labelDate.text = dateFormatter.string(from: events[indexPath.row].date)
        
                if let imageUrl = events[indexPath.row].imageUrl, let url = URL(string: imageUrl) {
                    cell.imageReceipt.af.setImage(withURL: url, placeholderImage: UIImage(systemName: "photo"))
                } else {
                    cell.imageReceipt.image = UIImage(systemName: "photo")
                }
               
                
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        let event = events[indexPath.row]
//        // Navigate to event details screen or perform any other action
//    }
}