//
//  OCModityFileContent.m
//  OCMixtool
//
//  Created by guominfang on 2019/5/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import "OCModityFileContent.h"
#import "OCMRegexUtil.h"

@implementation OCModityFileContent

- (void)mixFileContent:(NSArray *)fileList model:(NSArray<id<OCModityFileContentProtocol>> *)modelArray {
    // 开始混淆,修改文件中的内容
    for (NSString *classPath in fileList) {
        NSString *fileContent = [NSString stringWithContentsOfFile:classPath encoding:NSUTF8StringEncoding error:nil];
        for (id<OCModityFileContentProtocol> model in modelArray) {
            if (![model enabledModityFileContent:self]) {
                continue;
            }
            
            NSString *oldRegex = [NSString stringWithFormat:@"\\W%@\\W", [model oldNameToModityFileContent:self]];
            NSArray *regexArray = [OCMRegexUtil matchString:fileContent toRegexString:oldRegex];
            for (NSString *regexContent in regexArray) {
                NSString *newRegexContent = [regexContent stringByReplacingOccurrencesOfString:[model oldNameToModityFileContent:self] withString:[model newNameToModityFileContent:self]];
                fileContent = [fileContent stringByReplacingOccurrencesOfString:regexContent withString:newRegexContent];
            }
        }
        [fileContent writeToFile:classPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

@end
