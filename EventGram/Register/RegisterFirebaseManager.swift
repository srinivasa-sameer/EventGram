//
//  RegisterFirebaseManager.swift
//  EventGram
//
//  Created by Vidhi Thacker on 11/14/24.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

//extension RegisterViewController {
//
//    func registerNewAccount(){
//        showActivityIndicator()
//
//        guard let firstname = registerView.firstNameTextField.text,
//              let lastname = registerView.lastNameTextField.text,
//              let email = registerView.emailTextField.text,
//              let university = registerView.universityTextField.text,
//              let password = registerView.passwordTextField.text,
//              let retypePassword = registerView.retypePasswordTextField.text else {
//            // Handle the case where the fields are not filled
//            showAlert(message: "Please fill in all fields.")
//            return
//        }
//
//        // Validate the email format
//        guard isValidNortheasternEmail(email) else {
//            showAlert(message: "Please use a valid Northeastern email address.")
//            return
//        }
//
//        // Check if the passwords match
//        guard password == retypePassword else {
//            // If they don't match, show an alert and return
//            showAlert(message: "The passwords do not match.")
//            return
//        }
//
//        // Continue with Firebase user creation as the passwords match
//        Auth.auth().createUser(withEmail: email, password: password, completion: { result, error in
//            self.hideActivityIndicator()
//            if let error = error {
//                // Handle the error case
//                self.showAlert(message: "Error creating user: \(error.localizedDescription)")
//            } else if let uid = result?.user.uid {
//                // The user creation is successful, continue with setting the name and adding to Firestore
//                self.setNameOfTheUserInFirebaseAuth(name: firstName, uid: uid)
//                self.addUserToFirestore(uid: uid, name: name, email: email)
//            }
//        })
//    }
//
//    private func isValidNortheasternEmail(_ email: String) -> Bool {
//        let emailRegex = "^[A-Za-z0-9._%+-]+@northeastern\\.edu$"
//        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
//        return emailPredicate.evaluate(with: email)
//    }
//
//    private func showAlert(message: String) {
//        self.hideActivityIndicator()
//        let alert = UIAlertController(title: "Registration Error", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        self.present(alert, animated: true)
//    }
//
//    func setNameOfTheUserInFirebaseAuth(name: String, uid: String){
//        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
//        changeRequest?.displayName = name
//        changeRequest?.commitChanges(completion: {(error) in
//            if error == nil{
//                self.hideActivityIndicator()
//                self.navigationController?.popViewController(animated: true)
//            } else {
//                print("Error occured: \(String(describing: error))")
//            }
//        })
//    }
//
//    func addUserToFirestore(uid: String, name: String, email: String) {
//        let db = Firestore.firestore()
//        db.collection("users").document(uid).setData([
//            "uid": uid,
//            "name": name,
//            "email": email
//        ]) { error in
//            self.hideActivityIndicator()
//            if let error = error {
//                print("Error writing document: \(error.localizedDescription)")
//            } else {
//                // User added to Firestore, proceed to main screen or show success message
//                print("User document successfully written!")
//            }
//        }
//    }
//}

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
