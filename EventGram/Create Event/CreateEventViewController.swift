//
//  CreateEventViewController.swift
//  EventGram
//
//  Created by Srikar Nallapu on 11/29/24.
//

import UIKit
import FirebaseFirestore

class CreateEventViewController: UIViewController {
    
    var delegate: EventsViewController!
    let createEventView = CreateEventView()
    let db = Firestore.firestore() // Firestore reference
    
    override func loadView() {
        view = createEventView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //configureNavigationBar()
        setupActions()
    }
    

    func configureNavigationBar() {
            //navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .close,
                target: self,
                action: #selector(dismissView)
            )
        }

        func setupActions() {
            createEventView.createEventButton.addTarget(
                self,
                action: #selector(createEventButtonTapped),
                for: .touchUpInside
            )

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            createEventView.addGestureRecognizer(tapGesture)
        }

        @objc func dismissView() {
            dismiss(animated: true, completion: nil)
        }

        @objc func createEventButtonTapped() {
            guard let title = createEventView.eventTitleTextField.text, !title.isEmpty,
                  let description = createEventView.eventDescriptionTextView.text, !description.isEmpty,
                  let address = createEventView.addressTextField.text, !address.isEmpty,
                  let startTime = createEventView.startTimeTextField.text, !startTime.isEmpty,
                  let endTime = createEventView.endTimeTextField.text, !endTime.isEmpty,
                  let startDate = createEventView.startDateTextField.text, !startDate.isEmpty else {
                      showAlert(title: "Missing Fields", message: "Please fill in all required fields marked with *")
                      return
                  }

            // Create a dictionary for the event
            let event: [String: Any] = [
                "title": title,
                "description": description,
                "address": address,
                "startTime": startTime,
                "endTime": endTime,
                "startDate": startDate,
                "timestamp": Timestamp(date: Date()) // Add a timestamp for sorting
            ]

            // Push to Firestore
            db.collection("events").addDocument(data: event) { error in
                if let error = error {
                    print("Error adding event: \(error.localizedDescription)")
                    self.showAlert(title: "Error", message: "Failed to create the event. Please try again.")
                } else {
                    print("Event added successfully")
                    self.showAlert(title: "Success", message: "Event created successfully!")
                }
            }
        }

        @objc func dismissKeyboard() {
            view.endEditing(true)
        }

        func showAlert(title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    

}
