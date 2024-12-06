//
//  LoginViewController.swift
//  EventGram
//
//  Created by Srinivasa Sameer Addepalli on 11/29/24.
//

import FirebaseAuth
import UIKit

class LoginViewController: UIViewController {

    let loginScreen = LoginView()
    let eventsScreen = EventsView()
    let childProgressView = ProgressSpinnerViewController()

    var handleAuth: AuthStateDidChangeListenerHandle?
    var currentUser: FirebaseAuth.User?

    override func loadView() {
        view = loginScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //title = "Login"

        // Add targets for buttons
        loginScreen.signInButton.addTarget(
            self, action: #selector(onSignInTapped), for: .touchUpInside)
        loginScreen.createAccountButton.addTarget(
            self, action: #selector(onCreateAccountTapped), for: .touchUpInside)

        // Add tap gesture to dismiss keyboard
        let tapRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }

    @objc func hideKeyboardOnTap() {
        view.endEditing(true)
    }

    @objc func onSignInTapped() {
        // Validate inputs
        if let email = loginScreen.emailTextField.text,
            let password = loginScreen.passwordTextField.text
        {
            if email.isEmpty || password.isEmpty {
                showAlert(message: "Please fill in all fields!")
                return
            }

            // Show progress indicator
            showActivityIndicator()

            // Sign in with Firebase
            Auth.auth().signIn(withEmail: email, password: password) {
                [weak self] authResult, error in
                self?.hideActivityIndicator()

                if let error = error {
                    self?.showAlert(message: error.localizedDescription)
                    return
                }

                // Navigate to main screen on success
                //                if let welcomeScreen = self?.navigationController?.viewControllers.first {
                //                    self?.navigationController?.popToViewController(welcomeScreen, animated: true)
                //                }
                let eventViewController = EventsViewController()
                let navigationController = UINavigationController(
                    rootViewController: eventViewController)
                navigationController.modalPresentationStyle = .fullScreen
                self?.present(
                    navigationController, animated: true, completion: nil)
            }
        }
    }

    @objc func onCreateAccountTapped() {
        let registerViewController = RegisterViewController()
        navigationController?.pushViewController(
            registerViewController, animated: true)
    }

    func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default))

        self.present(alert, animated: true)
    }
}

extension LoginViewController: ProgressSpinnerDelegate {
    func showActivityIndicator() {
        addChild(childProgressView)
        view.addSubview(childProgressView.view)
        childProgressView.didMove(toParent: self)
    }

    func hideActivityIndicator() {
        childProgressView.willMove(toParent: nil)
        childProgressView.view.removeFromSuperview()
        childProgressView.removeFromParent()
    }
}
