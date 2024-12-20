//
//  EventDetailsView.swift
//  EventGram
//
//  Created by Srinivasa Sameer Addepalli on 11/29/24.
//

import MapKit
import UIKit

class EventDetailsView: UIView {

    var eventImageView: UIImageView!
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    var organizerLabel: UILabel!
    var dateIcon: UIImageView!
    var dateLabel: UILabel!
    var locationIcon: UIImageView!
    var locationLabel: UILabel!
    var bookTicketButton: UIButton!
    var mapView: MKMapView!
    var addToCalendarButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white

        setupEventImage()
        setupTitleLabel()
        setupDescriptionLabel()
        setupOrganizer()
        setupDateSection()
        setupLocationSection()
        setupBookTicketButton()
        setupMapView()
        setupAddToCalendarButton()
        initConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupEventImage() {
        eventImageView = UIImageView()
        eventImageView.image = UIImage(named: "event_image")
        eventImageView.contentMode = .scaleAspectFill
        eventImageView.clipsToBounds = true
        eventImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(eventImageView)
    }

    func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "Protothon 6.0"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
    }

    func setupDescriptionLabel() {
        descriptionLabel = UILabel()
        descriptionLabel.text =
            "A lively two-week product prototyping hackathon to enhance your product management skills..."
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(descriptionLabel)
    }

    func setupOrganizer() {
        organizerLabel = UILabel()
        organizerLabel.text = "Hosted by APMC"
        organizerLabel.font = .systemFont(ofSize: 16)
        organizerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(organizerLabel)
    }

    func setupDateSection() {
        dateIcon = UIImageView()
        dateIcon.image = UIImage(systemName: "calendar")
        dateIcon.tintColor = .gray
        dateIcon.translatesAutoresizingMaskIntoConstraints = false

        dateLabel = UILabel()
        dateLabel.text = "November 22nd 5:00 PM"
        dateLabel.font = .systemFont(ofSize: 16)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(dateIcon)
        self.addSubview(dateLabel)
    }

    func setupLocationSection() {
        locationIcon = UIImageView()
        locationIcon.image = UIImage(systemName: "mappin.circle")
        locationIcon.tintColor = .gray
        locationIcon.translatesAutoresizingMaskIntoConstraints = false

        locationLabel = UILabel()
        locationLabel.text = "Curry Student Center"
        locationLabel.font = .systemFont(ofSize: 16)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(locationIcon)
        self.addSubview(locationLabel)
    }

    func setupMapView() {
        mapView = MKMapView()
        mapView.layer.cornerRadius = 12
        mapView.clipsToBounds = true

        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(mapView)
    }

    func setupBookTicketButton() {
        bookTicketButton = UIButton()
        bookTicketButton.setTitle("Book Ticket", for: .normal)
        bookTicketButton.backgroundColor = UIColor(
            red: 190 / 255, green: 40 / 255, blue: 60 / 255, alpha: 1.0)
        bookTicketButton.layer.cornerRadius = 25
        bookTicketButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bookTicketButton)
    }

    func setupAddToCalendarButton() {
        addToCalendarButton = UIButton()
        addToCalendarButton.setTitle("Add to Calendar", for: .normal)
        addToCalendarButton.backgroundColor = UIColor(
            red: 190 / 255, green: 40 / 255, blue: 60 / 255, alpha: 1.0)
        addToCalendarButton.layer.cornerRadius = 25
        addToCalendarButton.isHidden = true  // Initially hidden
        addToCalendarButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addToCalendarButton)
    }

    func initConstraints() {
        NSLayoutConstraint.activate([
            eventImageView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor),
            eventImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            eventImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            eventImageView.heightAnchor.constraint(equalToConstant: 150),

            titleLabel.topAnchor.constraint(
                equalTo: eventImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -16),

            organizerLabel.topAnchor.constraint(
                equalTo: descriptionLabel.bottomAnchor, constant: 16),
            organizerLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 16),
            organizerLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -16),

            dateIcon.topAnchor.constraint(
                equalTo: organizerLabel.bottomAnchor, constant: 16),
            dateIcon.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 16),
            dateIcon.widthAnchor.constraint(equalToConstant: 24),
            dateIcon.heightAnchor.constraint(equalToConstant: 24),

            dateLabel.centerYAnchor.constraint(equalTo: dateIcon.centerYAnchor),
            dateLabel.leadingAnchor.constraint(
                equalTo: dateIcon.trailingAnchor, constant: 8),

            locationIcon.topAnchor.constraint(
                equalTo: dateIcon.bottomAnchor, constant: 16),
            locationIcon.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 16),
            locationIcon.widthAnchor.constraint(equalToConstant: 24),
            locationIcon.heightAnchor.constraint(equalToConstant: 24),

            locationLabel.centerYAnchor.constraint(
                equalTo: locationIcon.centerYAnchor),
            locationLabel.leadingAnchor.constraint(
                equalTo: locationIcon.trailingAnchor, constant: 8),

            mapView.topAnchor.constraint(
                equalTo: locationLabel.bottomAnchor, constant: 16),
            mapView.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 16),
            mapView.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -16),
            mapView.heightAnchor.constraint(equalToConstant: 200),

            bookTicketButton.topAnchor.constraint(
                equalTo: mapView.bottomAnchor, constant: 16),
            bookTicketButton.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 16),
            bookTicketButton.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -16),
            bookTicketButton.heightAnchor.constraint(equalToConstant: 50),

            addToCalendarButton.topAnchor.constraint(
                equalTo: bookTicketButton.bottomAnchor, constant: 16),
            addToCalendarButton.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 16),
            addToCalendarButton.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -16),
            addToCalendarButton.heightAnchor.constraint(equalToConstant: 50),
            addToCalendarButton.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
}
