////
////  EventDetailsViewController.swift
////  EventGram
////
////  Created by Srikar Nallapu on 11/29/24.
////

import UIKit
import FirebaseAuth
import FirebaseFirestore

class EventDetailsViewController: UIViewController {
    
    var event: Event? // Property to hold event data
    let detailsView = EventDetailsView()
    
    override func loadView() {
        view = detailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //guard let user = Auth.auth().currentUser else { return }
        
        // Customize the details view with event data
        if let event = event {
            detailsView.titleLabel.text = event.title
            detailsView.descriptionLabel.text = event.description
            detailsView.dateLabel.text = DateFormatter.localizedString(from: event.date, dateStyle: .medium, timeStyle: .short)
            detailsView.locationLabel.text = event.location
            detailsView.organizerLabel.text = "Hosted By \(event.eventId)"
            detailsView.attendingLabel.text = "\(event.title) Attending"
            
            if let imageUrl = event.imageUrl, let url = URL(string: imageUrl) {
                detailsView.eventImageView.af.setImage(withURL: url, placeholderImage: UIImage(systemName: "photo"))
            }
        }
        
        // Check if the user has already registered for the event
        checkRegistrationStatus()
        
        // Add action for the book ticket button
        detailsView.bookTicketButton.addTarget(
            self, action: #selector(onBookTicketTapped), for: .touchUpInside)
    }
    
    func checkRegistrationStatus() {
        guard let eventId = event?.eventId else { return }
        guard let user = Auth.auth().currentUser else { return }
        
        let userId = user.uid
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        userRef.getDocument { [weak self] document, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            if let document = document, let data = document.data(),
               let registeredEvents = data["registeredEvents"] as? [String] {
                // Check if the event is already registered
                if registeredEvents.contains(eventId) {
                    DispatchQueue.main.async {
                        self?.detailsView.bookTicketButton.setTitle("Cancel Registration", for: .normal)
                        self?.detailsView.bookTicketButton.backgroundColor = .black
                        self?.detailsView.bookTicketButton.removeTarget(nil, action: nil, for: .allEvents)
                        self?.detailsView.bookTicketButton.addTarget(
                            self, action: #selector(self?.onCancelRegistrationTapped), for: .touchUpInside)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.detailsView.bookTicketButton.setTitle("Book Ticket", for: .normal)
                    self?.detailsView.bookTicketButton.backgroundColor = UIColor(red: 190/255, green: 40/255, blue: 60/255, alpha: 1.0)
                }
            }
        }
    }
    
    @objc func onBookTicketTapped() {
        guard let eventId = event?.eventId else {
            showAlert(message: "Event ID not available.")
            return
        }
        
        guard let user = Auth.auth().currentUser else {
            showAlert(message: "You need to sign in to book a ticket.")
            return
        }
        
        let userId = user.uid
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        userRef.getDocument { [weak self] document, error in
            if let error = error {
                self?.showAlert(message: "Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                // User exists, update the registeredEvents array
                userRef.updateData([
                    "registeredEvents": FieldValue.arrayUnion([eventId])
                ]) { error in
                    if let error = error {
                        self?.showAlert(message: "Failed to register for event: \(error.localizedDescription)")
                    } else {
                        self?.showAlert(message: "Successfully registered for the event!")
                        self?.checkRegistrationStatus() // Re-check after successful registration
                    }
                }
            } else {
                // User does not exist, create a new record
                userRef.setData([
                    "registeredEvents": [eventId]
                ]) { error in
                    if let error = error {
                        self?.showAlert(message: "Failed to register for event: \(error.localizedDescription)")
                    } else {
                        self?.showAlert(message: "Successfully registered for the event!")
                        self?.checkRegistrationStatus() // Re-check after successful registration
                    }
                }
            }
        }
    }
    
    @objc func onCancelRegistrationTapped() {
        guard let eventId = event?.eventId else {
            showAlert(message: "Event ID not available.")
            return
        }
        
        guard let user = Auth.auth().currentUser else {
            showAlert(message: "You need to sign in to cancel registration.")
            return
        }
        
        let userId = user.uid
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        userRef.updateData([
            "registeredEvents": FieldValue.arrayRemove([eventId])
        ]) { [weak self] error in
            if let error = error {
                self?.showAlert(message: "Failed to cancel registration: \(error.localizedDescription)")
            } else {
                self?.showAlert(message: "Successfully canceled registration for the event!")
                self?.checkRegistrationStatus() // Re-check after successful cancellation
                // Update button immediately to "Book Ticket"
                DispatchQueue.main.async {
                    self?.detailsView.bookTicketButton.setTitle("Book Ticket", for: .normal)
                    self?.detailsView.bookTicketButton.backgroundColor = UIColor(red: 190/255, green: 40/255, blue: 60/255, alpha: 1.0)
                    self?.detailsView.bookTicketButton.removeTarget(nil, action: nil, for: .allEvents)
                    self?.detailsView.bookTicketButton.addTarget(
                        self, action: #selector(self?.onBookTicketTapped), for: .touchUpInside)
                }
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Status",
            message: message,
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
