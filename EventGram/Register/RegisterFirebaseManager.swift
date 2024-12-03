//
//  RegisterFirebaseManager.swift
//  EventGram
//
//  Created by Vidhi Thacker on 11/14/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

extension RegisterViewController {
    
    func registerNewAccount(){
        showActivityIndicator()
        
        guard let name = registerView.textFieldName.text,
              let email = registerView.textFieldEmail.text,
              let password = registerView.textFieldPassword.text,
              let repeatPassword = registerView.textFieldRepeatPassword.text else {
            // Handle the case where the fields are not filled
            showAlert(message: "Please fill in all fields.")
            return
        }
        
        // Validate the email format
        guard isValidNortheasternEmail(email) else {
            showAlert(message: "Please use a valid Northeastern email address.")
            return
        }
        
        // Check if the passwords match
        guard password == repeatPassword else {
            // If they don't match, show an alert and return
            showAlert(message: "The passwords do not match.")
            return
        }
        
        // Continue with Firebase user creation as the passwords match
        Auth.auth().createUser(withEmail: email, password: password, completion: { result, error in
            self.hideActivityIndicator()
            if let error = error {
                // Handle the error case
                self.showAlert(message: "Error creating user: \(error.localizedDescription)")
            } else if let uid = result?.user.uid {
                // The user creation is successful, continue with setting the name and adding to Firestore
                self.setNameOfTheUserInFirebaseAuth(name: name, uid: uid)
                self.addUserToFirestore(uid: uid, name: name, email: email)
            }
        })
    }
    
    private func isValidNortheasternEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@northeastern\\.edu$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func showAlert(message: String) {
        self.hideActivityIndicator()
        let alert = UIAlertController(title: "Registration Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    func setNameOfTheUserInFirebaseAuth(name: String, uid: String){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges(completion: {(error) in
            if error == nil{
                self.hideActivityIndicator()
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Error occured: \(String(describing: error))")
            }
        })
    }
    
    func addUserToFirestore(uid: String, name: String, email: String) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).setData([
            "uid": uid,
            "name": name,
            "email": email
        ]) { error in
            self.hideActivityIndicator()
            if let error = error {
                print("Error writing document: \(error.localizedDescription)")
            } else {
                // User added to Firestore, proceed to main screen or show success message
                print("User document successfully written!")
            }
        }
    }
}
