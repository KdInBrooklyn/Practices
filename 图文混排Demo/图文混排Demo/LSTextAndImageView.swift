//
//  LSTextAndImageView.swift
//  图文混排Demo
//
//  Created by LiSen on 2018/3/3.
//  Copyright © 2018年 lisen. All rights reserved.
//

import UIKit

class LSTextAndImageView: UIView {
    var image: UIImage?
    var imageFrameArr: NSMutableArray = NSMutableArray()
    var ctFrame: CTFrame?
    
    private let imageName: String = "boy"
    private let urlImage: String = "http://img3.3lian.com/2013/c2/64/d/65.jpg"
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //获取上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        //转换坐标
        convertCoordinateSystem(context: context)
        //绘制区域
        let mutablePath = UIBezierPath(rect: rect)
        //创建需要绘制的文字并设置相应的属性
        let mutableAttributedString = settingTextAndAttributes()
        //为本地图片设置CTRunDelegate, 添加占位符
        addCTRunDelegate(with: urlImage, identifier: urlImage, insertIndex: 18, attributteStr: mutableAttributedString)
        //使用mutableAttributedString生成framesetter, 使用framesetter生成CTFrame
        let frameSetter = CTFramesetterCreateWithAttributedString(mutableAttributedString)
        ctFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, mutableAttributedString.length), mutablePath.cgPath, nil)
        CTFrameDraw(ctFrame!, context)
        
    }
    
    //对坐标系进行转换, 因为Core Graphics中默认的坐标系原点在左下角
    private func convertCoordinateSystem(context: CGContext) {
        context.textMatrix = CGAffineTransform.identity
        context.translateBy(x: 0.0, y: self.frame.height)
        context.scaleBy(x: 1.0, y: -1.0)
    }
    
    private func settingTextAndAttributes() -> NSMutableAttributedString {
        let attrString = "人的智慧掌握着三把钥匙，一把开启数字，一把开启字母，一把开启音符。知识、思想、幻想就在其中。人生的价值，并不是用时间，而是用深度去衡量的。人们常觉得准备的阶段是在浪费时间，只有当真正机会来临，而自己没有能力把握的时候，才能觉悟自己平时没有准备才是浪费了时间。"
        let mutableAttributedString = NSMutableAttributedString(string: attrString)
        mutableAttributedString.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20.0)], range: NSRange.init(location: 0, length: attrString.count))
        mutableAttributedString.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 25), NSAttributedStringKey.foregroundColor: UIColor.red], range: NSRange(location: 0, length: 33))
        mutableAttributedString.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)], range: NSMakeRange(33, 36))
        //设置段落样式
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6.0
        mutableAttributedString.addAttributes([NSAttributedStringKey.paragraphStyle: style], range: NSMakeRange(0, mutableAttributedString.length))
        return mutableAttributedString
    }
    
    private func addCTRunDelegate(with imageStr: String, identifier: String, insertIndex: Int, attributteStr: NSMutableAttributedString) {
        var imageName = imageStr
        var imageCallback = CTRunDelegateCallbacks(version: kCTRunDelegateVersion1, dealloc: { (_) in
            print("RunDelegate dealloc")
        }, getAscent: { (conRef) -> CGFloat in
            return 100
        }, getDescent: { (conRef) -> CGFloat in
            return 0
        }) { (conRef) -> CGFloat in
            return 100
        }
        
        let runDelegate = CTRunDelegateCreate(&imageCallback, &imageName)
        let imgAttributedStr = NSMutableAttributedString(string: "")
        imgAttributedStr.addAttribute(kCTRunDelegateAttributeName as NSAttributedStringKey, value: runDelegate!, range: NSMakeRange(0, 1))
        imgAttributedStr.addAttribute(NSAttributedStringKey(rawValue: identifier), value: imageName, range: NSMakeRange(0, 1))
    }
    
}
