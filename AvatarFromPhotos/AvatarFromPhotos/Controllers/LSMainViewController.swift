//
//  LSMainViewController.swift
//  AvatarFromPhotos
//
//  Created by 李森 on 2017/9/24.
//  Copyright © 2017年 李森. All rights reserved.
//

import UIKit
import Photos

class LSMainViewController: UIViewController {
    var avatar: UIImage? {
        didSet {
            avatarView.image = avatar
        }
    }
    fileprivate let avatarWidth: CGFloat = 100.0
    fileprivate let screenWidth: CGFloat = UIScreen.main.bounds.width
    fileprivate let screenHeight: CGFloat = UIScreen.main.bounds.height
    fileprivate lazy var avatarView: LSAvatarView = {
        let avatar: LSAvatarView = LSAvatarView(frame: CGRect(x: (screenWidth-avatarWidth)/2.0, y: 104.0, width: avatarWidth, height: avatarWidth))
        avatar.backgroundColor = UIColor.brown
        avatar.delegate = self
        avatar.isUserInteractionEnabled = true
        return avatar
    }()
    fileprivate lazy var allPhotos: PHFetchResult<PHAsset> = {
        return PHAsset.fetchAssets(with: .image, options: nil)
    }()
    fileprivate lazy var contentTitles: [String] = {
        return ["消息", "个人成就", "我的短视频", "我的直播", "我的等级", "充值", "关于我们"]
    }()
    fileprivate lazy var contentTableView: UITableView = {
        let tableView: UITableView = UITableView(frame: CGRect(x: 0.0, y: 300.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: UITableViewStyle.plain)
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
    fileprivate let photosVC: LSPhotosViewController = LSPhotosViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(avatarView)
        view.addSubview(contentTableView)
    }
    
    // MARK: - private method
    fileprivate func invalidPhotosAccess() -> Bool {
        let authorizationResult = PHPhotoLibrary.authorizationStatus()
        if authorizationResult == .denied || authorizationResult == .restricted {
            return true
        }
        return false
    }
    
    fileprivate func requestUserPhotosAccess(finishedValue: @escaping (Bool)->Void) {
        let requestSemph = DispatchSemaphore(value: 0)
        var requestResult = false
        PHPhotoLibrary.requestAuthorization { (result) in
            if result == .denied || result == .restricted {
                requestResult = false
            } else {
                requestResult = true
            }
            
            requestSemph.signal()
        }
        
        DispatchQueue.global().async {
            let wait = requestSemph.wait(timeout: DispatchTime.distantFuture)
            if wait == .success {
                finishedValue(requestResult)
            }
        }
    }
    
    fileprivate func authorizationSettingAlert(success: @escaping ()->(), cancel: @escaping ()->()) {
        let alertController: UIAlertController = UIAlertController(title: nil, message: "打开设置允许访问您的相册", preferredStyle: UIAlertControllerStyle.alert)
        let settingAction: UIAlertAction = UIAlertAction(title: "设置", style: .default) { [weak self](action) in
            if let strongSelf = self {
                if let settingURL = URL(string: UIApplicationOpenSettingsURLString) {
                    if #available (iOS 10.0, *) {
                        UIApplication.shared.open(settingURL, options: [:], completionHandler: { (result) in
                            print("系统跳转了 2")
                        })
                    } else {
                        UIApplication.shared.openURL(settingURL)
                    }
                }
                success()
                strongSelf.dismiss(animated: true, completion: nil)
            }
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .cancel) { [weak self](action) in
            if let strongSelf = self {
                cancel()
                strongSelf.dismiss(animated: true, completion: nil)
            }
        }
        alertController.addAction(settingAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension LSMainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if (cell == nil)
        {
            cell =  UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        cell?.textLabel?.text = contentTitles[indexPath.row]
        return cell!
    }
}

extension LSMainViewController: LSAvatarViewDelegate {
    func lsAvatarViewDidClickAvatar(_ view: LSAvatarView) {
        if invalidPhotosAccess() {
            authorizationSettingAlert(success: {
            }, cancel: {
            })
        } else {
            requestUserPhotosAccess(finishedValue: { [weak self](result) in
                if let strongSelf = self {
                    if result ==  true {
                        DispatchQueue.main.async {
                            strongSelf.present(strongSelf.photosVC, animated: true, completion: nil)
                        }
                    } else  {
                    }
                }
            })
        }
    }
}


