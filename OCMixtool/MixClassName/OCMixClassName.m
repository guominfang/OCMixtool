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
#import "OCMRegexUtil.h"

@implementation OCMixClassName

+ (void)mixClassName {
    NSArray *fileArray = [OCMFileUtil findAllClassFileFromDirectory:kProjectDirPath];
    NSMutableArray *modelArray = [OCMixClassName classNameModelArray:fileArray];
    [[[OCModityFileContent alloc] init] mixFileContent:fileArray model:modelArray];
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
        
        // 因为 类名、Block、Eunm的名称不能一样，避免重复，集合在一起混淆
        // 一个文件存在多个 类定义 Block Enum
        // 获取 protocol 类名
        classNameModel = [OCMixClassName regexFindClassName:classNameModel filePath:classPath content:fileContent regext:classProtocolNameRegex];
        // 获取 category 类名
        classNameModel = [OCMixClassName regexFindClassName:classNameModel filePath:classPath content:fileContent regext:classCategoryNameRegex];
        // 获取类声明 类名
        classNameModel = [OCMixClassName regexFindClassName:classNameModel filePath:classPath content:fileContent regext:classStatementNameRegex];
        // 获取类实现 类名
        classNameModel = [OCMixClassName regexFindClassName:classNameModel filePath:classPath content:fileContent regext:classImplementationNameRegex];
        
        // 混淆 Block
        // 局部变量 方式定义的Block
        classNameModel = [OCMixClassName regexFindClassName:classNameModel filePath:classPath content:fileContent regext:blockLocalRegex];
        // 属性 方式定义的Block
        classNameModel = [OCMixClassName regexFindClassName:classNameModel filePath:classPath content:fileContent regext:blockPropertyRegex];
        // Typedef 方式定义的Block
        classNameModel = [OCMixClassName regexFindClassName:classNameModel filePath:classPath content:fileContent regext:blockTypedefRegex];
        
        // 混淆 ENUM
        // eunm 名称
        classNameModel = [OCMixClassName regexFindClassName:classNameModel filePath:classPath content:fileContent regext:eunmNameRegex];
        // eunm 内容
        NSArray *eunmContent = [OCMRegexUtil matchModelString:fileContent toRegexString:eunmContentRegex];
        for (NSString *content in eunmContent) {
            // eunm 字段名
            classNameModel = [OCMixClassName regexFindClassName:classNameModel filePath:classPath content:content regext:eunmFieldRegex];
        }
    }
    
    // 生成新的，不重复的随机类名
    classNameModel = [OCMRandomNameUtil randomModelArray:classNameModel];
    return classNameModel;
}

+ (NSMutableArray *)regexFindClassName:(NSMutableArray *)classNameModel filePath:(NSString *)classPath content:(NSString *)content regext:(NSString *)regext {
    NSArray *regextContentNames = [OCMRegexUtil matchModelString:content toRegexString:regext];
    for (NSString *name in regextContentNames) {
        OCMClassNameModel *model = [[OCMClassNameModel alloc] init];
        model.classPath = classPath;
        model.oldClassName = name;
        if (![classNameModel containsObject:model]) {
            [classNameModel addObject:model];
        }
    }
    return classNameModel;
}

+ (void)modityFileName:(NSArray *)allModelArray {
    // 修改文件名称中的类名
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (OCMClassNameModel *model in allModelArray) {
        if (![model enabledModityFileContent:nil]) {
            // 类名不包含 kNewPrefix 的类文件，不生成随机类名，也不进行混淆
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
        if (![model enabledModityFileContent:nil]) {
            // 类名不包含 kNewPrefix 的类文件，不生成随机类名，也不进行混淆
            continue;
        }
        
        NSString *oldRegex = [NSString stringWithFormat:@"\\W%@\\.%@\\W", model.oldClassName, model.classPath.lastPathComponent.pathExtension];
        NSArray *regexContents = [OCMRegexUtil matchString:pbxprojFileContent toRegexString:oldRegex];
        for (NSString *regexContent in regexContents) {
            NSString *newContent = [regexContent stringByReplacingOccurrencesOfString:model.oldClassName withString:model.randomClassName];
            pbxprojFileContent = [pbxprojFileContent stringByReplacingOccurrencesOfString:regexContent withString:newContent];
        }
    }
    [pbxprojFileContent writeToFile:pbxprojFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end
