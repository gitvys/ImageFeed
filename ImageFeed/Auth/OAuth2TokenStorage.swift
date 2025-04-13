//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Vladislav Sokolov on 12.04.2025.
//

import UIKit

final class OAuth2TokenStorage {
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: "token")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "token")
        }
    }
}
