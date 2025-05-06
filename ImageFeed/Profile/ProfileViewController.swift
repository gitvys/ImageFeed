//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Vladislav Sokolov on 24.11.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    // MARK: - IB Outlets
    
    // MARK: - Private Properties
    private var profileImageView: UIImageView = UIImageView()
    private var exitButton: UIButton?
    private var userNameLabel: UILabel?
    private var userLoginLabel: UILabel?
    private var descriptionLabel: UILabel?
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageViewSetup()
        profileLabelsSetup()
        profileButtonsSetup()
        
        if let profile = ProfileService.shared.profile {
            updateProfileDetails(profile: profile)
        }
    }
    
    // MARK: - IB Actions
    @IBAction private func didLogout(_ sender: Any) {
    }
    // MARK: - Methods
    private func profileImageViewSetup() {
        guard let profileImage = UIImage(named: "UserPhoto") else { return }
        let profileImageView = UIImageView(image: profileImage)
        self.profileImageView = profileImageView
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
        
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    }
    
    private func profileLabelsSetup() {
        let userNameLabel = UILabel()
        let userLoginLabel = UILabel()
        let descriptionLabel = UILabel()
        self.userNameLabel = userNameLabel
        self.userLoginLabel = userLoginLabel
        self.descriptionLabel = descriptionLabel
        
        view.addSubview(userNameLabel)
        view.addSubview(userLoginLabel)
        view.addSubview(descriptionLabel)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userLoginLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        userNameLabel.text = "Екатерина Новикова"
        userNameLabel.textColor = .white
        userNameLabel.font = .systemFont(ofSize: 23, weight: UIFont.Weight(rawValue: 700))
        userLoginLabel.text = "@ekaterina_nov"
        userLoginLabel.textColor = .ypGray
        userLoginLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.text = "Hello World!"
        descriptionLabel.textColor = .white
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        
        userNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        userLoginLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8).isActive = true
        userLoginLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: userLoginLabel.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: userLoginLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func profileButtonsSetup() {
        guard let buttonImage = UIImage(systemName: "ipad.and.arrow.forward") else { return }
        let exitButton = UIButton.systemButton(
            with: buttonImage,
            target: self,
            action: #selector(didLogout)
        )
        self.exitButton = exitButton
        exitButton.tintColor = .ypRed
        
        view.addSubview(exitButton)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        
        exitButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
    }
    
    private func updateProfileDetails(profile: ProfileService.Profile) {
        userNameLabel?.text = profile.name
                userLoginLabel?.text = profile.loginName
                descriptionLabel?.text = profile.bio
    }
}
