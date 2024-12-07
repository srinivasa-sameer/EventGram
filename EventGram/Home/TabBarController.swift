//
//  TabBarController.swift
//  EventGram
//
//  Created by Srinivasa Sameer Addepalli on 12/7/24.
//

import UIKit
class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        customizeTabBar()
    }
    
    private func setupTabs() {
        // Home Tab
        let homeVC = ViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        // Create Event Tab
        let createEventVC = CreateEventViewController()
        let createEventNav = UINavigationController(rootViewController: createEventVC)
        createEventNav.tabBarItem = UITabBarItem(
            title: "Create",
            image: UIImage(systemName: "plus.circle"),
            selectedImage: UIImage(systemName: "plus.circle.fill")
        )
        
        // Profile Tab
        let profileVC = ProfileViewController()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        setViewControllers([homeNav, createEventNav, profileNav], animated: true)
    }
    
    private func customizeTabBar() {
        tabBar.tintColor = UIColor(red: 190/255, green: 40/255, blue: 60/255, alpha: 1.0)
        tabBar.backgroundColor = .white
    }
}
