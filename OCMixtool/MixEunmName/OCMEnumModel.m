//
//  OCMEnumModel.m
//  OCMixtool
//
//  Created by guominfang on 2019/5/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import "OCMEnumModel.h"

@implementation OCMEnumModel

#pragma mark -- OCMRandomNameProtocol
- (NSString *)takeOldName:(OCMRandomNameUtil *)randomNameSeft {
    return self.oldName;
}

- (NSString *)generateRandomName:(OCMRandomNameUtil *)randomNameSeft {
    return [OCMRandomNameUtil randomClassName];
}

- (void)setup:(OCMRandomNameUtil *)randomNameSeft randomName:(NSString *)randomName {
    self.randomName = randomName;
}

#pragma mark -- OCModityFileContentProtocol
- (NSString *)oldNameToModityFileContent:(OCModityFileContent *)OCModityFileContent {
    return self.oldName;
}

- (NSString *)newNameToModityFileContent:(OCModityFileContent *)OCModityFileContent {
    return self.randomName;
}

- (BOOL)enabledModityFileContent:(OCModityFileContent *)OCModityFileContent {
    return YES;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[OCMEnumModel class]]) {
        // 不是 OCMClassNameModel 类型
        return NO;
    }
    
    if (self == object) {
        // 内存地址相等
        return YES;
    }
    
    OCMEnumModel *tempObject = (OCMEnumModel *)object;
    // oldName 相同即相同对象
    BOOL haveEqualOldName = (!self.oldName && !tempObject.oldName) || [self.oldName isEqualToString:tempObject.oldName];
    return haveEqualOldName;
}
@end
