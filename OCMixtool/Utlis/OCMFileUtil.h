//
//  OCMFileUtil.h
//  OCMixtool
//
//  Created by kwok on 2019/4/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCMFileUtil : NSObject

// 获取该目录下，包含子目录中的 所有 .h .m 文件路径
+ (NSArray *)findAllClassFileFromDirectory:(NSString *)dir;
@end

NS_ASSUME_NONNULL_END
