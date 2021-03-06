//
//  OCMIgnoreFile.m
//  OCMixtool
//
//  Created by kwok on 2019/4/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import "OCMIgnoreFile.h"
#import "OCMConfig.h"

@implementation OCMIgnoreFile

+ (BOOL)isIgnoreHiddenFileWithName:(NSString *)fileName {
    // 忽略隐藏文件 .a .framework 配置目录
    return [fileName hasPrefix:@"."] || [fileName hasSuffix:@".a"] || [fileName hasSuffix:@".framework"] || [fileName hasSuffix:@".xcassets"] || [fileName hasSuffix:@".lproj"] || [fileName hasSuffix:@".plist"] || [fileName hasSuffix:@".bundle"] || [fileName hasSuffix:@".plist"];
}

+ (BOOL)isIgnoreFileWithName:(NSString *)fileName {
    // 是否是，需要忽略的文件或目录： 隐藏文件，项目配置文件，第三方框架， 第三方目录
    return [OCMIgnoreFile isIgnoreHiddenFileWithName:fileName] || [fileName hasSuffix:@".xcworkspace"] || [fileName hasSuffix:@".xcodeproj"]  || [OCMConfig isThirdDirWithName:fileName];
}
@end
