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
    var nameTextField: UITextField!
    var emailTextField: UITextField!
    var universityTextField: UITextField!
    var passwordTextField: UITextField!
    var retypePasswordTextField: UITextField!
    var clubLabel: UILabel!
    var accessCodeTextField: UITextField!
    var createAccountButton: UIButton!
    var loginPromptButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupWelcomeLabel()
        setupEventGramLabel()
        setupSubtitleLabel()
        setupNameTextField()
        setupEmailTextField()
        setupUniversityTextField()
        setupPasswordTextField()
        setupRetypePasswordTextField()
        setupClubLabel()
        setupAccessCodeTextField()
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
    
    func setupNameTextField() {
        nameTextField = UITextField()
        nameTextField.placeholder = "Name"
        nameTextField.borderStyle = .roundedRect
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameTextField)
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
    
    func setupClubLabel(){
        clubLabel = UILabel()
        clubLabel.text = "Want to register as a club? Please enter the Access Code given to you!"
        clubLabel.numberOfLines = 2
        clubLabel.textColor = UIColor.lightGray
        clubLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(clubLabel)
    }
    
    func setupAccessCodeTextField(){
        accessCodeTextField = UITextField()
        accessCodeTextField.placeholder = "Enter Access Code"
        accessCodeTextField.borderStyle = .roundedRect
        accessCodeTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(accessCodeTextField)
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
            
            nameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
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
            
            clubLabel.topAnchor.constraint(equalTo: retypePasswordTextField.bottomAnchor, constant: 16),
            clubLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            clubLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            clubLabel.heightAnchor.constraint(equalToConstant: 50),
            
            accessCodeTextField.topAnchor.constraint(equalTo: clubLabel.bottomAnchor, constant: 16),
            accessCodeTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            accessCodeTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            accessCodeTextField.heightAnchor.constraint(equalToConstant: 50),
            

            createAccountButton.bottomAnchor.constraint(equalTo: loginPromptButton.topAnchor, constant: -8),
            createAccountButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            createAccountButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            createAccountButton.heightAnchor.constraint(equalToConstant: 50),
            
            loginPromptButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            loginPromptButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
