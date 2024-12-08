//
//  SearchView.swift
//  EventGram
//
//  Created by Srinivasa Sameer Addepalli on 12/8/24.
//

import UIKit

class SearchView: UIView {

    var searchBar: UISearchBar!
        var tableView: UITableView!
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.backgroundColor = .white
            
            setupSearchBar()
            setupTableView()
            initConstraints()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setupSearchBar() {
            searchBar = UISearchBar()
            searchBar.placeholder = "Search events..."
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(searchBar)
        }
        
        func setupTableView() {
            tableView = UITableView()
            tableView.register(TableViewEventCell.self, forCellReuseIdentifier: "eventCell")
            tableView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(tableView)
        }
        
    func initConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}
