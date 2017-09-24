//
//  LSAvatarView.swift
//  AvatarFromPhotos
//
//  Created by 李森 on 2017/9/24.
//  Copyright © 2017年 李森. All rights reserved.
//

import UIKit

@objc protocol LSAvatarViewDelegate {
    func lsAvatarViewDidClickAvatar(_ view: LSAvatarView)
}

class LSAvatarView: UIImageView {
    weak var delegate: LSAvatarViewDelegate?
    fileprivate lazy var maskLayer: CAShapeLayer = {
        let layer: CAShapeLayer = CAShapeLayer()
        return layer
    }()
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initLayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initLayers()
    }
    
    deinit {
        delegate = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let _ = delegate?.lsAvatarViewDidClickAvatar(self) else {
            return
        }
    }
    
    //MARK: - private method
    fileprivate func initLayers() {
        let path: UIBezierPath = UIBezierPath(ovalIn: self.bounds)
        self.maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}

