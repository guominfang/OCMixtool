//
//  OCMPropertyModel.m
//  OCMixtool
//
//  Created by kwok on 2019/4/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import "OCMPropertyModel.h"
#import "OCMRegexUtil.h"
@implementation OCMPropertyModel

- (NSString *)propertyNewStatement {
    // 新属性名称 定义
    return [self.propertyStatement stringByReplacingOccurrencesOfString:self.propertyName withString:self.propertyNewName];
}

- (NSString *)privateRegex {
    // 属性：_语法使用方式
    return [NSString stringWithFormat:@"\\W_%@\\W",self.propertyName];
}

- (NSString *)pointRegex {
    // 属性：.语法使用方式
    return [NSString stringWithFormat:@"\\.%@\\W",self.propertyName];
}

- (NSString *)setterPropertyMethodNameRegex {
    // 属性： set方法 使用方式
    return [NSString stringWithFormat:@"\\W%@\\W",self.setterPropertyMethodName];
}

- (NSString *)getterPropertyMethodNameRegex {
    // 属性： set方法 使用方式
    return [NSString stringWithFormat:@"\\W%@\\W",self.getterPropertyMethodName];
}

- (NSString *)setterMethodName:(NSString *)propertyName {
    // 根据 propertyName 生成 set方法名称
    NSString *firstChart = [[propertyName substringWithRange:NSMakeRange(0, 1)] uppercaseString];
    NSString *otherChart = [propertyName substringFromIndex:1];
    return [NSString stringWithFormat:@"set%@%@", firstChart, otherChart];
}

- (NSString *)customSetterPropertyMethodName {
    return [self customPropertyMethodNameWithRegex:propertyStatementGetterNameRegex];
}

- (NSString *)customGetterPropertyMethodName {
    return [self customPropertyMethodNameWithRegex:propertyStatementGetterNameRegex];
}

- (NSString *)customPropertyMethodNameWithRegex:(NSString *)regex {
    // @property (copy, nonatomic, getter=isClass, setter=addad:) NSString *classFilePath;
    // 获取使用 属性的属性来自定义的属性 get set 方法名
    NSArray *methodNameList = [OCMRegexUtil matchString:self.propertyStatement toRegexString:regex];
    NSString *methodName = nil;
    if (methodNameList.count != 0) {
        methodName = [methodNameList[0] componentsSeparatedByString:@"="][1];
    }
    return methodName;
}

@end
