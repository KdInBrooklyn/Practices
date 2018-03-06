//
//  MarkupParser.swift
//  图文混排Demo
//
//  Created by LiSen on 2018/3/4.
//  Copyright © 2018年 lisen. All rights reserved.
//

import UIKit
import CoreText

class MarkupParser: NSObject {
    // MARK: properties
    var color: UIColor = .black
    var fontName: String = "Arial"
    var attrString: NSMutableAttributedString!
    var images: [[String: Any]] = []
    
    // MARK: initializers
    override init() {
        super.init()
    }
    
    func parseMarkup(_ markup: String) {
        attrString = NSMutableAttributedString(string: "")
        do {
            let regex = try NSRegularExpression(pattern: "(.*?)(<[^>]+>|\\Z)", options: [.caseInsensitive, .dotMatchesLineSeparators])
            let chunks = regex.matches(in: markup, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: markup.count))
            
            let defaultFont: UIFont = UIFont.systemFont(ofSize: UIScreen.main.bounds.size.height/40.0)
            for chunk in chunks {
                guard let markupRange = markup.range(from: chunk.range) else { continue }
                
                let parts = markup[markupRange].components(separatedBy: "<")
                let font = UIFont(name: fontName, size: UIScreen.main.bounds.size.height/40.0) ?? defaultFont
                
                let attrs = [NSAttributedStringKey.foregroundColor: color, NSAttributedStringKey.font: font] as [NSAttributedStringKey: Any]
                let text = NSMutableAttributedString(string: parts[0], attributes: attrs)
                attrString.append(text)
            }
            
        } catch _ {
            
        }
    }
}

extension String {
    func range(from range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex),
        let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex),
        let from = String.Index(from16, within: self), let to = String.Index(to16, within: self) else {
            return nil
        }
        
        return from..<to
    }
}


