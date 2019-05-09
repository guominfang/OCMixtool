//
//  OCMFileUtil.m
//  OCMixtool
//
//  Created by kwok on 2019/4/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import "OCMFileUtil.h"
#import "OCMIgnoreFile.h"
#import "OCMConfig.h"

@implementation OCMFileUtil


+ (NSArray *)findAllClassFileFromDirectory:(NSString *)parentDir {
    // 获取该目录下，包含子目录中的 所有 .h .m 文件路径
    NSMutableArray *array = [NSMutableArray array];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:parentDir]) {
        NSLog(@"目录不存在：%@",parentDir);
        return array;
    }
    NSArray *childArray = [fileManager contentsOfDirectoryAtPath:parentDir error:nil];
    
    for (NSString *childName in childArray) {
        NSString *childPath = [parentDir stringByAppendingPathComponent:childName];
        if ([OCMIgnoreFile isIgnoreFileWithName:childName]) {
            // 是否是，需要忽略的文件或目录： 隐藏文件，项目配置文件，第三方框架， 第三方目录
            continue;
        }
        
        BOOL isDir;
        [fileManager fileExistsAtPath:childPath isDirectory:&isDir];
        
        if (isDir) {
            [array addObjectsFromArray:[OCMFileUtil findAllClassFileFromDirectory:childPath]];
        } else {
            if ([childPath hasSuffix:@".h"] || [childPath hasSuffix:@".m"]) {
                [array addObject:childPath];
            }
        }
    }
    
    return array;
}


+ (NSString *)findProjectPbxprojPathFromDirectory:(NSString *)parentDir {
    // 从dir目录中查找project.pbxproj文件的
    NSString *projectPbxprojPath = nil;
    NSString *xcodeprojName = [NSString stringWithFormat:@"%@.xcodeproj", kOldProjectName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileArray = [fileManager contentsOfDirectoryAtPath:parentDir error:nil];
    
    if ([fileArray containsObject:xcodeprojName]) {
        projectPbxprojPath = [[parentDir stringByAppendingPathComponent:xcodeprojName] stringByAppendingPathComponent:@"project.pbxproj"];
        return projectPbxprojPath;
    }
    
    for (NSString *chilName in fileArray) {
        NSString *chilPath = [parentDir stringByAppendingPathComponent:chilName];
        if ([OCMIgnoreFile isIgnoreHiddenFileWithName:chilName]) {
            continue;
        }
        
        BOOL isDir;
        [fileManager fileExistsAtPath:chilPath isDirectory:&isDir];
        if (isDir) {
            projectPbxprojPath = [OCMFileUtil findProjectPbxprojPathFromDirectory:chilPath];
            if ([projectPbxprojPath hasSuffix:@"project.pbxproj"]) {
                return projectPbxprojPath;
            }
        }
    }
    return projectPbxprojPath;
}

@end
