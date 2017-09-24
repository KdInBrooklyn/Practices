//
//  LSAvatarEditorViewController.swift
//  AvatarFromPhotos
//
//  Created by 李森 on 2017/9/24.
//  Copyright © 2017年 李森. All rights reserved.
//

import UIKit
import Photos

class LSAvatarEditorViewController: UIViewController {

    var selectedImage: UIImage?
    var imageWidth: CGFloat = 0.0
    var imageHeight: CGFloat = 0.0
    fileprivate let screenWidth = UIScreen.main.bounds.width
    fileprivate let screenHeight = UIScreen.main.bounds.height
    fileprivate lazy var filterLayer: CAShapeLayer = {
        let layer: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath(rect: CGRect(x: -1.0, y: -1.0, width: screenWidth+2.0, height: screenHeight+2.0))
        let circlePath: UIBezierPath = UIBezierPath(ovalIn: CGRect(x: 0.0, y: (screenHeight-screenWidth)/2.0, width: screenWidth, height: screenWidth))
        path.append(circlePath)
        path.usesEvenOddFillRule = true
        layer.path = path.cgPath
        layer.fillRule = kCAFillRuleEvenOdd
        layer.fillColor = UIColor(white: 0.0, alpha: 0.5).cgColor
        layer.strokeColor = UIColor.clear.cgColor
        return layer
    }()
    fileprivate lazy var assetRequestOption: PHImageRequestOptions = {
        let option: PHImageRequestOptions = PHImageRequestOptions()
        option.deliveryMode = .highQualityFormat
        return option
    }()
    fileprivate lazy var btnBack: UIButton = {
        let button: UIButton = UIButton(frame: CGRect(x: 10.0, y: screenHeight-77.0, width: 60.0, height: 30.0))
        button.setTitle("取消", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(LSAvatarEditorViewController.eventReturnButtonDidClick(_:)), for: .touchUpInside)
        return button
    }()
    fileprivate lazy var btnConfirm: UIButton = {
        let button: UIButton = UIButton(frame: CGRect(x: screenWidth-10.0-60.0, y: screenHeight-77.0, width: 60.0, height: 30.0))
        button.setTitle("选取", for: .normal)
        button.tag = 2
        button.addTarget(self, action: #selector(LSAvatarEditorViewController.eventReturnButtonDidClick(_:)), for: .touchUpInside)
        return button
    }()
    fileprivate lazy var imageScroller: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView(frame: CGRect(x: 0.0, y: (screenHeight-screenWidth)/2.0, width: screenWidth, height: screenWidth))
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0
        scrollView.bounces = true
        scrollView.contentSize = UIScreen.main.bounds.size
        scrollView.layer.masksToBounds = false
        scrollView.layer.cornerRadius = screenWidth/2.0
        scrollView.layer.borderColor = UIColor.white.cgColor
        scrollView.layer.borderWidth = 2.0
        return scrollView
    }()
    fileprivate lazy var photoImage: UIImageView = {
        var imageView: UIImageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        photoImage.frame = CGRect(x: 0.0, y: 0.0, width: imageWidth, height: imageHeight)
        photoImage.image = selectedImage
        let heightRatio = screenWidth/imageHeight
        let normalRatio = screenWidth/imageWidth
        imageScroller.zoomScale = normalRatio
        imageScroller.minimumZoomScale = min(heightRatio, 1.0)
        imageScroller.contentSize = CGSize(width: imageWidth, height: imageHeight)
        imageScroller.contentOffset = CGPoint(x: 0.0, y: (imageHeight-screenWidth)/2.0)
        imageScroller.addSubview(photoImage)
        view.addSubview(imageScroller)
        view.layer.addSublayer(filterLayer)
        view.addSubview(btnBack)
        view.addSubview(btnConfirm)
    }
    
    // MARK: - event response
    @objc fileprivate func eventReturnButtonDidClick(_ sender: UIButton) {
        if sender.tag == 2 {
            var imgOffset = imageScroller.contentOffset
            var zoom = photoImage.frame.width/imageWidth
            zoom = zoom/UIScreen.main.scale
            var scrollWidth: CGFloat = imageScroller.frame.width
            var scrollHeight: CGFloat = imageScroller.frame.height
            if photoImage.frame.height <= scrollHeight {
                imgOffset = CGPoint(x: imgOffset.x+(scrollWidth-photoImage.frame.height)/2.0, y: 0.0)
                scrollWidth = photoImage.frame.height
                scrollHeight = photoImage.frame.height
            }
            
            let imageRect = CGRect(x: imgOffset.x/zoom, y: imgOffset.y/zoom, width: scrollWidth/zoom, height: scrollHeight/zoom)
            if let imageRef = selectedImage?.cgImage?.cropping(to: imageRect) {
                let newImage = UIImage(cgImage: imageRef).ovalClip()
                if let savedImage = newImage {
                    let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let main: LSMainViewController = LSMainViewController()
                    self.present(main, animated: true, completion: nil)
                    main.avatar = savedImage
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAsset(from: savedImage)
                    }, completionHandler: { (result, error) in
                        if let error = error {
                            print(error)
                        }
                    })
                }
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

}

// MARK: - UIScrollViewDelegate
extension LSAvatarEditorViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoImage
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var imgOriginFrame = photoImage.frame
        if imgOriginFrame.size.width <= screenWidth {
            imgOriginFrame.origin.x = (screenWidth - imgOriginFrame.width)/2.0
        } else {
            imgOriginFrame.origin.x = 0.0
        }
        if imgOriginFrame.size.height <= screenWidth {
            imgOriginFrame.origin.y = (screenWidth - imgOriginFrame.size.height)/2.0
        } else {
            imgOriginFrame.origin.y = 0.0
        }
        photoImage.frame = imgOriginFrame
    }
}

// UIImageExtensions
extension UIImage {
    func resize(with size: CGSize) -> UIImage?{
        let newWidth: CGFloat = size.width
        let newHeight: CGFloat = size.height
        let originWidth: CGFloat = self.size.width
        let originHeight: CGFloat = self.size.height
        if newWidth != originWidth && newHeight != originHeight {
            UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
            self.draw(in: CGRect(origin: CGPoint.zero, size: size))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return resizedImage
        }
        return self
    }
    
    func ovalClip() -> UIImage? {
        let originSize = self.size
        UIGraphicsBeginImageContextWithOptions(originSize, false, UIScreen.main.scale)
        let path: UIBezierPath = UIBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size: originSize))
        path.addClip()
        self.draw(at: CGPoint.zero)
        let circleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return circleImage
    }
    
    func scale(with scale: CGFloat) -> UIImage {
        let newSize:CGSize = CGSize(width: self.size.width * scale, height: self.size.height * scale);
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0);
        self.draw(in: CGRect(x:0.0, y:0.0, width: newSize.width, height: newSize.height));
        let scaleImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaleImage!;
    }
}
