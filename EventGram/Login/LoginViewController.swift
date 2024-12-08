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

                // Create Tab Bar Controller
                let tabBarController = UITabBarController()
                tabBarController.delegate = self // Assign delegate here

                // Home Tab
                let eventsVC = EventsViewController()
                let eventsNav = UINavigationController(
                    rootViewController: eventsVC)
                eventsNav.tabBarItem = UITabBarItem(
                    title: "Home",
                    image: UIImage(systemName: "house"),
                    selectedImage: UIImage(systemName: "house.fill")
                )

                // Create Event Tab
                let createEventVC = CreateEventViewController()
                let createEventNav = UINavigationController(
                    rootViewController: createEventVC)
                createEventNav.tabBarItem = UITabBarItem(
                    title: "Create",
                    image: UIImage(systemName: "plus.circle"),
                    selectedImage: UIImage(systemName: "plus.circle.fill")
                )

                // Profile Tab
                let profileVC = ProfileViewController()
                let profileNav = UINavigationController(
                    rootViewController: profileVC)
                profileNav.tabBarItem = UITabBarItem(
                    title: "Profile",
                    image: UIImage(systemName: "person"),
                    selectedImage: UIImage(systemName: "person.fill")
                )

                // Setup Tab Bar
                tabBarController.viewControllers = [
                    eventsNav, createEventNav, profileNav,
                ]
                tabBarController.tabBar.tintColor = UIColor(
                    red: 190 / 255, green: 40 / 255, blue: 60 / 255, alpha: 1.0)
                tabBarController.tabBar.backgroundColor = .white

                // Present Tab Bar Controller
                tabBarController.modalPresentationStyle = .fullScreen
                self?.present(tabBarController, animated: true)
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

extension LoginViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Reset navigation stack of the selected tab
        if let navigationController = viewController as? UINavigationController {
            navigationController.popToRootViewController(animated: false)
        }
    }
}
