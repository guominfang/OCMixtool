//
//  OCMIgnoreFile.h
//  OCMixtool
//
//  Created by kwok on 2019/4/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCMIgnoreFile : NSObject

+ (BOOL)isIgnoreFileWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
