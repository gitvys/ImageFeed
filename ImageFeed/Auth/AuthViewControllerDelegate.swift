//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Vladislav Sokolov on 13.04.2025.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}
