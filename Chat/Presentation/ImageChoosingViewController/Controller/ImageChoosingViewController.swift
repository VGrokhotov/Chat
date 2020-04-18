//
//  ImageChoosingViewController.swift
//  Chat
//
//  Created by Владислав on 17.04.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

class ImageChoosingViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var imagesURLs = [String]()
    
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    private let itemsPerRow: CGFloat = 3
    private let minimumItemSpacing: CGFloat = 10

    private var sizeOfCell = CGSize()
    
    private var returnOfImageCompletion: (UIImage) -> () = {_ in }
    
    
    private lazy var imageSercice = ImagesService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.register(ImageCell.nib, forCellWithReuseIdentifier: ImageCell.reuseID)
        
        imageSercice.getImages(
            errorCompletion: { error in
                self.showAlert(title: "Error", message: error)
            },
            completion:  { imageURLs in
                self.activityIndicator.stopAnimating()
                self.imagesURLs = imageURLs
                self.collectionView.isHidden = false
                self.collectionView.reloadData()
            }
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let paddingSpace = sectionInsets.left + sectionInsets.right + minimumItemSpacing * (itemsPerRow - 1) + 2
        let availableWidth = collectionView.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        sizeOfCell = CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //MARK: Satic func
    
    static func makeVC(comletion: @escaping (UIImage) -> ()) -> ImageChoosingViewController {
        let newViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: String(describing: ImageChoosingViewController.self))
            as? ImageChoosingViewController
        
        guard let newVC = newViewController else { return ImageChoosingViewController() }
        
        newVC.returnOfImageCompletion = comletion
        
        return newVC
    }
    
    //MARK: Alert controllers
    
    func showAlert(title: String, message: String){
        
        activityIndicator.stopAnimating()
        
        let allert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            ////////
        }
        
        allert.addAction(okAction)
        present(allert, animated: true)
    }
}

extension ImageChoosingViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let cell = collectionView.cellForItem(at: indexPath) as? ImageCell,
            let image = cell.imageView.image
        else { return }
        returnOfImageCompletion(image)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeOfCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumItemSpacing
    }
}

extension ImageChoosingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageCell.reuseID,
            for: indexPath) as? ImageCell
        else { return ImageCell() }
        
        cell.configure(with:  #imageLiteral(resourceName: "placeholder-user"))
        cell.activateConstrainsWith(size: sizeOfCell)
        
        imageSercice.getImage(
            from: imagesURLs[indexPath.row],
            errorCompletion: {
                cell.configure(with: #imageLiteral(resourceName: "no_Image"))
                cell.reloadInputViews()
            },
            completion: { data in
                let image = UIImage(data: data)
                if let image = image {
                    cell.configure(with: image)
                } else {
                    cell.configure(with: #imageLiteral(resourceName: "no_Image"))
                }
                cell.reloadInputViews()
            }
        )
        
        return cell
    }
    
}
