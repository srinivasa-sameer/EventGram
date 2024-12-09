//
//  RegisterViewController.swift
//  EventGram
//
//  Created by Vidhi Thacker on 11/29/24.
//

import FirebaseAuth
import FirebaseFirestore
import UIKit

class RegisterViewController: UIViewController {

    let registerView = RegisterView()

    let childProgressView = ProgressSpinnerViewController()

    override func loadView() {
        view = registerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)

        navigationController?.navigationBar.prefersLargeTitles = true
        registerView.createAccountButton.addTarget(
            self, action: #selector(onRegisterTapped), for: .touchUpInside)

        registerView.loginPromptButton.addTarget(
            self, action: #selector(onLoginTapped), for: .touchUpInside)
    }

    @objc func onLoginTapped() {
        let loginViewController = LoginViewController()
        navigationController?.pushViewController(
            loginViewController, animated: true)
    }

    @objc func hideKeyboardOnTap() {
        view.endEditing(true)
    }

    @objc func onRegisterTapped() {
        registerNewAccount()
    }
}

extension RegisterViewController: ProgressSpinnerDelegate {
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
