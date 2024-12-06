//
//  CreateEventViewController.swift
//  EventGram
//
//  Created by Srikar Nallapu on 11/29/24.
//

import UIKit

class CreateEventViewController: UIViewController {
    
    var delegate: EventsViewController!
    let createEventView = CreateEventView()
    
    override func loadView() {
        view = createEventView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
