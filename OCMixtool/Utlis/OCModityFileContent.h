//
//  OCModityFileContent.h
//  OCMixtool
//
//  Created by guominfang on 2019/5/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OCModityFileContent;

NS_ASSUME_NONNULL_BEGIN
@protocol OCModityFileContentProtocol <NSObject>

@required
- (NSString *)oldNameToModityFileContent:(OCModityFileContent *)OCModityFileContent;
- (NSString *)newNameToModityFileContent:(OCModityFileContent *)OCModityFileContent;
- (BOOL)enabledModityFileContent:(nullable OCModityFileContent *)OCModityFileContent;
@end

@interface OCModityFileContent : NSObject

- (void)mixFileContent:(NSArray *)fileList model:(NSArray<id<OCModityFileContentProtocol>> *)modelArray;

@end

NS_ASSUME_NONNULL_END
