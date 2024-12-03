//
//  ViewController.swift
//  EventGram
//
//  Created by Vidhi Thacker on 11/29/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {
    let mainScreen = MainScreenView()
    let childProgressView = ProgressSpinnerViewController()
    
    var handleAuth: AuthStateDidChangeListenerHandle?
    var currentUser:FirebaseAuth.User?
    
    override func loadView() {
        view = mainScreen
    }
    
    @objc func hideKeyboardOnTap(){
        view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "EventGram"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
          if user == nil{
              self.currentUser = nil
              self.mainScreen.labelText.text = "Please sign in to access events."
              self.setupRightBarButton(isLoggedin: false)
          } else {
              self.currentUser = user
              self.mainScreen.labelText.text = "Welcome \(user?.displayName ?? "Anonymous")!"
              self.setupRightBarButton(isLoggedin: true)
          }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         Auth.auth().removeStateDidChangeListener(handleAuth!)
     }
}
