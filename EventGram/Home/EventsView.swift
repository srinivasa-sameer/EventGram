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
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .white
            
            //MARK: initializing a TableView...
            setupTableViewEvents()
            initConstraints()
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
            tableViewEvents.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            tableViewEvents.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            tableViewEvents.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableViewEvents.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

