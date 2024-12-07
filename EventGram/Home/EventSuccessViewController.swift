//
//  EventSuccessViewController.swift
//  EventGram
//
//  Created by Srinivasa Sameer Addepalli on 12/7/24.
//

import UIKit

class EventSuccessViewController: UIViewController {
    
    let successScreen = EventSuccessView()
    var eventTitle: String?
    var eventDate: String?
    
    override func loadView() {
        view = successScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        successScreen.eventTitleLabel.text = eventTitle
        successScreen.eventDateLabel.text = eventDate
        
        successScreen.goToEventsButton.addTarget(self, action: #selector(goToEventsTapped), for: .touchUpInside)
        successScreen.viewDetailsButton.addTarget(self, action: #selector(viewDetailsTapped), for: .touchUpInside)
    }
    
    @objc func goToEventsTapped() {
        dismiss(animated: true) { [weak self] in
            let profileViewController = ProfileViewController()
            self?.navigationController?.pushViewController(profileViewController, animated: true)
        }
    }
    
    @objc func viewDetailsTapped() {
        // Navigate to event details
        let eventsViewController = EventsViewController()
        // Set event details here
        navigationController?.pushViewController(eventsViewController, animated: true)
        print("Tapped")
    }
}
