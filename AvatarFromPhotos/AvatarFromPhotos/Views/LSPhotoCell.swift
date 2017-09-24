//
//  LSPhotoCell.swift
//  AvatarFromPhotos
//
//  Created by 李森 on 2017/9/24.
//  Copyright © 2017年 李森. All rights reserved.
//

import UIKit

class LSPhotoCell: UICollectionViewCell {
    var photo: UIImage? {
        didSet {
            imgPhoto.image = photo
        }
    }
    fileprivate lazy var imgPhoto: UIImageView = {
        var imageView: UIImageView = UIImageView(frame: CGRect.zero)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imgPhoto.frame = self.bounds
        self.addSubview(imgPhoto)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

