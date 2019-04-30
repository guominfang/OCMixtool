//
//  OCMixPropertyName.m
//  OCMixtool
//
//  Created by kwok on 2019/4/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import "OCMixPropertyName.h"
#import "OCMFileUtil.h"
#import "OCMConfig.h"
#import "OCMRegexUtil.h"
#import "OCMPropertyModel.h"
#import "OCMRandomNameUtil.h"

@implementation OCMixPropertyName

+ (void)mixPropertyName {
    // 查找所有属性定义，生成 OCMPropertyModel
    NSArray *allClassFilePath = [OCMFileUtil findAllClassFileFromDirectory:kProjectDirPath];
    NSMutableArray *allPropertyModel = [OCMixPropertyName findAllPropertyModelFromFile:allClassFilePath];
    allPropertyModel = [OCMixPropertyName generateRandomPropertyNameWtihPropertyModelArray:allPropertyModel];
    allPropertyModel = [OCMixPropertyName contrastPropertyName:allPropertyModel];
    // 开始修改文本内容
    [OCMixPropertyName modifyFileContentWithAllFile:allClassFilePath allPropertyModel:allPropertyModel];
}

+ (NSMutableArray*)findAllPropertyModelFromFile:(NSArray *)allFile {
    // 查找所有使用 @property 定义的属性
    NSMutableArray *allProperty = [NSMutableArray array];
    for (NSString *filePath in allFile) {
        NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSArray *propertyList = [OCMRegexUtil matchString:fileContent toRegexString:propertyStatementRegex];
        if (propertyList.count == 0) {
            continue;
        }
        
        for (NSString *propertyStatement in propertyList) {
            NSArray *propertyNameList = [OCMRegexUtil matchString:propertyStatement toRegexString:propertyNameRegex];
            if (propertyNameList.count == 0) {
                continue;
            }
            
            NSString *propertyName = propertyNameList[0];
            propertyName = [propertyName stringByReplacingOccurrencesOfString:@" " withString:@""];
            propertyName = [propertyName stringByReplacingOccurrencesOfString:@";" withString:@""];
            
            if ([propertyName isEqualToString:@"UI_APPEARANCE_SELECTOR"]) {
                NSString *tempPropertyStatement = [propertyStatement stringByReplacingOccurrencesOfString:@"UI_APPEARANCE_SELECTOR" withString:@""];
                propertyNameList = [OCMRegexUtil matchString:tempPropertyStatement toRegexString:propertyNameRegex];
                propertyName = propertyNameList[0];
                propertyName = [propertyName stringByReplacingOccurrencesOfString:@" " withString:@""];
                propertyName = [propertyName stringByReplacingOccurrencesOfString:@";" withString:@""];
            }
            
            if ([OCMixPropertyName isSystemPropertyName:propertyName]) {
                continue;
            }
 
            OCMPropertyModel *propertyModel = [[OCMPropertyModel alloc] init];
            propertyModel.classFilePath = filePath;
            propertyModel.propertyStatement = propertyStatement;
            propertyModel.propertyName = propertyName;
            [allProperty addObject:propertyModel];
        }
    }
    return allProperty;
}

// 系统自带的属性名
static NSArray *ignoreSystemPropertyName = nil;

+ (BOOL)isSystemPropertyName:(NSString *)propertyName {
    // 是否，和系统属性同名
    if (!ignoreSystemPropertyName) {
        NSString *ignorePropertyFilePath = [[kMixtoolProjectDir stringByAppendingPathComponent:@"MixPropertyName"] stringByAppendingPathComponent:@"system_property_name.plist"];
        ignoreSystemPropertyName = [NSArray arrayWithContentsOfFile:ignorePropertyFilePath];
    }
    return [ignoreSystemPropertyName containsObject:propertyName];
}


+ (NSMutableArray *)generateRandomPropertyNameWtihPropertyModelArray:(NSMutableArray *)allPropertyModel {
    // 生成 PropertyModel 随机属性名称
    if (allPropertyModel.count == 0) {
        return allPropertyModel;
    }
    
    NSMutableArray *allPropertyName = [NSMutableArray array];
    for (OCMPropertyModel *propertyModel in allPropertyModel) {
        if ([allPropertyName containsObject:propertyModel.propertyName]) {
            continue;
        }
        [allPropertyName addObject:propertyModel.propertyName];
    }
    
    for (OCMPropertyModel *propertyModel in allPropertyModel) {
        NSString *randomPropertyName = [OCMRandomNameUtil randomPropertyName];
        while ([allPropertyName containsObject:randomPropertyName]) {
            randomPropertyName = [OCMRandomNameUtil randomPropertyName];
        }
        [allPropertyName addObject:randomPropertyName];
        propertyModel.propertyNewName = randomPropertyName;
    }
    return allPropertyModel;
}

+ (NSMutableArray *)contrastPropertyName:(NSMutableArray *)allPropertyModel {
    // 原先属性名一致的话，那就把随机到新方法名也设置成一致
    for (OCMPropertyModel *outsideModel in allPropertyModel) {
        for (OCMPropertyModel *innerModel in allPropertyModel) {
            if ([outsideModel.propertyName isEqualToString:innerModel.propertyName]) {
                if (![outsideModel.propertyNewName isEqualToString:innerModel.propertyNewName]) {
                    outsideModel.propertyNewName = innerModel.propertyNewName;
                }
            }
        }
    }
    return allPropertyModel;
}

+ (void)modifyFileContentWithAllFile:(NSArray *)allClassFile allPropertyModel:(NSMutableArray *)allPropertyModel {
    [OCMixPropertyName modiftyPropertyStatement:allPropertyModel];
    [OCMixPropertyName modiftyUsePropery:allClassFile allPropertyModel:allPropertyModel];
}

+ (void)modiftyPropertyStatement:(NSMutableArray *)allProperty {
    // 修改 使用 @property来定义的属性
    NSMutableArray *allFile = [NSMutableArray array];
    for (OCMPropertyModel *propertyModel in allProperty) {
        if ([allFile containsObject:propertyModel.classFilePath]) {
            continue;
        }
        [allFile addObject:propertyModel.classFilePath];
    }
    
    for (NSString *filePath in allFile) {
        NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        for (OCMPropertyModel *propertyModel in allProperty) {
            if ([filePath isEqualToString:propertyModel.classFilePath]) {
                fileContent = [fileContent stringByReplacingOccurrencesOfString:propertyModel.propertyStatement withString:[propertyModel propertyNewStatement]];
            }
        }
        [fileContent writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

+ (void)modiftyUsePropery:(NSArray *)allFile allPropertyModel:(NSMutableArray *)allProperty {
    // 修改.m文件 调用属性的地方
    for (NSString *filePath in allFile) {
        if ([filePath hasSuffix:@".h"]) {
            continue;
        }
        NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSNumber *isModifty = @0;
        for (OCMPropertyModel *propertyModel in allProperty) {
            // _语法使用方式
            fileContent = [OCMixPropertyName replacingContent:fileContent regex:propertyModel.privateRegex oldName:propertyModel.propertyName newName:propertyModel.propertyNewName isModifty:&isModifty];
            
            // .语法使用方式
            fileContent = [OCMixPropertyName replacingContent:fileContent regex:propertyModel.pointRegex oldName:propertyModel.propertyName newName:propertyModel.propertyNewName isModifty:&isModifty];
            
            // set语法使用方式
//            NSString *oldName = [OCMixPropertyName capitalizedString:propertyModel.propertyName];
//            NSString *newName = [OCMixPropertyName capitalizedString:propertyModel.propertyNewName];
//            NSString *setRegex = [NSString stringWithFormat:@"\\Wset%@\\W",oldName];
//            fileContent = [OCMixPropertyName replacingContent:fileContent regex:setRegex oldName:oldName newName:newName isModifty:&isModifty];
            
            // get语法使用方式
            //            NSString *getRegex = [NSString stringWithFormat:@"\\W%@\\s*?]",propertyModel.propertyName];
            //            fileContent = [ATCModifyPropertyName replacingContent:fileContent regex:getRegex oldName:propertyModel.propertyName newName:propertyModel.propertyNewName isModifty:&isModifty];
        }
        
        if (isModifty) {
            [fileContent writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }
}


+ (NSString *)replacingContent:(NSString *)fileContent regex:(NSString *)regex oldName:(NSString *)oldName  newName:(NSString *)newName isModifty:(NSNumber **)isModifty {
    NSArray *regexArray = [OCMRegexUtil matchString:fileContent toRegexString:regex];
    for (NSString *content in regexArray) {
        NSString *newContent = [content stringByReplacingOccurrencesOfString:oldName withString:newName];
        fileContent = [fileContent stringByReplacingOccurrencesOfString:content withString:newContent];
        *isModifty = @1;
    }
    return fileContent;
}

@end
