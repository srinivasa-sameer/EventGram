//
//  LoginView.swift
//  EventGram
//
//  Created by Srinivasa Sameer Addepalli on 11/29/24.
//

import UIKit

class LoginView: UIView {

    var welcomeLabel: UILabel!
    var eventGramLabel: UILabel!
    var subtitleLabel: UILabel!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var signInButton: UIButton!
    var createAccountButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white

        setupWelcomeLabel()
        setupEventGramLabel()
        setupSubtitleLabel()
        setupEmailTextField()
        setupPasswordTextField()
        setupSignInButton()
        setupCreateAccountButton()
        initConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupWelcomeLabel() {
        welcomeLabel = UILabel()
        welcomeLabel.text = "Welcome to"
        welcomeLabel.font = .systemFont(ofSize: 24)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(welcomeLabel)
    }

    func setupEventGramLabel() {
        eventGramLabel = UILabel()
        eventGramLabel.text = "EventGram"
        eventGramLabel.textColor = UIColor(
            red: 190 / 255, green: 40 / 255, blue: 60 / 255, alpha: 1.0)
        eventGramLabel.font = .systemFont(ofSize: 24, weight: .bold)
        eventGramLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(eventGramLabel)
    }

    func setupSubtitleLabel() {
        subtitleLabel = UILabel()
        subtitleLabel.text = "Enter your email and password to sign in!"
        subtitleLabel.textColor = .gray
        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subtitleLabel)
    }

    func setupEmailTextField() {
        emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(emailTextField)
    }

    func setupPasswordTextField() {
        passwordTextField = UITextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(passwordTextField)
    }

    func setupSignInButton() {
        signInButton = UIButton()
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.backgroundColor = UIColor(
            red: 190 / 255, green: 40 / 255, blue: 60 / 255, alpha: 1.0)
        signInButton.layer.cornerRadius = 25
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(signInButton)
    }

    func setupCreateAccountButton() {
        createAccountButton = UIButton()
        createAccountButton.setTitle(
            "Don't have an account yet? Create Account", for: .normal)
        createAccountButton.setTitleColor(.black, for: .normal)
        createAccountButton.titleLabel?.font = .systemFont(ofSize: 14)
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(createAccountButton)
    }

    func initConstraints() {
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            welcomeLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 20),

            eventGramLabel.topAnchor.constraint(
                equalTo: welcomeLabel.topAnchor),
            eventGramLabel.leadingAnchor.constraint(
                equalTo: welcomeLabel.trailingAnchor, constant: 8),

            subtitleLabel.topAnchor.constraint(
                equalTo: welcomeLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 20),

            emailTextField.topAnchor.constraint(
                equalTo: subtitleLabel.bottomAnchor, constant: 30),
            emailTextField.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),

            passwordTextField.topAnchor.constraint(
                equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),

            signInButton.bottomAnchor.constraint(
                equalTo: createAccountButton.topAnchor, constant: -8),
            signInButton.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 20),
            signInButton.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -20),
            signInButton.heightAnchor.constraint(equalToConstant: 50),

            createAccountButton.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            createAccountButton.centerXAnchor.constraint(
                equalTo: centerXAnchor),
        ])
    }
}
