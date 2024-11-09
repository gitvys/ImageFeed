//
//  ViewController.swift
//  ImageFeed
//
//  Created by Владислав Соколов on 27.10.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
    // MARK: - IB Outlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Private Properties
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    // MARK: - Methods
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        // получение изображения
        let imageName = "\(indexPath.row)"
        guard let image = UIImage(named: imageName) else { return }
        
        cell.imageForCell.image = image
        
        // форматирование даты
        lazy var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            formatter.locale = Locale(identifier: "ru_RU")
            return formatter
        }()
        
        let currentDate = dateFormatter.string(from: Date())
        cell.dateLabel.text = currentDate // приседания со значением лейбла
        
        // установка лайка вручную для ячейки
        if indexPath.row % 2 == 0 {
            cell.likeButton.setImage(UIImage(named: "LikeActive"), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(named: "LikeDisabled"), for: .normal)
        }
    }
}
// MARK: - Extensions
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageName = "\(indexPath.row)"
        guard let image = UIImage(named: imageName) else { return 0 }
        
        let imageHeight = image.size.height
        let imageWidth = image.size.width
        let imageAspectRatio = imageWidth / imageHeight
        
        let imageViewWidth = tableView.frame.width
        let imageViewHeight = imageViewWidth / imageAspectRatio
        
        let topBottomInsets = 4
        
        return imageViewHeight + CGFloat(topBottomInsets)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}
