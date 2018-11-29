//
//  Util.h
//  TulingGameDemo
//
//  Created by Nero on 14/11/2018.
//  Copyright © 2018 TulingGame. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PMTestType){
    PMTestType_Threeparty  = 0,    // 三方
    PMTestType_IAP         = 1,    // 内购
};


@interface Util : NSObject

//游戏参数初始化
+ (NSString *)gameInitializationValueJaosnString;

//游戏角色上报
+ (NSString *)gameRoleValueJaosnString;

//游戏预订单生成，传参
+ (NSString *)gamePMOrderValueJaosnStringWithType:(PMTestType)type productId:(NSString *)productId;

//IAP商品
+ (NSString *)productIDInIndex:(NSInteger)index;


@end

NS_ASSUME_NONNULL_END
