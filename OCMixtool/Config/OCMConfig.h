//
//  OCMConfig.h
//  OCMixtool
//
//  Created by kwok on 2019/4/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import <Foundation/Foundation.h>

// 需要混淆代码的目录
static NSString *kProjectDirPath = @"/Users/kwok/Documents/workplace/iOS/SDK_v4_iOS";
// 需要混淆工具项目的目录（因为 Command Line Tool 项目，不能打包配置文件，所以只能通过这样配置来读取项目的配置文件，从而启动混淆）
static NSString *kMixtoolProjectDir = @"/Users/kwok/Documents/workplace/iOS/OCMixtool/OCMixtool";
// 旧的前缀
static NSString *kOldPrefix = @"AAA";
// 新的前缀
static NSString *kNewPrefix = @"BBB";

NS_ASSUME_NONNULL_BEGIN

@interface OCMConfig : NSObject


// 是否是第三方框架目录
+ (BOOL)isThirdDirWithName:(NSString *)thirdDir;
@end

NS_ASSUME_NONNULL_END