//
//  OCMClassNameModel.m
//  OCMixtool
//
//  Created by guominfang on 2019/5/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import "OCMClassNameModel.h"

@implementation OCMClassNameModel


- (NSString *)classNameNotExtensionRegex {
    return [NSString stringWithFormat:@"\\W%@\\W",self.oldClassName];
}

- (NSString *)classNameExtensionRegex {
    return [NSString stringWithFormat:@"\\W%@\\.%@\\W", self.oldClassName, self.classPath.lastPathComponent.pathExtension];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[OCMClassNameModel class]]) {
        // 不是 OCMClassNameModel 类型
        return NO;
    }
    
    if (self == object) {
        // 内存地址相等
        return YES;
    }
    
    OCMClassNameModel *tempObject = (OCMClassNameModel *)object;
    // oldClassName 、 classPath 相同即相同对象
    BOOL haveEqualClassPath = (!self.classPath && !tempObject.classPath) || [self.classPath isEqualToString:tempObject.classPath];
    BOOL haveEqualOldClassName = (!self.oldClassName && !tempObject.oldClassName) || [self.oldClassName isEqualToString:tempObject.oldClassName];
    return haveEqualClassPath && haveEqualOldClassName;
}

@end
