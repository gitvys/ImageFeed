//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Vladislav Sokolov on 06.11.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    // MARK: - IBOutlet properties
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var imageForCell: UIImageView!
    
    // MARK: - Static properties
    static let reuseIdentifier = "ImagesListCell"
    
}
