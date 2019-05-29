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
        eunmModels = [OCMixEnum regexFindClassName:eunmModels content:fileContent regext:eunmNameRegex];
        
        // eunm 内容
        NSArray *eunmContent = [OCMRegexUtil matchModelString:fileContent toRegexString:eunmContentRegex];
        for (NSString *content in eunmContent) {
            // eunm 字段名
            eunmModels = [OCMixEnum regexFindClassName:eunmModels content:content regext:eunmFieldRegex];
        }
    }
    
    // 生成随机名称
    eunmModels = [OCMRandomNameUtil randomModelArray:eunmModels];
    return eunmModels;
}

+ (NSMutableArray *)regexFindClassName:(NSMutableArray *)modelList content:(NSString *)content regext:(NSString *)regext {
    NSArray *regextContentNames = [OCMRegexUtil matchModelString:content toRegexString:regext];
    for (NSString *name in regextContentNames) {
        OCMEnumModel *model = [[OCMEnumModel alloc] init];
        model.oldName = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (![modelList containsObject:model]) {
            [modelList addObject:model];
        }
    }
    return modelList;
}

@end
