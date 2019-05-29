//
//  main.m
//  OCMixtool
//
//  Created by kwok on 2019/4/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCMixPropertyName.h"
#import "OCMixMethodName.h"
#import "OCModityPrefix.h"
#import "OCMixClassName.h"
#import "OCMixEnum.h"
#import "OCMixBlockName.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // 修改前缀
        [OCModityPrefix modityPrefix];
        // 修改类名 【如果开启修改类名，必须排在修改前缀后面】 【只会修改含有 kNewPrefix 的类名】
        [OCMixClassName mixClassName];
        // 混淆 ENUM
        [OCMixEnum mixEnum];
        // 混淆 BlockName
        [OCMixBlockName mixBlockName];
        // 混淆方法名称
//        [OCMixMethodName mixMethodName];
        // 混淆属性名
//        [OCMixPropertyName mixPropertyName];
    }
    return 0;
}
