//
//  Event.swift
//  EventGram
//
//  Created by Srinivasa Sameer Addepalli on 11/29/24.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore
 

struct Event {
    let eventId: String
    let title: String
    let description: String
    let location: String
    let date: Date
    let imageUrl: String?
    
    init(dictionary: [String: Any]) {
        self.eventId = dictionary["eventId"] as? String ?? UUID().uuidString
        self.title = dictionary["title"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.location = dictionary["location"] as? String ?? ""
        self.date = (dictionary["date"] as? Timestamp)?.dateValue() ?? Date()
        self.imageUrl = dictionary["imageUrl"] as? String
    }
}

