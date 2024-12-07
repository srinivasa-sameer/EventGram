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
    }
    
    @objc func goToEventsTapped() {
        dismiss(animated: true) { [weak self] in
            let eventsViewController = EventsViewController()
            self?.navigationController?.pushViewController(eventsViewController, animated: true)
        }
    }
}
