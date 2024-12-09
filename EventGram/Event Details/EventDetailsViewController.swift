//
//  EventDetailsViewController.swift
//  EventGram
//
//  Created by Srikar Nallapu on 11/29/24.
//

import CoreLocation
import FirebaseAuth
import FirebaseFirestore
import MapKit
import UIKit

class EventDetailsViewController: UIViewController {

    var event: Event?
    let detailsView = EventDetailsView()
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    private var userLocation: CLLocation?

    override func loadView() {
        view = detailsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        detailsView.mapView.delegate = self
        detailsView.mapView.showsUserLocation = true
        // Customize the details view with event data
        if let event = event {
            if let hostId = event.userId {
                fetchHostName(userId: hostId)
            }

            if let imageUrl = event.imageUrl, let url = URL(string: imageUrl) {
                detailsView.eventImageView.af.setImage(
                    withURL: url, placeholderImage: UIImage(systemName: "photo")
                )
            }
        }

        // Check if the user has already registered for the event
        checkRegistrationStatus()

        // Add action for the book ticket button
        detailsView.bookTicketButton.addTarget(
            self, action: #selector(onBookTicketTapped), for: .touchUpInside)

        setupLocation()

        if let event = event {
            updateUI(with: event)
            searchAndDisplayLocation()
        }
    }

    func fetchHostName(userId: String) {
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument {
            [weak self] (document: DocumentSnapshot?, error: Error?) in
            if let error = error {
                print("Error fetching host data: \(error.localizedDescription)")
                return
            }

            if let document = document,
                let data = document.data(),
                let name = data["name"] as? String
            {
                DispatchQueue.main.async {
                    self?.detailsView.organizerLabel.text = "Hosted by \(name)"
                }
            }
        }
    }

    func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // Request location authorization
        locationManager.requestWhenInUseAuthorization()
    }

    func updateUI(with event: Event) {
        detailsView.titleLabel.text = event.title
        detailsView.descriptionLabel.text = event.description
        //        detailsView.dateLabel.text = DateFormatter.localizedString(
        //            from: event.date,
        //            dateStyle: .medium,
        //            timeStyle: .short
        //        )
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"  // Includes the UTC timezone
        let dateString = dateFormatter.string(from: event.date)
        detailsView.dateLabel.text =
            "\(dateString) at \(event.startTime ?? "00:00")"

        detailsView.locationLabel.text = event.location
    }

    func searchAndDisplayLocation() {
        guard let locationText = event?.location else { return }

        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = locationText
        searchRequest.region = MKCoordinateRegion(.world)

        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] response, error in
            guard let self = self,
                let response = response,
                let firstItem = response.mapItems.first
            else {
                print(
                    "Location search failed: \(error?.localizedDescription ?? "Unknown error")"
                )
                return
            }

            let coordinate = firstItem.placemark.coordinate
            let region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.01, longitudeDelta: 0.01)
            )

            // Add annotation for the location
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = self.event?.location
            annotation.subtitle = locationText

            DispatchQueue.main.async {
                self.detailsView.mapView.removeAnnotations(
                    self.detailsView.mapView.annotations)
                self.detailsView.mapView.addAnnotation(annotation)
                self.detailsView.mapView.setRegion(region, animated: true)
            }
        }
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

            if let document = document,
                let data = document.data(),
                let role = data["role"] as? String
            {

                DispatchQueue.main.async {
                    if role == "Student" {
                        self?.detailsView.bookTicketButton.isHidden = false
                        // Check registration status only for students
                        if let registeredEvents = data["registeredEvents"]
                            as? [String],
                            registeredEvents.contains(eventId)
                        {
                            self?.detailsView.bookTicketButton.setTitle(
                                "Cancel Registration", for: .normal)
                            self?.detailsView.bookTicketButton.backgroundColor =
                                .black
                            self?.detailsView.bookTicketButton.removeTarget(
                                nil, action: nil, for: .allEvents)
                            self?.detailsView.bookTicketButton.addTarget(
                                self,
                                action: #selector(
                                    self?.onCancelRegistrationTapped),
                                for: .touchUpInside)
                        } else {
                            self?.detailsView.bookTicketButton.setTitle(
                                "Book Ticket", for: .normal)
                            self?.detailsView.bookTicketButton.backgroundColor =
                                UIColor(
                                    red: 190 / 255,
                                    green: 40 / 255,
                                    blue: 60 / 255,
                                    alpha: 1.0)
                        }
                    } else if role == "Club Admin" {
                        self?.detailsView.bookTicketButton.isHidden = true
                    }
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
                self?.showAlert(
                    message:
                        "Error fetching user data: \(error.localizedDescription)"
                )
                return
            }
            if let document = document, document.exists {
                userRef.updateData([
                    "registeredEvents": FieldValue.arrayUnion([eventId])
                ]) { error in
                    if let error = error {
                        self?.showAlert(
                            message:
                                "Failed to register for event: \(error.localizedDescription)"
                        )
                    } else {
                        self?.showAlert(
                            message: "Successfully registered for the event!")
                        self?.checkRegistrationStatus()  // Re-check after successful registration
                    }
                }
            } else {
                // User does not exist, create a new record
                userRef.setData([
                    "registeredEvents": [eventId]
                ]) { error in
                    if let error = error {
                        self?.showAlert(
                            message:
                                "Failed to register for event: \(error.localizedDescription)"
                        )
                    } else {
                        self?.showAlert(
                            message: "Successfully registered for the event!")
                        self?.checkRegistrationStatus()  // Re-check after successful registration
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
                self?.showAlert(
                    message:
                        "Failed to cancel registration: \(error.localizedDescription)"
                )
            } else {
                self?.showAlert(
                    message: "Successfully canceled registration for the event!"
                )
                self?.checkRegistrationStatus()  // Re-check after successful cancellation
                // Update button immediately to "Book Ticket"
                DispatchQueue.main.async {
                    self?.detailsView.bookTicketButton.setTitle(
                        "Book Ticket", for: .normal)
                    self?.detailsView.bookTicketButton.backgroundColor =
                        UIColor(
                            red: 190 / 255, green: 40 / 255, blue: 60 / 255,
                            alpha: 1.0)
                    self?.detailsView.bookTicketButton.removeTarget(
                        nil, action: nil, for: .allEvents)
                    self?.detailsView.bookTicketButton.addTarget(
                        self, action: #selector(self?.onBookTicketTapped),
                        for: .touchUpInside)
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

// MARK: - CLLocationManagerDelegate
extension EventDetailsViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
            detailsView.mapView.showsUserLocation = true
        case .denied, .restricted:
            showLocationAlert()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }

    func locationManager(
        _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            userLocation = location
        }
    }

    func showLocationAlert() {
        let alert = UIAlertController(
            title: "Location Access Required",
            message:
                "Please enable location access in Settings to see the event location.",
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "Settings", style: .default) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }
}

// In EventDetailsViewController
extension EventDetailsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)
        -> MKAnnotationView?
    {
        let identifier = "EventLocation"
        var annotationView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(
                annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true

            // Add directions button to callout
            let directionsButton = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = directionsButton
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    //   func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    //        guard let annotation = view.annotation else { return }
    //
    //        let placemark = MKPlacemark(coordinate: annotation.coordinate)
    //        let mapItem = MKMapItem(placemark: placemark)
    //        mapItem.name = annotation.title ?? "Event Location"
    //
    //        mapItem.openInMaps(launchOptions: [
    //            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
    //        ])

    // }

    func mapView(
        _ mapView: MKMapView, annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl
    ) {
        guard let annotation = view.annotation else { return }

        let destinationPlacemark = MKPlacemark(
            coordinate: annotation.coordinate)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        destinationItem.name = annotation.title ?? "Event Location"

        // Use current location if available
        let launchOptions: [String: Any] = [
            MKLaunchOptionsDirectionsModeKey:
                MKLaunchOptionsDirectionsModeDriving,
            MKLaunchOptionsShowsTrafficKey: true,
        ]

        if let userLocation = userLocation {
            let sourcePlacemark = MKPlacemark(
                coordinate: userLocation.coordinate)
            let sourceItem = MKMapItem(placemark: sourcePlacemark)
            MKMapItem.openMaps(
                with: [sourceItem, destinationItem],
                launchOptions: launchOptions)
        } else {
            destinationItem.openInMaps(launchOptions: launchOptions)
        }
    }
}
