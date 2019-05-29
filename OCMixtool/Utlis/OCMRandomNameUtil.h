//
//  OCMRandomNameUtil.h
//  OCMixtool
//
//  Created by kwok on 2019/4/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OCMRandomNameUtil;
NS_ASSUME_NONNULL_BEGIN
@protocol OCMRandomNameProtocol <NSObject>

@required
- (NSString *)takeOldName:(nullable OCMRandomNameUtil *)randomName;
- (NSString *)generateRandomName:(nullable OCMRandomNameUtil *)randomNameSeft;
- (void)setup:(nullable OCMRandomNameUtil *)randomNameSeft randomName:(NSString *)randomName;

@end


@interface OCMRandomNameUtil : NSObject

// 获取随机属性名
+ (NSString *)randomPropertyName;

// 获取随机方法名
+ (NSString *)randomMethodName;

// 获取随机类名
+ (NSString *)randomClassName;

+ (NSMutableArray *)randomModelArray:(NSMutableArray<id<OCMRandomNameProtocol>> *)modelArray;
@end

NS_ASSUME_NONNULL_END
