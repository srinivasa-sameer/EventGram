//
//  Event.swift
//  EventGram
//
//  Created by Srinivasa Sameer Addepalli on 11/29/24.
//

import Foundation
import UIKit
import FirebaseCore
 
struct Event {
    let title: String
    let location: String
    let date: Date
    let imageUrl: String?
    
    init(dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String ?? ""
        self.location = dictionary["location"] as? String ?? ""
        self.date = (dictionary["date"] as? Timestamp)?.dateValue() ?? Date()
        self.imageUrl = dictionary["imageUrl"] as? String
    }
}
