//
//  OCMRandomNameUtil.m
//  OCMixtool
//
//  Created by kwok on 2019/4/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import "OCMRandomNameUtil.h"

@implementation OCMRandomNameUtil


+ (NSString *)randomPropertyName {
    // 获取随机属性名 4～8个字符长度
    return [OCMRandomNameUtil randomNameMinLength:4 length:4];
}

+ (NSString *)randomMethodName {
    // 获取随机方法名 5～10个字符长度
    return [OCMRandomNameUtil randomNameMinLength:5 length:5];
}

+ (NSString *)randomClassName {
    // 获取随机类名 12～20字符长度
    return [OCMRandomNameUtil randomNameMinLength:12 length:8];
}

static NSString *letterTable = @"qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM";

+ (NSString *)randomNameMinLength:(int)minLength length:(int)length {
    // 随机组合，生成字符串，长度为 minLength  ~ (minLength + length)
    NSMutableString *randomName = [NSMutableString string];
    NSInteger len = arc4random_uniform(length) + minLength;
    for (NSInteger i = 0; i < len; i++) {
        NSInteger index = arc4random_uniform(52);
        [randomName appendString:[letterTable substringWithRange:NSMakeRange(index, 1)]];
    }
    return randomName;
}

@end
