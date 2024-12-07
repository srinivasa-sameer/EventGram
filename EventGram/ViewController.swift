//
//  ViewController.swift
//  EventGram
//
//  Created by Vidhi Thacker on 11/29/24.
//

import FirebaseAuth
import FirebaseFirestore
import UIKit

class ViewController: UIViewController {
    let registerScreen = RegisterView()
    let loginView = LoginView()
    let eventDetailsView = EventDetailsView()
    let landingPage = LandingPage()
    let createEventScreen = CreateEventView()

    var handleAuth: AuthStateDidChangeListenerHandle?
    var currentUser: FirebaseAuth.User?

    override func loadView() {
        view = landingPage
    }

    @objc func hideKeyboardOnTap() {
        view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        landingPage.getStartedButton.addTarget(
            self, action: #selector(getStartedTapped), for: .touchUpInside)

        let tapRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }

    @objc private func getStartedTapped() {
        let loginScreenController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginScreenController)
        navigationController.setNavigationBarHidden(true, animated: false)
//        let profileViewController = ProfileViewController()
//        let navigationController = UINavigationController(rootViewController: profileViewController)
//        navigationController.setNavigationBarHidden(true, animated: false)
        // Find the active UIWindowScene
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
        
        //setupAuthListener()
    }
}
