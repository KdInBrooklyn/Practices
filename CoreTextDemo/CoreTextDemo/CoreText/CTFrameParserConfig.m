//
//  CTFrameParserConfig.m
//  CoreTextDemo
//
//  Created by LiSen on 2018/3/3.
//  Copyright © 2018年 lisen. All rights reserved.
//

#import "CTFrameParserConfig.h"
#import "CoreTextDemo-Prefix.pch"

@implementation CTFrameParserConfig

- (id)init {
    self = [super init];
    
    if (self) {
        _width = 200.0f;
        _fontSize = 16.0f;
        _lineSpace = 8.0f;
        _textColor = RGB(108, 108, 108);
    }
    
    return self;
}


@end
