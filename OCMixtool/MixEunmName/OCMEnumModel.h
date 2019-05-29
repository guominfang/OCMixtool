//
//  OCMEnumModel.h
//  OCMixtool
//
//  Created by guominfang on 2019/5/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCMRandomNameUtil.h"
#import "OCModityFileContent.h"
NS_ASSUME_NONNULL_BEGIN

@interface OCMEnumModel : NSObject <OCMRandomNameProtocol,OCModityFileContentProtocol>

@property (copy, nonatomic) NSString *oldName;
@property (copy, nonatomic) NSString *randomName;

@end

NS_ASSUME_NONNULL_END
