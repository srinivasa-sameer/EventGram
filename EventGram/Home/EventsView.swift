//
//  EventsView.swift
//  EventGram
//
//  Created by Nallapu Srikar on 12/4/24.
//

import AlamofireImage
import UIKit

class EventsView: UIView {

    var tableViewEvents: UITableView!
    var feedLabel: UILabel!
    var notificationsButton: UIButton!
    var calendarButton: UIButton!
    var titleLabel: UILabel!
    var separator: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        //MARK: initializing a TableView...
        setupTableViewEvents()
        setupFeedLabel()
        setupButtons()
        setupTitleLabel()
        initConstraints()
    }

    func setupFeedLabel() {
        feedLabel = UILabel()
        feedLabel.text = "Feed"
        feedLabel.font = .systemFont(ofSize: 26, weight: .bold)
        feedLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(feedLabel)

        separator = UIView()
        separator.backgroundColor = .systemGray5
        separator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(separator)
    }

    func setupButtons() {
        notificationsButton = UIButton()
        let notificationsImage = UIImage(systemName: "bell")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        )
        notificationsButton.setImage(notificationsImage, for: .normal)
        notificationsButton.tintColor = .black
        notificationsButton.backgroundColor = .systemGray6
        notificationsButton.layer.cornerRadius = 20
        notificationsButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(notificationsButton)

        calendarButton = UIButton()
        let calendarImage = UIImage(systemName: "calendar")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        )
        calendarButton.setImage(calendarImage, for: .normal)
        calendarButton.tintColor = .black
        calendarButton.backgroundColor = .systemGray6
        calendarButton.layer.cornerRadius = 20
        calendarButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(calendarButton)
    }

    func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "Events @ Northeastern University"
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
    }

    func setupTableViewEvents() {
        tableViewEvents = UITableView()
        tableViewEvents.register(
            TableViewEventCell.self, forCellReuseIdentifier: "events")
        tableViewEvents.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewEvents)
    }

    //MARK: setting the constraints...
    func initConstraints() {
        NSLayoutConstraint.activate([
            feedLabel.topAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.topAnchor),
            feedLabel.leadingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30),

            notificationsButton.topAnchor.constraint(
                equalTo: feedLabel.topAnchor),
            notificationsButton.trailingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -80),
            notificationsButton.widthAnchor.constraint(equalToConstant: 40),
            notificationsButton.heightAnchor.constraint(equalToConstant: 40),

            calendarButton.topAnchor.constraint(equalTo: feedLabel.topAnchor),
            calendarButton.trailingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            calendarButton.widthAnchor.constraint(equalToConstant: 40),
            calendarButton.heightAnchor.constraint(equalToConstant: 40),

            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 4),
            separator.topAnchor.constraint(
                equalTo: feedLabel.bottomAnchor, constant: 25),

            titleLabel.topAnchor.constraint(
                equalTo: self.separator.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30),

            tableViewEvents.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor, constant: 10),
            tableViewEvents.bottomAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            tableViewEvents.leadingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableViewEvents.trailingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
