//
//  OCMRegexUtil.h
//  OCMixtool
//
//  Created by kwok on 2019/4/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *propertyStatementRegex = @"^\\s*@property[\\s\\S]*?;";
static NSString *propertyNameRegex = @"\\s*\\w+\\s*?;";
static NSString *propertyStatementGetterNameRegex = @"getter\\s*=\\s*\\w*";
static NSString *propertyStatementSetterNameRegex = @"setter\\s*=\\s*\\w*";

NS_ASSUME_NONNULL_BEGIN

@interface OCMRegexUtil : NSObject
+ (NSArray *)matchString:(NSString *)string toRegexString:(NSString *)regexStr;
@end

NS_ASSUME_NONNULL_END
