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

        navigationController?.navigationBar.prefersLargeTitles = true

        let tapRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }

    @objc private func getStartedTapped() {
        // Switch to main screen
        //view = loginView
        let loginScreen = LoginViewController()
        navigationController?.pushViewController(loginScreen, animated: true)
        setupAuthListener()
    }

    private func setupAuthListener() {
        handleAuth = Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                self.currentUser = nil
                //self.mainScreen.labelText.text ="Please sign in to access events."
                //self.setupRightBarButton(isLoggedin: false)
            } else {
                self.currentUser = user
                //self.mainScreen.labelText.text ="Welcome \(user?.displayName ?? "Anonymous")!"
                //self.setupRightBarButton(isLoggedin: true)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let handleAuth = handleAuth {
            Auth.auth().removeStateDidChangeListener(handleAuth)
        }
    }
}
