//
//  OCMPropertyModel.h
//  OCMixtool
//
//  Created by kwok on 2019/4/29.
//  Copyright © 2019年 Kowk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface OCMPropertyModel : NSObject

@property (copy, nonatomic) NSString *classFilePath;
@property (copy, nonatomic) NSString *propertyStatement;
@property (copy, nonatomic) NSString *propertyName;
@property (copy, nonatomic) NSString *propertyNewName;

@property (copy, nonatomic) NSString *setterPropertyMethodName;
@property (copy, nonatomic) NSString *getterPropertyMethodName;

- (NSString *)propertyNewStatement;
- (NSString *)privateRegex;
- (NSString *)pointRegex;
- (NSString *)setterPropertyMethodNameRegex;
- (NSString *)getterPropertyMethodNameRegex;

- (NSString *)customSetterPropertyMethodName;
- (NSString *)customGetterPropertyMethodName;
@end

NS_ASSUME_NONNULL_END
