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

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // 修改前缀
        [OCModityPrefix modityPrefix];
        
        // 混淆方法名称
//        [OCMixMethodName mixMethodName];
        
        // 混淆属性名
//        [OCMixPropertyName mixPropertyName];
    }
    return 0;
}
