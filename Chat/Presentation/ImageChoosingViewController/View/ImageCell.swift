//
//  ImageCell.swift
//  Chat
//
//  Created by Владислав on 18.04.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell, ConfigurableView {

    typealias ConfigurationModel = UIImage
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var hightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    static let reuseID = String(describing: ImageCell.self)
    static let nib = UINib(nibName: String(describing: ImageCell.self), bundle: nil)
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
    }
    
    func configure(with model: UIImage) {
        
        imageView.image = model

    }
    
    func activateConstrainsWith(size: CGSize) {
        hightConstraint.constant = size.height
        hightConstraint.isActive = true
        widthConstraint.constant = size.width
        widthConstraint.isActive = true
    }
    

}
