//
//  OCMFileUtil.m
//  OCMixtool
//
//  Created by kwok on 2019/4/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import "OCMFileUtil.h"
#import "OCMIgnoreFile.h"

@implementation OCMFileUtil


+ (NSArray *)findAllClassFileFromDirectory:(NSString *)parentDir {
    // 获取该目录下，包含子目录中的 所有 .h .m 文件路径
    NSMutableArray *array = [NSMutableArray array];
    NSFileManager *fileManager = [NSFileManager defaultManager];
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

@end
