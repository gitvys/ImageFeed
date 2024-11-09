//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Vladislav Sokolov on 06.11.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var imageForCell: UIImageView!
    
    static let reuseIdentifier = "ImagesListCell"
    
}
