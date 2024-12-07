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
        mainScreen.tableViewEvents.dataSource = self
        mainScreen.tableViewEvents.delegate = self
        mainScreen.tableViewEvents.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUpcomingEvents()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Get the selected event
        let selectedEvent = events[indexPath.row]
        
        // Initialize EventDetailsViewController
        let eventDetailsVC = EventDetailsViewController()
        
        // Pass the selected event data to EventDetailsViewController
        eventDetailsVC.event = selectedEvent
        
        // Push the EventDetailsViewController onto the navigation stack
        navigationController?.pushViewController(eventDetailsVC, animated: true)
    }
}
