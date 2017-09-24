//
//  LSPhotosViewController.swift
//  AvatarFromPhotos
//
//  Created by 李森 on 2017/9/24.
//  Copyright © 2017年 李森. All rights reserved.
//

import UIKit
import Photos

class LSPhotosViewController: UIViewController {

    // MARK: - properties
    fileprivate let itemWidth: CGFloat = (UIScreen.main.bounds.width - 6.0) / 4.0
    fileprivate lazy var cacheManager: PHCachingImageManager = {
        return PHCachingImageManager()
    }()
    fileprivate lazy var requestOptions: PHImageRequestOptions = {
        let options: PHImageRequestOptions = PHImageRequestOptions()
        options.resizeMode = .exact
        return options
    }()
    fileprivate lazy var allPhotos: PHFetchResult<PHAsset> = {
        let options: PHFetchOptions = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let photos = PHAsset.fetchAssets(with: options)
        return photos
    }()
    fileprivate lazy var btnReturn: UIButton = {
        let button: UIButton = UIButton(frame: CGRect(x: 10.0, y: 20.0, width: 44.0, height: 44.0))
        button.setTitle("Back", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(LSPhotosViewController.eventReturnButtonDidClick(_:)), for: .touchUpInside)
        return button
    }()
    fileprivate lazy var photoCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = 2.0
        layout.minimumInteritemSpacing = 2.0
        let collectionView: UICollectionView = UICollectionView(frame: CGRect(x: 0.0, y: 64.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-64.0), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(LSPhotoCell.classForKeyedArchiver(), forCellWithReuseIdentifier: "Photo")
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(photoCollectionView)
        view.addSubview(btnReturn)
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    // MARK: - event response
    @objc fileprivate func eventReturnButtonDidClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension LSPhotosViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LSPhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photo", for: indexPath) as! LSPhotoCell
        let asset: PHAsset = allPhotos.object(at: indexPath.row)
        
        self.cacheManager.requestImage(for: asset, targetSize: CGSize(width: self.itemWidth*UIScreen.main.scale, height: self.itemWidth*UIScreen.main.scale), contentMode: .aspectFill, options: self.requestOptions) { (assetImage, info) in
            cell.photo = assetImage
        }
        
        return cell
    }
}

extension LSPhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //在跳转前将数据准备好
        let selectedAsset: PHAsset = self.allPhotos.object(at: indexPath.row)
        let assetRequestOption: PHImageRequestOptions = PHImageRequestOptions()
        assetRequestOption.deliveryMode = .highQualityFormat
        
        PHImageManager.default().requestImage(for: selectedAsset, targetSize: CGSize(width: UIScreen.main.bounds.width*UIScreen.main.scale, height: UIScreen.main.bounds.height*UIScreen.main.scale), contentMode: PHImageContentMode.aspectFit, options: assetRequestOption) { [weak self](assetImage, info) in
            if let strongSelf = self {
                if let imgSize = assetImage?.size {
                    let assetScale = UIScreen.main.bounds.width/imgSize.width
                    let imgWidth = imgSize.width*assetScale
                    let imgHeight = imgSize.height*assetScale
                    let orignalImage = assetImage?.resize(with: CGSize(width: imgWidth, height: imgHeight))
                    let detailVC: LSAvatarEditorViewController = LSAvatarEditorViewController()
                    detailVC.selectedImage = orignalImage
                    detailVC.imageWidth = imgWidth
                    detailVC.imageHeight = imgHeight
                    strongSelf.present(detailVC, animated: true, completion: nil)
                }
            }
        }
    }
}

extension LSPhotosViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changeDetails = changeInstance.changeDetails(for: allPhotos) else {
            return
        }
        DispatchQueue.main.async {
            self.allPhotos = changeDetails.fetchResultAfterChanges
            if changeDetails.hasIncrementalChanges {
                self.photoCollectionView.performBatchUpdates({
                    if let removed = changeDetails.removedIndexes, removed.count > 0 {
                        self.photoCollectionView.deleteItems(at: removed.map{IndexPath(row: $0, section: 0)})
                    }
                    
                    if let inserted = changeDetails.insertedIndexes, inserted.count > 0 {
                        self.photoCollectionView.insertItems(at: inserted.map{IndexPath(row: $0, section: 0)})
                    }
                    
                    if let changed = changeDetails.changedIndexes, changed.count > 0 {
                        self.photoCollectionView.reloadItems(at: changed.map {IndexPath(row: $0, section: 0)})
                    }
                    
                    changeDetails.enumerateMoves({ (fromIndex, toIndex) in
                        self.photoCollectionView.moveItem(at: IndexPath(row: fromIndex, section: 0), to: IndexPath(row: toIndex, section: 0))
                    })
                }, completion: nil)
            } else  {
                self.photoCollectionView.reloadData()
            }
        }
    }
}
