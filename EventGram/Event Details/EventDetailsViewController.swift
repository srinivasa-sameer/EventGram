//
//  EventDetailsViewController.swift
//  EventGram
//
//  Created by Srikar Nallapu on 11/29/24.
//

import UIKit

class EventDetailsViewController: UIViewController {
    
    var event: Event? // Property to hold event data
    let detailsView = EventDetailsView()
    
    override func loadView() {
        view = detailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize the details view with event data
        if let event = event {
            detailsView.titleLabel.text = event.title
            detailsView.descriptionLabel.text = event.title
            detailsView.dateLabel.text = DateFormatter.localizedString(from: event.date, dateStyle: .medium, timeStyle: .short)
            detailsView.locationLabel.text = event.location
            
            if let imageUrl = event.imageUrl, let url = URL(string: imageUrl) {
                detailsView.eventImageView.af.setImage(withURL: url, placeholderImage: UIImage(systemName: "photo"))
            }
        }
    }
}
