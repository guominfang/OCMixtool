//
//  OCMBlockModel.m
//  OCMixtool
//
//  Created by guominfang on 2019/5/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import "OCMBlockModel.h"

@implementation OCMBlockModel


#pragma mark -- OCMRandomNameProtocol
- (NSString *)takeOldName:(OCMRandomNameUtil *)randomNameSeft {
    return self.oldBlockName;
}

- (NSString *)generateRandomName:(OCMRandomNameUtil *)randomNameSeft {
    return [OCMRandomNameUtil randomClassName];
}

- (void)setup:(OCMRandomNameUtil *)randomNameSeft randomName:(NSString *)randomName {
    self.randomBlockName = randomName;
}

#pragma mark -- OCModityFileContentProtocol
- (NSString *)oldNameToModityFileContent:(OCModityFileContent *)OCModityFileContent {
    return self.oldBlockName;
}

- (NSString *)newNameToModityFileContent:(OCModityFileContent *)OCModityFileContent {
    return self.randomBlockName;
}

- (BOOL)enabledModityFileContent:(OCModityFileContent *)OCModityFileContent {
    return YES;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[OCMBlockModel class]]) {
        // 不是 OCMClassNameModel 类型
        return NO;
    }
    
    if (self == object) {
        // 内存地址相等
        return YES;
    }
    
    OCMBlockModel *tempObject = (OCMBlockModel *)object;
    // oldName 相同即相同对象
    BOOL haveEqualOldName = (!self.oldBlockName && !tempObject.oldBlockName) || [self.oldBlockName isEqualToString:tempObject.oldBlockName];
    return haveEqualOldName;
}

@end
