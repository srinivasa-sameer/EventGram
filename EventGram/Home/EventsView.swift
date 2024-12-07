//
//  EventsView.swift
//  EventGram
//
//  Created by Nallapu Srikar on 12/4/24.
//

import UIKit
import AlamofireImage

class EventsView: UIView {
        
    var tableViewEvents: UITableView!
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .white
            
            //MARK: initializing a TableView...
            setupTableViewEvents()
            setupTitleLabel()
            initConstraints()
    }
    
    func setupTitleLabel(){
        titleLabel = UILabel()
        titleLabel.text = "Events @ Northeastern University"
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
    }
    
    func setupTableViewEvents(){
        tableViewEvents = UITableView()
        tableViewEvents.register(TableViewEventCell.self, forCellReuseIdentifier: "events")
        tableViewEvents.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewEvents)
    }
    
    //MARK: setting the constraints...
    func initConstraints(){
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            
            tableViewEvents.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 26),
            tableViewEvents.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            tableViewEvents.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableViewEvents.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

