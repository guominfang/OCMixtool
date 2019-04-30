//
//  main.m
//  OCMixtool
//
//  Created by kwok on 2019/4/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCMixPropertyName.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // 混淆属性名
        [OCMixPropertyName mixPropertyName];
    }
    return 0;
}
