//
//  SearchViewController.swift
//  EventGram
//
//  Created by Srinivasa Sameer Addepalli on 12/8/24.
//

import UIKit
import Firebase
import FirebaseFirestore

class SearchViewController: UIViewController {
    let searchView = SearchView()
    let db = Firestore.firestore()
    
    var allEvents: [Event] = []
    var filteredEvents: [Event] = []
    
    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.searchBar.delegate = self
        searchView.tableView.delegate = self
        searchView.tableView.dataSource = self
        
        fetchEvents()
    }
    
    func fetchEvents() {
        db.collection("events").getDocuments { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching events: \(error)")
                return
            }
            
            if let documents = snapshot?.documents {
                self?.allEvents = documents.compactMap { document -> Event? in
                    let data = document.data()
                    return Event(dictionary: data)
                }
                // Don't set filteredEvents here, leave it empty initially
                self?.filteredEvents = []
                DispatchQueue.main.async {
                    self?.searchView.tableView.reloadData()
                }
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredEvents = []  // Clear the filtered results when search is empty
        } else {
            filteredEvents = allEvents.filter { event in
                event.title.lowercased().contains(searchText.lowercased()) ||
                event.description.lowercased().contains(searchText.lowercased()) ||
                event.location.lowercased().contains(searchText.lowercased())
            }
        }
        searchView.tableView.reloadData()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! TableViewEventCell
        let event = filteredEvents[indexPath.row]
        
        cell.labelTitle.text = event.title
        cell.labelLocation.text = event.location
        cell.labelDate.text = DateFormatter.localizedString(from: event.date, dateStyle: .medium, timeStyle: .short)
        
        if let imageUrl = event.imageUrl, let url = URL(string: imageUrl) {
            cell.imageReceipt.af.setImage(withURL: url, placeholderImage: UIImage(systemName: "photo"))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailsVC = EventDetailsViewController()
        detailsVC.event = filteredEvents[indexPath.row]
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
