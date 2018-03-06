//
//  CTView.swift
//  图文混排Demo
//
//  Created by LiSen on 2018/3/4.
//  Copyright © 2018年 lisen. All rights reserved.
//

import UIKit

class CTView: UIView {
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.textMatrix = .identity
        context.translateBy(x: 0.0, y: bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let path = CGMutablePath()
        path.addRect(bounds)
        
        let attrString = NSAttributedString(string: "Hello World")
        
        let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
        
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrString.length), path, nil)
        
        CTFrameDraw(frame, context)
    }
}
