//
//  CTFrameParserConfig.h
//  CoreTextDemo
//
//  Created by LiSen on 2018/3/3.
//  Copyright © 2018年 lisen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CTFrameParserConfig : NSObject

@property (nonatomic, assign) CGFloat width;
@property (nonatomic ,assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, strong) UIColor *textColor;


@end
