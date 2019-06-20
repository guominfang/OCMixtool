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

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // 修改前缀
//        [OCModityPrefix modityPrefix];
        // 完全混淆类名 【如果开启完全混淆类名，必须排在修改前缀后面】 【只会修改含有 kNewPrefix 的类名】
        [OCMixClassName mixClassName];
        // 混淆方法名称
//        [OCMixMethodName mixMethodName];
        // 混淆属性名
//        [OCMixPropertyName mixPropertyName];
    }
    return 0;
}
