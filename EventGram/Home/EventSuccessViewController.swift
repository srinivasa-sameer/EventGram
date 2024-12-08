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
        // First dismiss all presented view controllers until we reach the tab bar controller
        view.window?.rootViewController?.dismiss(animated: true) { [weak self] in
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first,
               let tabBarController = window.rootViewController as? UITabBarController {
                // Switch to Profile tab (index 2)
                tabBarController.selectedIndex = 2
                // Remove any presented view controllers in the profile tab
                if let navigationController = tabBarController.selectedViewController as? UINavigationController {
                    navigationController.popToRootViewController(animated: true)
                }
            }
        }
    }
}
