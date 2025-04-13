//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Vladislav Sokolov on 08.04.2025.
//

import UIKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
