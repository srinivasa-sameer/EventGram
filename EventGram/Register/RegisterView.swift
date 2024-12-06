//
//  RegisterView.swift
//  EventGram
//
//  Created by Vidhi Thacker on 11/29/24.
//

import UIKit

class RegisterView: UIView {
    
    var welcomeLabel: UILabel!
    var eventGramLabel: UILabel!
    var subtitleLabel: UILabel!
    var firstNameTextField: UITextField!
    var lastNameTextField: UITextField!
    var emailTextField: UITextField!
    var universityTextField: UITextField!
    var passwordTextField: UITextField!
    var retypePasswordTextField: UITextField!
    var createAccountButton: UIButton!
    var loginPromptButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupWelcomeLabel()
        setupEventGramLabel()
        setupSubtitleLabel()
        setupFirstNameTextField()
        setupLastNameTextField()
        setupEmailTextField()
        setupUniversityTextField()
        setupPasswordTextField()
        setupRetypePasswordTextField()
        setupCreateAccountButton()
        setupLoginPromptButton()
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
        eventGramLabel.textColor = UIColor(red: 190/255, green: 40/255, blue: 60/255, alpha: 1.0)
        eventGramLabel.font = .systemFont(ofSize: 24, weight: .bold)
        eventGramLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(eventGramLabel)
    }
    
    func setupSubtitleLabel() {
        subtitleLabel = UILabel()
        subtitleLabel.text = "Add your basic details, to get onboard!"
        subtitleLabel.textColor = .gray
        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subtitleLabel)
    }
    
    func setupFirstNameTextField() {
        firstNameTextField = UITextField()
        firstNameTextField.placeholder = "First Name"
        firstNameTextField.borderStyle = .roundedRect
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(firstNameTextField)
    }
    
    func setupLastNameTextField() {
        lastNameTextField = UITextField()
        lastNameTextField.placeholder = "Last Name"
        lastNameTextField.borderStyle = .roundedRect
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lastNameTextField)
    }
    
    func setupEmailTextField() {
        emailTextField = UITextField()
        emailTextField.placeholder = "Email (.edu email)"
        emailTextField.borderStyle = .roundedRect
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(emailTextField)
    }
    
    func setupUniversityTextField() {
        universityTextField = UITextField()
        universityTextField.placeholder = "University Name"
        universityTextField.borderStyle = .roundedRect
        universityTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(universityTextField)
    }
    
    func setupPasswordTextField() {
        passwordTextField = UITextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(passwordTextField)
    }
    
    func setupRetypePasswordTextField() {
        retypePasswordTextField = UITextField()
        retypePasswordTextField.placeholder = "Re-Type Password"
        retypePasswordTextField.isSecureTextEntry = true
        retypePasswordTextField.borderStyle = .roundedRect
        retypePasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(retypePasswordTextField)
    }
    
    func setupCreateAccountButton() {
        createAccountButton = UIButton()
        createAccountButton.setTitle("Create Account", for: .normal)
        createAccountButton.backgroundColor = UIColor(red: 190/255, green: 40/255, blue: 60/255, alpha: 1.0)
        createAccountButton.layer.cornerRadius = 25
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(createAccountButton)
    }
    
    func setupLoginPromptButton() {
        loginPromptButton = UIButton()
        loginPromptButton.setTitle("Already have an account? Login", for: .normal)
        loginPromptButton.setTitleColor(.black, for: .normal)
        loginPromptButton.titleLabel?.font = .systemFont(ofSize: 14)
        loginPromptButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(loginPromptButton)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            welcomeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            eventGramLabel.topAnchor.constraint(equalTo: welcomeLabel.topAnchor),
            eventGramLabel.leadingAnchor.constraint(equalTo: welcomeLabel.trailingAnchor, constant: 8),
            
            subtitleLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            firstNameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            firstNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            firstNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 16),
            lastNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            lastNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emailTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 16),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            universityTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            universityTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            universityTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            universityTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: universityTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            retypePasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            retypePasswordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            retypePasswordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            retypePasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            

            createAccountButton.bottomAnchor.constraint(equalTo: loginPromptButton.topAnchor, constant: -8),
            createAccountButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            createAccountButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            createAccountButton.heightAnchor.constraint(equalToConstant: 50),
            
            loginPromptButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            loginPromptButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
