//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Vladislav Sokolov on 24.11.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    // MARK: - IB Outlets
    @IBOutlet private weak var exitButton: UIButton!
    @IBOutlet private weak var userPhotoImage: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userLoginLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    // MARK: - Private Properties
    
    // MARK: - Overrides Methods
    
    // MARK: - IB Actions
    @IBAction func didLogout(_ sender: Any) {
    }
    // MARK: - Methods
    
}
