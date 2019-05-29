//
//  OCMixEnum.m
//  OCMixtool
//
//  Created by guominfang on 2019/5/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import "OCMixEnum.h"
#import "OCMFileUtil.h"
#import "OCMEnumModel.h"
#import "OCMRandomNameUtil.h"
#import "OCMRegexUtil.h"

@implementation OCMixEnum

+ (void)mixEnum {
    NSArray *fileArray = [OCMFileUtil findAllClassFileFromDirectory:kProjectDirPath];
    NSMutableArray *modelArray = [OCMixEnum enumModelArray:fileArray];
    [[[OCModityFileContent alloc] init] mixFileContent:fileArray model:modelArray];
}

+ (NSMutableArray *)enumModelArray:(NSArray *)fileArray {
    // 构建 OCMEnumModel 对象列表
    NSMutableArray *eunmModels = [NSMutableArray array];
    for (NSString *classPath in fileArray) {
        NSString *fileContent = [NSString stringWithContentsOfFile:classPath encoding:NSUTF8StringEncoding error:nil];
        
        // eunm 名称
        NSArray *eunmNames = [OCMRegexUtil matchModelString:fileContent toRegexString:eunmNameRegex];
        for (NSString *name in eunmNames) {
            OCMEnumModel *model = [[OCMEnumModel alloc] init];
            model.oldName = name;
            if ([eunmModels containsObject:model]) {
                continue;
            }
            [eunmModels addObject:model];
        }
        
        // eunm 字段名
        NSArray *eunmContent = [OCMRegexUtil matchModelString:fileContent toRegexString:eunmContentRegex];
        for (NSString *content in eunmContent) {
            NSArray *eunmField = [OCMRegexUtil matchString:content toRegexString:eunmFieldRegex];
            for (NSString *fieldName in eunmField) {
                OCMEnumModel *model = [[OCMEnumModel alloc] init];
                model.oldName = [fieldName stringByReplacingOccurrencesOfString:@" " withString:@""];
                if ([eunmModels containsObject:model]) {
                    continue;
                }
                [eunmModels addObject:model];
            }
        }
    }
    
    // 生成随机名称
    eunmModels = [OCMRandomNameUtil randomModelArray:eunmModels];
    return eunmModels;
}

@end
