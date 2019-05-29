//
//  OCMFileUtil.h
//  OCMixtool
//
//  Created by kwok on 2019/4/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCMConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface OCMFileUtil : NSObject

// 获取该目录下，包含子目录中的 所有 .h .m 文件路径
+ (NSArray *)findAllClassFileFromDirectory:(NSString *)dir;

// 从dir目录中查找project.pbxproj文件的
+ (NSString *)findProjectPbxprojPathFromDirectory:(NSString *)parentDir;

@end

NS_ASSUME_NONNULL_END
