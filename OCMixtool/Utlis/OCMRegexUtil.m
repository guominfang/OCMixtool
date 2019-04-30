//
//  OCMRegexUtil.m
//  OCMixtool
//
//  Created by kwok on 2019/4/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import "OCMRegexUtil.h"

@implementation OCMRegexUtil

+ (NSArray *)matchString:(NSString *)string toRegexString:(NSString *)regexStr {
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionAnchorsMatchLines error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    
    NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    //match: 所有匹配到的字符,根据() 包含级
    NSMutableArray *array = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        for (int i = 0; i < [match numberOfRanges]; i++) {
            //以正则中的(),划分成不同的匹配部分
            NSString *component = [string substringWithRange:[match rangeAtIndex:i]];
            [array addObject:component];
        }
    }
    
    return array;
}

@end
