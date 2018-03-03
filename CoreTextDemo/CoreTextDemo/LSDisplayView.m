//
//  LSDisplayView.m
//  CoreTextDemo
//
//  Created by LiSen on 2018/3/3.
//  Copyright © 2018年 lisen. All rights reserved.
//

#import "LSDisplayView.h"
#import <CoreText/CoreText.h>

@implementation LSDisplayView

- (void)drawRect:(CGRect)rect {
    [super drawRect: rect];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    
    
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"Hello World! "
                                     " 创建绘制的区域，CoreText 本身支持各种文字排版的区域，"
                                     " 我们这里简单地将 UIView 的整个界面作为排版的区域。"
                                     " 为了加深理解，建议读者将该步骤的代码替换成如下代码，"
                                     " 测试设置不同的绘制区域带来的界面变化。"];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CTFrameRef ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attString length]), path, NULL);
    CTFrameDraw(ctFrame, context);
    
    CFRelease(ctFrame);
    CFRelease(path);
    CFRelease(framesetter);
}


@end
