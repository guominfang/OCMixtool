//
//  OCMClassNameModel.h
//  OCMixtool
//
//  Created by guominfang on 2019/5/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCMClassNameModel : NSObject

@property (copy, nonatomic) NSString *classPath;
@property (copy, nonatomic) NSString *oldClassName;
@property (copy, nonatomic) NSString *randomClassName;

- (NSString *)classNameNotExtensionRegex;
- (NSString *)classNameExtensionRegex;
@end

NS_ASSUME_NONNULL_END
