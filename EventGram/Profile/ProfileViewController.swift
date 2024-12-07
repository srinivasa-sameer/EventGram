//
//  ProfileViewController.swift
//  EventGram
//
//  Created by Srinivasa Sameer Addepalli on 11/29/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController {
    
    let profileScreen = ProfileView()
    
    override func loadView() {
        view = profileScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonLogout = UIButton(type: .system)
        buttonLogout.setTitle("Logout", for: .normal)
        buttonLogout.titleLabel?.font = .boldSystemFont(ofSize: 16)
        buttonLogout.titleLabel?.textColor = .systemRed

        buttonLogout.addTarget(self, action: #selector(onButtonLogoutTapped), for: .touchUpInside)
        let logoutBarButtonItem = UIBarButtonItem(customView: buttonLogout)
                
        navigationItem.rightBarButtonItem = logoutBarButtonItem
    }
    
    @objc func onButtonLogoutTapped(){
        let logoutAlert = UIAlertController(title: "Logging out!", message: "Are you sure want to log out?",
            preferredStyle: .actionSheet)
        logoutAlert.addAction(UIAlertAction(title: "Yes, log out!", style: .default, handler: {(_) in
            do {
                try Auth.auth().signOut()
                let viewController = ViewController()
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.setNavigationBarHidden(true, animated: false)

                // Find the active UIWindowScene
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.rootViewController = navigationController
                    window.makeKeyAndVisible()
                }
            } catch {
                print("Error occurred during logout!")
            }
        }))
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(logoutAlert, animated: true)
    }
}
