//
//  OCMixBlockName.m
//  OCMixtool
//
//  Created by guominfang on 2019/5/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import "OCMixBlockName.h"
#import "OCMFileUtil.h"
#import "OCMBlockModel.h"
#import "OCMRegexUtil.h"

@implementation OCMixBlockName

+ (void)mixBlockName {
    NSArray *fileArray = [OCMFileUtil findAllClassFileFromDirectory:kProjectDirPath];
    NSMutableArray *blockArray = [OCMixBlockName blockModelArray:fileArray];
    [[[OCModityFileContent alloc] init] mixFileContent:fileArray model:blockArray];
}

+ (NSMutableArray *)blockModelArray:(NSArray *)fileArray {
    // 构建 OCMBlockModel 对象列表
    NSMutableArray *blockModels = [NSMutableArray array];
    for (NSString *classPath in fileArray) {
        NSString *fileContent = [NSString stringWithContentsOfFile:classPath encoding:NSUTF8StringEncoding error:nil];
        // 局部变量 方式定义的Block
        blockModels = [OCMixBlockName regexFindClassName:blockModels content:fileContent regext:blockLocalRegex];
        // 属性 方式定义的Block
        blockModels = [OCMixBlockName regexFindClassName:blockModels content:fileContent regext:blockPropertyRegex];
        // Typedef 方式定义的Block
        blockModels = [OCMixBlockName regexFindClassName:blockModels content:fileContent regext:blockTypedefRegex];
    }
    // 生成随机名称
    blockModels = [OCMRandomNameUtil randomModelArray:blockModels];
    return blockModels;
}

+ (NSMutableArray *)regexFindClassName:(NSMutableArray *)modelList content:(NSString *)content regext:(NSString *)regext {
    NSArray *regextContentNames = [OCMRegexUtil matchModelString:content toRegexString:regext];
    for (NSString *name in regextContentNames) {
        OCMBlockModel *model = [[OCMBlockModel alloc] init];
        model.oldBlockName = name;
        if (![modelList containsObject:model]) {
            [modelList addObject:model];
        }
    }
    return modelList;
}



@end
