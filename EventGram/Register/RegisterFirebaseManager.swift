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

        guard let name = registerView.nameTextField.text,
            let email = registerView.emailTextField.text,
            let university = registerView.universityTextField.text,
            let password = registerView.passwordTextField.text,
            let retypePassword = registerView.retypePasswordTextField.text,
            let accessCode = registerView.accessCodeTextField.text,
            !name.isEmpty,
            !email.isEmpty,
            !university.isEmpty,
            !password.isEmpty,
            !retypePassword.isEmpty
        else {
            showAlert(message: "Please fill in all fields.")
            return
        }

        guard isValidNortheasternEmail(email) else {
            showAlert(message: "Please use a valid Northeastern email address.")
            return
        }

        guard password == retypePassword else {
            showAlert(message: "The passwords do not match.")
            return
        }

        if !accessCode.isEmpty {
            guard accessCode == "1289" else {
                showAlert(message: "Wrong access code.")
                return
            }
        }

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

            let tabBarController = UITabBarController()

            let eventsVC = EventsViewController()
            let eventsNav = UINavigationController(
                rootViewController: eventsVC)
            eventsNav.tabBarItem = UITabBarItem(
                title: "Home",
                image: UIImage(systemName: "house"),
                selectedImage: UIImage(systemName: "house.fill")
            )

            let createEventVC = CreateEventViewController()
            let createEventNav = UINavigationController(
                rootViewController: createEventVC)
            createEventNav.tabBarItem = UITabBarItem(
                title: "Create",
                image: UIImage(systemName: "plus.circle"),
                selectedImage: UIImage(systemName: "plus.circle.fill")
            )

            let searchVC = SearchViewController()
            let searchNav = UINavigationController(
                rootViewController: searchVC)
            searchNav.tabBarItem = UITabBarItem(
                title: "Search",
                image: UIImage(systemName: "magnifyingglass"),
                selectedImage: UIImage(systemName: "magnifyingglass.fill")
            )

            let profileVC = ProfileViewController()
            let profileNav = UINavigationController(
                rootViewController: profileVC)
            profileNav.tabBarItem = UITabBarItem(
                title: "Profile",
                image: UIImage(systemName: "person"),
                selectedImage: UIImage(systemName: "person.fill")
            )

            guard let user = Auth.auth().currentUser else { return }
            let userId = user.uid
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(userId)

            userRef.getDocument { document, error in
                if let error = error {
                    print(
                        "Error fetching user data: \(error.localizedDescription)"
                    )
                    return
                }

                if let document = document,
                    let data = document.data(),
                    let role = data["role"] as? String
                {
                    if role == "Student" {
                        tabBarController.viewControllers = [
                            eventsNav, searchNav, profileNav,
                        ]
                    } else {
                        tabBarController.viewControllers = [
                            eventsNav, createEventNav, profileNav,
                        ]
                    }
                }
            }

            tabBarController.tabBar.tintColor = UIColor(
                red: 190 / 255, green: 40 / 255, blue: 60 / 255, alpha: 1.0)
            tabBarController.tabBar.backgroundColor = .white

            tabBarController.modalPresentationStyle = .fullScreen
            self.present(tabBarController, animated: true)

            if let uid = result?.user.uid {
                let name = "\(name)"
                self.setNameOfTheUserInFirebaseAuth(name: name, uid: uid)

                if !accessCode.isEmpty {
                    let userData: [String: Any] = [
                        "uid": uid,
                        "name": name,
                        "email": email,
                        "university": university,
                        "createdAt": FieldValue.serverTimestamp(),
                        "accessCode": accessCode,
                        "role": "Club Admin",
                    ]
                    self.addUserToFirestore(uid: uid, userData: userData)
                } else {
                    let userData: [String: Any] = [
                        "uid": uid,
                        "name": name,
                        "email": email,
                        "university": university,
                        "createdAt": FieldValue.serverTimestamp(),
                        "role": "Student",
                    ]
                    self.addUserToFirestore(uid: uid, userData: userData)
                }
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

            let eventViewController = EventsViewController()
            let navigationController = UINavigationController(
                rootViewController: eventViewController)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(
                navigationController, animated: true, completion: nil)
        }
    }
}
