//
//  EventSuccessView.swift
//  EventGram
//
//  Created by Srinivasa Sameer Addepalli on 12/6/24.
//
import UIKit

class EventSuccessView: UIView {
    
    var successIcon: UIImageView!
    var successLabel: UILabel!
    var eventTitleLabel: UILabel!
    var eventDateLabel: UILabel!
    var infoLabel: UILabel!
    var goToEventsButton: UIButton!
    var viewDetailsButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupSuccessIcon()
        setupSuccessLabel()
        setupEventTitleLabel()
        setupEventDateLabel()
        setupInfoLabel()
        setupButtons()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSuccessIcon() {
        successIcon = UIImageView()
        successIcon.image = UIImage(systemName: "checkmark.circle.fill")
        successIcon.tintColor = .darkGray
        successIcon.contentMode = .scaleAspectFit
        successIcon.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(successIcon)
    }
    
    func setupSuccessLabel() {
        successLabel = UILabel()
        successLabel.text = "Event created successfully"
        successLabel.textColor = .gray
        successLabel.font = .systemFont(ofSize: 18)
        successLabel.textAlignment = .center
        successLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(successLabel)
    }
    
    func setupEventTitleLabel() {
        eventTitleLabel = UILabel()
        eventTitleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        eventTitleLabel.textAlignment = .center
        eventTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(eventTitleLabel)
    }
    
    func setupEventDateLabel() {
        eventDateLabel = UILabel()
        eventDateLabel.textColor = .darkGray
        eventDateLabel.font = .systemFont(ofSize: 16)
        eventDateLabel.textAlignment = .center
        eventDateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(eventDateLabel)
    }
    
    func setupInfoLabel() {
        infoLabel = UILabel()
        infoLabel.text = "You can always edit your event information\nfrom your personal events page"
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoLabel.textColor = .gray
        infoLabel.font = .systemFont(ofSize: 16)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(infoLabel)
    }
    
    func setupButtons() {
        goToEventsButton = UIButton()
        goToEventsButton.setTitle("Go to events", for: .normal)
        goToEventsButton.backgroundColor = UIColor(red: 190/255, green: 40/255, blue: 60/255, alpha: 1.0)
        goToEventsButton.layer.cornerRadius = 25
        goToEventsButton.translatesAutoresizingMaskIntoConstraints = false
        
        viewDetailsButton = UIButton()
        viewDetailsButton.setTitle("View event details", for: .normal)
        viewDetailsButton.setTitleColor(.black, for: .normal)
        viewDetailsButton.backgroundColor = .systemGray6
        viewDetailsButton.layer.cornerRadius = 25
        viewDetailsButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(goToEventsButton)
        self.addSubview(viewDetailsButton)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            successIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            successIcon.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100),
            successIcon.widthAnchor.constraint(equalToConstant: 80),
            successIcon.heightAnchor.constraint(equalToConstant: 80),
            
            successLabel.topAnchor.constraint(equalTo: successIcon.bottomAnchor, constant: 24),
            successLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            eventTitleLabel.topAnchor.constraint(equalTo: successLabel.bottomAnchor, constant: 24),
            eventTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            eventTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            eventTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            eventDateLabel.topAnchor.constraint(equalTo: eventTitleLabel.bottomAnchor, constant: 8),
            eventDateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            infoLabel.bottomAnchor.constraint(equalTo: goToEventsButton.topAnchor, constant: -40),
            
            goToEventsButton.bottomAnchor.constraint(equalTo: viewDetailsButton.topAnchor, constant: -16),
            goToEventsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            goToEventsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            goToEventsButton.heightAnchor.constraint(equalToConstant: 50),
            
            viewDetailsButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            viewDetailsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            viewDetailsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            viewDetailsButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
