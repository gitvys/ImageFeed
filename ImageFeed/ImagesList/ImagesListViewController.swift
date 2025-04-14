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
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    // форматирование даты
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    private let currentDate = Date()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Methods
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        // получение изображения
        guard let image = UIImage(named: String(indexPath.row)) else { return }
        
        cell.imageForCell.image = image
        
        cell.dateLabel.text = dateFormatter.string(from: currentDate) // отформатированное значение добавляется в лейбл
        
        // установка лайка вручную для ячейки
        let likeButtonImageName = indexPath.row % 2 == 0 ? "LikeActive" : "LikeDisabled"
        cell.likeButton.setImage(UIImage(named: likeButtonImageName), for: .normal)
    }
    
}
// MARK: - Extensions
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: String(indexPath.row)) else { return 0 }
        
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
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath
        ) as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: cell, with: indexPath)
        
        return cell
    }
}
