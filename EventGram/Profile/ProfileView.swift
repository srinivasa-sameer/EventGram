//
//  ProfileView.swift
//  EventGram
//
//  Created by Srinivasa Sameer Addepalli on 11/29/24.
//

import UIKit

class ProfileView: UIView {

    var profileImageView: UIImageView!
    var nameLabel: UILabel!
    var universityLabel: UILabel!
    var myEventsLabel: UILabel!
    var eventsTableView: UITableView!
    var separator: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white

        setupProfileImage()
        setupNameLabel()
        setupUniversityLabel()
        setupMyEventsLabel()
        setupSeparator()
        setupTableView()
        initConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupProfileImage() {
        profileImageView = UIImageView()
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.tintColor = .lightGray
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(profileImageView)
    }

    func setupNameLabel() {
        nameLabel = UILabel()
        nameLabel.text = "Name"
        nameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLabel)
    }

    func setupUniversityLabel() {
        universityLabel = UILabel()
        universityLabel.text = "University"
        universityLabel.font = .systemFont(ofSize: 16, weight: .bold)
        universityLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(universityLabel)
    }

    func setupSeparator() {
        separator = UIView()
        separator.backgroundColor = .systemGray5
        separator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(separator)
    }

    func setupMyEventsLabel() {
        myEventsLabel = UILabel()
        myEventsLabel.text = "My Events"
        myEventsLabel.font = .systemFont(ofSize: 22, weight: .bold)
        myEventsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(myEventsLabel)
    }

    func setupTableView() {
        eventsTableView = UITableView()
        eventsTableView.register(
            TableViewEventCell.self, forCellReuseIdentifier: "events")
        eventsTableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(eventsTableView)
    }

    func initConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),

            nameLabel.topAnchor.constraint(
                equalTo: profileImageView.bottomAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            universityLabel.topAnchor.constraint(
                equalTo: nameLabel.bottomAnchor, constant: 10),
            universityLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 4),
            separator.topAnchor.constraint(
                equalTo: universityLabel.bottomAnchor, constant: 25),

            myEventsLabel.topAnchor.constraint(
                equalTo: separator.bottomAnchor, constant: 15),
            myEventsLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 20),

            eventsTableView.topAnchor.constraint(
                equalTo: myEventsLabel.bottomAnchor, constant: 10),
            eventsTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            eventsTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            eventsTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
