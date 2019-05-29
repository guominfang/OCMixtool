//
//  OCMixClassName.m
//  OCMixtool
//
//  Created by guominfang on 2019/5/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import "OCMixClassName.h"
#import "OCMFileUtil.h"
#import "OCMClassNameModel.h"
#import "OCMRandomNameUtil.h"
#import "OCMRegexUtil.h"

@implementation OCMixClassName

+ (void)mixClassName {
    NSArray *fileArray = [OCMFileUtil findAllClassFileFromDirectory:kProjectDirPath];
    NSMutableArray *modelArray = [OCMixClassName classNameModelArray:fileArray];
    [OCMixClassName modityFileContent:modelArray];
    [OCMixClassName modityFileName:modelArray];
    [OCMixClassName modifyProjectPbxprojContent:modelArray];
}

+ (NSMutableArray *)classNameModelArray:(NSArray *)fileArray {
    // 构建 OCMClassNameModel 对象列表
    NSMutableArray *classNameModel = [NSMutableArray array];
    for (NSString *classPath in fileArray) {
        NSString *fileContent = [NSString stringWithContentsOfFile:classPath encoding:NSUTF8StringEncoding error:nil];
        // 一个文件只定义了一个类
        OCMClassNameModel *model = [[OCMClassNameModel alloc] init];
        model.classPath = classPath;
        model.oldClassName = classPath.lastPathComponent.stringByDeletingPathExtension; // .h .m
        if ([model.oldClassName containsString:@"+"]) {
            model.oldClassName = [model.oldClassName componentsSeparatedByString:@"+"][1];
        }
        if (![classNameModel containsObject:model]) {
            [classNameModel addObject:model];
        }
        
        // 一个文件存在多个 类定义
        // 获取 protocol 类名
        classNameModel = [OCMixClassName regexFindClassName:classNameModel filePath:classPath content:fileContent regext:classProtocolNameRegex];
        // 获取category 类名
        classNameModel = [OCMixClassName regexFindClassName:classNameModel filePath:classPath content:fileContent regext:classCategoryNameRegex];
        // 获取类声明 类名
        classNameModel = [OCMixClassName regexFindClassName:classNameModel filePath:classPath content:fileContent regext:classStatementNameRegex];
        // 获取类实现 类名
        classNameModel = [OCMixClassName regexFindClassName:classNameModel filePath:classPath content:fileContent regext:classImplementationNameRegex];
    }
    
    // 生成新的，不重复的随机类名
    NSMutableDictionary *allRandomName = [NSMutableDictionary dictionary];
    for (OCMClassNameModel *model in classNameModel) {
        // 旧类名 --> 字典的key
        allRandomName[model.oldClassName] = @"";
    }
    
    for (OCMClassNameModel *model in classNameModel) {
        if (![model.oldClassName containsString:kNewPrefix]) {
            // 类名不包含 kNewPrefix 的类文件，不生成随机类名，也不进行混淆
            continue;
        }
        
        if (![allRandomName[model.oldClassName] isEqualToString:@""]) {
            // 旧类名相同，随机的新类名，也保持一样
            model.randomClassName = allRandomName[model.oldClassName];
            continue;
        }
        
        NSString *randomName = [OCMRandomNameUtil randomClassName];
        while ([allRandomName.allKeys containsObject:randomName] || [allRandomName.allValues containsObject:randomName]) {
            // 保证随机类名 不与 原先类名相同以及已生成的随机类名 相同
            randomName = [OCMRandomNameUtil randomClassName];
        }
        allRandomName[model.oldClassName] = randomName;
        model.randomClassName = randomName;
    }
    return classNameModel;
}

+ (NSMutableArray *)regexFindClassName:(NSMutableArray *)classNameModel filePath:(NSString *)classPath content:(NSString *)content regext:(NSString *)regext {
    NSArray *implenmentaionNames = [OCMRegexUtil matchModelString:content toRegexString:classImplementationNameRegex];
    for (NSString *name in implenmentaionNames) {
        OCMClassNameModel *model = [[OCMClassNameModel alloc] init];
        model.classPath = classPath;
        model.oldClassName = name;
        if (![classNameModel containsObject:model]) {
            [classNameModel addObject:model];
        }
    }
    return classNameModel;
}

+ (void)modityFileContent:(NSArray *)allModelArray {
    // 修改文件内容中的类名
    for (OCMClassNameModel *fileModel in allModelArray) {
        NSString *fileContent = [NSString stringWithContentsOfFile:fileModel.classPath encoding:NSUTF8StringEncoding error:nil];
        for (OCMClassNameModel *model in allModelArray) {
            if (!model.randomClassName) {
                // 没有随机类名的，也就不需要进行混淆和修改
                continue;
            }
            
            NSArray *regexContents = [OCMRegexUtil matchString:fileContent toRegexString:[model classNameNotExtensionRegex]];
            for (NSString *regexContent in regexContents) {
                NSString *newContent = [regexContent stringByReplacingOccurrencesOfString:model.oldClassName withString:model.randomClassName];
                fileContent = [fileContent stringByReplacingOccurrencesOfString:regexContent withString:newContent];
            }
        }
        [fileContent writeToFile:fileModel.classPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

+ (void)modityFileName:(NSArray *)allModelArray {
    // 修改文件名称中的类名
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (OCMClassNameModel *model in allModelArray) {
        if (!model.randomClassName) {
            // 没有随机类名的，也就不需要进行混淆和修改
            continue;
        }
        NSString *newCompoent = [model.classPath.lastPathComponent stringByReplacingOccurrencesOfString:model.oldClassName withString:model.randomClassName];
        NSString *newFilePath = [model.classPath.stringByDeletingLastPathComponent stringByAppendingPathComponent:newCompoent];
        [fileManager moveItemAtPath:model.classPath toPath:newFilePath error:nil];
    }
}

+ (void)modifyProjectPbxprojContent:(NSArray *)allModelArray {
    // 更新projectPdxproj配置文件内容中的类名
    NSString *pbxprojFilePath = [OCMFileUtil findProjectPbxprojPathFromDirectory:kProjectDirPath];
    if (!pbxprojFilePath) {
        NSLog(@"找不到project.pbxproj文件");
        return;
    }
    
    NSString *pbxprojFileContent = [NSString stringWithContentsOfFile:pbxprojFilePath encoding:NSUTF8StringEncoding error:nil];
    for (OCMClassNameModel *model in allModelArray) {
        if (!model.randomClassName) {
            // 没有随机类名的，也就不需要进行混淆和修改
            continue;
        }
        NSArray *regexContents = [OCMRegexUtil matchString:pbxprojFileContent toRegexString:[model classNameExtensionRegex]];
        for (NSString *regexContent in regexContents) {
            NSString *newContent = [regexContent stringByReplacingOccurrencesOfString:model.oldClassName withString:model.randomClassName];
            pbxprojFileContent = [pbxprojFileContent stringByReplacingOccurrencesOfString:regexContent withString:newContent];
        }
    }
    [pbxprojFileContent writeToFile:pbxprojFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end
