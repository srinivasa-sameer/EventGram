//
//  RegisterFirebaseManager.swift
//  EventGram
//
//  Created by Vidhi Thacker on 11/14/24.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

extension RegisterViewController {

    func registerNewAccount() {
        showActivityIndicator()

        guard let firstName = registerView.firstNameTextField.text,
            let lastName = registerView.lastNameTextField.text,
            let email = registerView.emailTextField.text,
            let university = registerView.universityTextField.text,
            let password = registerView.passwordTextField.text,
            let retypePassword = registerView.retypePasswordTextField.text,
            !firstName.isEmpty,
            !lastName.isEmpty,
            !email.isEmpty,
            !university.isEmpty,
            !password.isEmpty,
            !retypePassword.isEmpty
        else {
            showAlert(message: "Please fill in all fields.")
            return
        }

        // Validate the email format
        guard isValidNortheasternEmail(email) else {
            showAlert(message: "Please use a valid Northeastern email address.")
            return
        }

        // Check if the passwords match
        guard password == retypePassword else {
            showAlert(message: "The passwords do not match.")
            return
        }

        // Continue with Firebase user creation
        Auth.auth().createUser(withEmail: email, password: password) {
            [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                self.hideActivityIndicator()
                self.showAlert(
                    message:
                        "Error creating user: \(error.localizedDescription)")
                return
            }

            // Create Tab Bar Controller
            let tabBarController = UITabBarController()

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
            self.present(tabBarController, animated: true)

            if let uid = result?.user.uid {
                let fullName = "\(firstName) \(lastName)"
                // Set display name and add user to Firestore
                self.setNameOfTheUserInFirebaseAuth(name: fullName, uid: uid)

                // Create user data dictionary
                let userData: [String: Any] = [
                    "uid": uid,
                    "firstName": firstName,
                    "lastName": lastName,
                    "email": email,
                    "university": university,
                    "createdAt": FieldValue.serverTimestamp(),
                ]

                self.addUserToFirestore(uid: uid, userData: userData)
            }
        }
    }

    private func isValidNortheasternEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@northeastern\\.edu$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    private func showAlert(message: String) {
        hideActivityIndicator()
        let alert = UIAlertController(
            title: "Registration Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func setNameOfTheUserInFirebaseAuth(name: String, uid: String) {
        let changeRequest = Auth.auth().currentUser?
            .createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                self.hideActivityIndicator()
                self.showAlert(
                    message:
                        "Error updating profile: \(error.localizedDescription)")
            }
        }
    }

    func addUserToFirestore(uid: String, userData: [String: Any]) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).setData(userData) {
            [weak self] error in
            guard let self = self else { return }
            self.hideActivityIndicator()

            if let error = error {
                self.showAlert(
                    message:
                        "Error saving user data: \(error.localizedDescription)")
                return
            }

            // Successfully created user, navigate to main screen
            let eventViewController = EventsViewController()
            let navigationController = UINavigationController(
                rootViewController: eventViewController)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(
                navigationController, animated: true, completion: nil)
        }
    }
}
