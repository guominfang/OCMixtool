//
//  OCMConfig.m
//  OCMixtool
//
//  Created by kwok on 2019/4/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import "OCMConfig.h"

@implementation OCMConfig




+ (BOOL)isThirdDirWithName:(NSString *)dir {
    NSArray *thirdDirArray = @[@"Vendor"];
    return [thirdDirArray containsObject:dir];
}

@end
