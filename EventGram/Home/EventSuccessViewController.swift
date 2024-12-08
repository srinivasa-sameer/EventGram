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

        successScreen.goToEventsButton.addTarget(
            self, action: #selector(goToEventsTapped), for: .touchUpInside)
    }

    @objc func goToEventsTapped() {
        guard let navigationController = self.navigationController else {
                return
        }
        
        // Find the EventsViewController in the navigation stack
        for viewController in navigationController.viewControllers {
            if let eventsVC = viewController as? EventsViewController {
                navigationController.popToViewController(eventsVC, animated: true)
                return
            }
        }
        
        // If not found, create a new one and set it
        let eventsViewController = EventsViewController()
        navigationController.setViewControllers([eventsViewController], animated: true)

    }


}
