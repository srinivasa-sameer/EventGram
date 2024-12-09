//
//  ProgressSpinnerViewController.swift
//  EventGram
//
//  Created by Vidhi Thacker on 11/14/24.
//

import UIKit

class ProgressSpinnerViewController: UIViewController {

    private var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
    }

    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = UIColor(
            red: 190 / 255, green: 40 / 255, blue: 60 / 255, alpha: 1.0)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(
                equalTo: view.centerYAnchor),
        ])

        activityIndicator.startAnimating()
    }

    func startSpinner() {
        activityIndicator.startAnimating()
    }

    func stopSpinner() {
        activityIndicator.stopAnimating()
    }

    func setBackgroundColor(_ color: UIColor) {
        view.backgroundColor = color
    }

    func setSpinnerColor(_ color: UIColor) {
        activityIndicator.color = color
    }
}
