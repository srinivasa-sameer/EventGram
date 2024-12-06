//
//  CreateEventView.swift
//  EventGram
//
//  Created by Srinivasa Sameer Addepalli on 11/29/24.
//

import UIKit

class CreateEventView: UIView {

    var scrollView: UIScrollView!
    var contentView: UIView!
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    var eventTitleTextField: UITextField!
    var eventDescriptionTextView: UITextView!
    var uploadBannerView: UIView!
    var uploadImageIcon: UIImageView!
    var uploadButton: UIButton!
    var uploadInfoLabel: UILabel!
    var addressTextField: UITextField!
    var startTimeTextField: UITextField!
    var endTimeTextField: UITextField!
    var startDateTextField: UITextField!
    var createEventButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white

        setupScrollView()
        setupContentView()
        setupTitleLabel()
        setupSubtitleLabel()
        setupEventTitleField()
        setupEventDescriptionView()
        setupUploadBannerSection()
        setupAddressField()
        setupTimeFields()
        setupDateField()
        setupCreateEventButton()
        setupConstraints()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
    }

    func setupContentView() {
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
    }

    func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "Create an Event"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
    }

    func setupSubtitleLabel() {
        subtitleLabel = UILabel()
        subtitleLabel.text = "Create your event by providing the details below"
        subtitleLabel.textColor = .gray
        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLabel)
    }

    func setupEventTitleField() {
        eventTitleTextField = UITextField()
        eventTitleTextField.placeholder = "Event Title *"
        eventTitleTextField.borderStyle = .roundedRect
        eventTitleTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(eventTitleTextField)
    }

    func setupEventDescriptionView() {
        eventDescriptionTextView = UITextView()
        eventDescriptionTextView.text = "Describe your event *"
        eventDescriptionTextView.textColor = .lightGray
        eventDescriptionTextView.font = .systemFont(ofSize: 16)
        eventDescriptionTextView.layer.borderWidth = 0.5
        eventDescriptionTextView.layer.borderColor = UIColor.systemGray4.cgColor
        eventDescriptionTextView.layer.cornerRadius = 8
        eventDescriptionTextView.translatesAutoresizingMaskIntoConstraints =
            false
        contentView.addSubview(eventDescriptionTextView)
    }

    func setupUploadBannerSection() {
        uploadBannerView = UIView()
        uploadBannerView.backgroundColor = .systemGray6
        uploadBannerView.layer.cornerRadius = 8
        uploadBannerView.translatesAutoresizingMaskIntoConstraints = false

        uploadImageIcon = UIImageView()
        uploadImageIcon.image = UIImage(systemName: "photo")
        uploadImageIcon.tintColor = .gray
        uploadImageIcon.contentMode = .scaleAspectFit
        uploadImageIcon.translatesAutoresizingMaskIntoConstraints = false

        uploadButton = UIButton()
        uploadButton.setTitle("Upload event banner", for: .normal)
        uploadButton.setTitleColor(.systemBlue, for: .normal)
        uploadButton.translatesAutoresizingMaskIntoConstraints = false

        uploadInfoLabel = UILabel()
        uploadInfoLabel.text = "Upload a JPEG or PNG file"
        uploadInfoLabel.textColor = .gray
        uploadInfoLabel.font = .systemFont(ofSize: 14)
        uploadInfoLabel.translatesAutoresizingMaskIntoConstraints = false

        uploadBannerView.addSubview(uploadImageIcon)
        uploadBannerView.addSubview(uploadButton)
        uploadBannerView.addSubview(uploadInfoLabel)
        contentView.addSubview(uploadBannerView)
    }

    func setupAddressField() {
        addressTextField = UITextField()
        addressTextField.placeholder = "Enter Address *"
        addressTextField.borderStyle = .roundedRect
        addressTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addressTextField)
    }

    func setupTimeFields() {
        startTimeTextField = UITextField()
        startTimeTextField.placeholder = "Start time *"
        startTimeTextField.borderStyle = .roundedRect
        startTimeTextField.rightView = UIImageView(
            image: UIImage(systemName: "clock"))
        startTimeTextField.rightViewMode = .always
        startTimeTextField.translatesAutoresizingMaskIntoConstraints = false

        endTimeTextField = UITextField()
        endTimeTextField.placeholder = "End time *"
        endTimeTextField.borderStyle = .roundedRect
        endTimeTextField.rightView = UIImageView(
            image: UIImage(systemName: "clock"))
        endTimeTextField.rightViewMode = .always
        endTimeTextField.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(startTimeTextField)
        contentView.addSubview(endTimeTextField)
    }

    func setupDateField() {
        startDateTextField = UITextField()
        startDateTextField.placeholder = "Start date *"
        startDateTextField.borderStyle = .roundedRect
        startDateTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(startDateTextField)
    }

    func setupCreateEventButton() {
        createEventButton = UIButton()
        createEventButton.setTitle("Create Event", for: .normal)
        createEventButton.backgroundColor = UIColor(
            red: 190 / 255, green: 40 / 255, blue: 60 / 255, alpha: 1.0)
        createEventButton.layer.cornerRadius = 25
        createEventButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(createEventButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView constraints
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            // Content view constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Title label
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            // Subtitle label
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            // Event title text field
            eventTitleTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            eventTitleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            eventTitleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            eventTitleTextField.heightAnchor.constraint(equalToConstant: 50),

            // Event description view
            eventDescriptionTextView.topAnchor.constraint(equalTo: eventTitleTextField.bottomAnchor, constant: 16),
            eventDescriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            eventDescriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            eventDescriptionTextView.heightAnchor.constraint(equalToConstant: 100),

            // Upload banner view
            uploadBannerView.topAnchor.constraint(equalTo: eventDescriptionTextView.bottomAnchor, constant: 16),
            uploadBannerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            uploadBannerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            uploadBannerView.heightAnchor.constraint(equalToConstant: 150),

            // Address field
            addressTextField.topAnchor.constraint(equalTo: uploadBannerView.bottomAnchor, constant: 16),
            addressTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addressTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            addressTextField.heightAnchor.constraint(equalToConstant: 50),

            // Start time field
            startTimeTextField.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 16),
            startTimeTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            startTimeTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.45),
            startTimeTextField.heightAnchor.constraint(equalToConstant: 50),

            // End time field
            endTimeTextField.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 16),
            endTimeTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            endTimeTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.45),
            endTimeTextField.heightAnchor.constraint(equalToConstant: 50),

            // Start date field
            startDateTextField.topAnchor.constraint(equalTo: startTimeTextField.bottomAnchor, constant: 16),
            startDateTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            startDateTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            startDateTextField.heightAnchor.constraint(equalToConstant: 50),

            // Create event button
            createEventButton.topAnchor.constraint(equalTo: startDateTextField.bottomAnchor, constant: 32),
            createEventButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            createEventButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            createEventButton.heightAnchor.constraint(equalToConstant: 50),
            createEventButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
}
