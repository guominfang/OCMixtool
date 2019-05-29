//
//  OCModityPrefix.m
//  OCMixtool
//
//  Created by guominfang on 2019/5/9.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import "OCModityPrefix.h"
#import "OCMFileUtil.h"

@implementation OCModityPrefix

+ (void)modityPrefix {
    NSArray *fileArray = [OCMFileUtil findAllClassFileFromDirectory:kProjectDirPath];
    [OCModityPrefix modityFileContentPrefix:fileArray];
    [OCModityPrefix modityFileNamePrefix:fileArray];
    [OCModityPrefix modifyProjectPbxprojContent:fileArray];
}

+ (void)modityFileContentPrefix:(NSArray *)allClassFileArray {
    // 修改文件内容中的前缀
    for (NSString *filePath in allClassFileArray) {
        NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        if ([fileContent containsString:kOldPrefix]) {
            fileContent = [fileContent stringByReplacingOccurrencesOfString:kOldPrefix withString:kNewPrefix];
            [fileContent writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }
}

+ (void)modityFileNamePrefix:(NSArray *)allClassFileArray {
    // 修改文件名称中的前缀
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (NSString *filePath in allClassFileArray) {
        if ([filePath.lastPathComponent containsString:kOldPrefix]) {
            NSString *newFilePath = [filePath.stringByDeletingLastPathComponent stringByAppendingPathComponent:[filePath.lastPathComponent stringByReplacingOccurrencesOfString:kOldPrefix withString:kNewPrefix]];
            [fileManager moveItemAtPath:filePath toPath:newFilePath error:nil];
        }
    }
}

+ (void)modifyProjectPbxprojContent:(NSArray *)allClassFileArray {
    // 更新projectPdxproj配置文件内容
    NSString *pbxprojFilePath = [OCMFileUtil findProjectPbxprojPathFromDirectory:kProjectDirPath];
    if (!pbxprojFilePath) {
        NSLog(@"找不到project.pbxproj文件");
        return;
    }
    
    NSString *pbxprojFileContent = [NSString stringWithContentsOfFile:pbxprojFilePath encoding:NSUTF8StringEncoding error:nil];
    for (NSString *filePath in allClassFileArray) {
        if ([filePath.lastPathComponent containsString:kOldPrefix]) {
            NSString *newFileName = [filePath.lastPathComponent stringByReplacingOccurrencesOfString:kOldPrefix withString:kNewPrefix];
            pbxprojFileContent = [pbxprojFileContent stringByReplacingOccurrencesOfString:filePath.lastPathComponent withString:newFileName];
        }
    }
    [pbxprojFileContent writeToFile:pbxprojFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}


@end
