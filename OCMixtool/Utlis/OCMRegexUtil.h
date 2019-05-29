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

static NSString *classProtocolNameRegex = @"^ *@protocol +(\\w+)";
static NSString *classCategoryNameRegex = @"^ *@interface +\\w+ *\\( *(\\w+) *\\)";
static NSString *classStatementNameRegex = @"^ *@interface +(\\w+) *:";
static NSString *classImplementationNameRegex = @"^ *@implementation +(\\w+) *\\n";

static NSString *eunmNameRegex = @"^ *typedef +NS_ENUM.*?(\\w+)\\)";
static NSString *eunmContentRegex = @"^ *typedef +NS_ENUM.*?(\\{[\\s\\S]*?\\})";
static NSString *eunmFieldRegex = @"^ *[a-z_A-Z]+";
NS_ASSUME_NONNULL_BEGIN

@interface OCMRegexUtil : NSObject
+ (NSArray *)matchString:(NSString *)string toRegexString:(NSString *)regexStr;
+ (NSArray *)matchModelString:(NSString *)string toRegexString:(NSString *)regexStr;
@end

NS_ASSUME_NONNULL_END
