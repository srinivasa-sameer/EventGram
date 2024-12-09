//
//  LandingPageView.swift
//  EventGram
//
//  Created by Srinivasa Sameer Addepalli on 12/3/24.
//

import UIKit

class LandingPage: UIView {

    var logoImageView: UIImageView!
    var titleLabel: UILabel!
    var getStartedButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white

        setUpLogoImageView()
        setUpTitleLabel()
        setUpGetStartedButton()
        initConstraints()
    }

    func setUpLogoImageView() {
        logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "landing")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.backgroundColor = .clear
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(logoImageView)
    }

    func setUpTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "EventGram"
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
    }

    func setUpGetStartedButton() {
        getStartedButton = UIButton()
        getStartedButton.setTitle("Get Started", for: .normal)
        getStartedButton.backgroundColor = UIColor(
            red: 190 / 255, green: 40 / 255, blue: 60 / 255, alpha: 1.0)
        getStartedButton.layer.cornerRadius = 25
        getStartedButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(getStartedButton)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.centerYAnchor.constraint(
                equalTo: centerYAnchor, constant: -50),
            logoImageView.widthAnchor.constraint(equalToConstant: 250),
            logoImageView.heightAnchor.constraint(equalToConstant: 250),

            titleLabel.topAnchor.constraint(
                equalTo: logoImageView.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            getStartedButton.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -40),
            getStartedButton.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 24),
            getStartedButton.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -24),
            getStartedButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
