//
//  CreateEventsHelper.swift
//  EventGram
//
//  Created by Nallapu Srikar on 12/4/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

func createSampleEvents() {
    let db = Firestore.firestore()
    
    // Create an array of sample events
    let sampleEvents = [
        [
            "title": "Tech Conference 2024",
            "description": "Annual technology conference featuring industry leaders",
            "date": Timestamp(date: Date().addingTimeInterval(30 * 24 * 60 * 60)), // 30 days from now
            "location": "San Francisco, CA",
            "imageUrl": "https://example.com/tech-conf.jpg",
            "organizer": "Tech Innovations Inc."
        ],
        [
            "title": "Art Gallery Opening",
            "description": "Showcase of contemporary local artists",
            "date": Timestamp(date: Date().addingTimeInterval(45 * 24 * 60 * 60)), // 45 days from now
            "location": "Downtown Art Center",
            "imageUrl": "https://example.com/art-gallery.jpg",
            "organizer": "Local Arts Council"
        ],
        [
            "title": "Community Charity Run",
            "description": "Annual fundraising marathon for local charities",
            "date": Timestamp(date: Date().addingTimeInterval(60 * 24 * 60 * 60)), // 60 days from now
            "location": "City Park",
            "imageUrl": "https://example.com/charity-run.jpg",
            "organizer": "Community Helpers"
        ]
    ]
    
    // Add events to Firestore
    for event in sampleEvents {
        db.collection("events").addDocument(data: event) { error in
            if let error = error {
                print("Error adding event: \(error)")
            } else {
                print("Event added successfully")
            }
        }
    }
}
