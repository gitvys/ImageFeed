//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Vladislav Sokolov on 12.04.2025.
//

import Foundation

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private init() {}
    private let tokenKey = "token"
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
}
