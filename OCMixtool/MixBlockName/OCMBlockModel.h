//
//  OCMBlockModel.h
//  OCMixtool
//
//  Created by guominfang on 2019/5/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCMRandomNameUtil.h"
#import "OCModityFileContent.h"

NS_ASSUME_NONNULL_BEGIN

@interface OCMBlockModel : NSObject <OCMRandomNameProtocol,OCModityFileContentProtocol>

@property (copy, nonatomic) NSString *oldBlockName;
@property (copy, nonatomic) NSString *randomBlockName;

@end

NS_ASSUME_NONNULL_END
