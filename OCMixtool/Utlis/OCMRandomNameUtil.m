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

+ (NSMutableArray *)randomModelArray:(NSMutableArray<id<OCMRandomNameProtocol>> *)modelArray {
    // 生成新的，不重复的随机名称, 并且也原先的名称也不一样
    NSMutableDictionary *allRandomName = [NSMutableDictionary dictionary];
    for (id<OCMRandomNameProtocol> model in modelArray) {
        // 旧名称 --> 字典的key
        allRandomName[[model takeOldName:nil]] = @"";
    }
    
    for (id<OCMRandomNameProtocol> model in modelArray) {
        if (![allRandomName[[model takeOldName:nil]] isEqualToString:@""]) {
            // 旧名称相同，随机的新名，也保持一样
            [model setup:nil randomName:allRandomName[[model takeOldName:nil]]];
            continue;
        }
        
        NSString *randomName = [model generateRandomName:nil];
        while ([allRandomName.allKeys containsObject:randomName] || [allRandomName.allValues containsObject:randomName]) {
            // 保证随机类名 不与 原先类名相同以及已生成的随机类名 相同
            randomName = [model generateRandomName:nil];
        }
        allRandomName[[model takeOldName:nil]] = randomName;
        [model setup:nil randomName:randomName];
    }
    
    return modelArray;
}

@end
