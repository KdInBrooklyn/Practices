//
//  CTFrameParser.h
//  CoreTextDemo
//
//  Created by LiSen on 2018/3/3.
//  Copyright © 2018年 lisen. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "CoreTextData.h"
#import "CoreTextDemo-Prefix.pch"

@interface CTFrameParser : NSObject

+ (CoreTextData *)parserContent: (NSString *)content config: (CTFrameParserConfig *)config;

@end
