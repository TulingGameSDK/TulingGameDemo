//
//  Util.m
//  TulingGameDemo
//
//  Created by Nero on 14/11/2018.
//  Copyright © 2018 TulingGame. All rights reserved.
//

#import "Util.h"

@implementation Util

#pragma mark -- 游戏参数初始化
+ (NSString *)gameInitializationValueJaosnString{
    
    /*! @brief 游戏传参（5个组成组成参数，需要NSDictionary转成一条json string传给SDK）
     *
     * param gameID       【NSInteger-游戏ID】
     * param cid          【NSInteger渠道ID】
     * param aid          【NSInteger广告位ID】
     * param gameVersion  【NSString-游戏版本（当前xcode里面info.plist设置的版本号）】
     * param gameKey      【NSString-给游戏分配的KEY】
     */
    
    NSString *gameVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @(25),@"gameID",
                         @(3),@"cid",
                         @(3),@"aid",
                         gameVersion,@"gameVersion",
                         @"rdzog9rOvNwMKFP2B9uJqBhaYRhpKFkx",@"gameKey",
                         nil];


    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
    
}


#pragma mark -- 游戏角色上报
+ (NSString *)gameRoleValueJaosnString{
    
    /*! @brief 创建角色上报【创建角色成功后调用】
     *
     * param serverId;              //【NSString】区服id
     * param serverName;            //【NSString】区服名字
     * param roleId;                //【NSString】角色id
     * param roleName;              //【NSString】角色名
     * param roleLevel;             //【NSInteger】角色等级
     * param vipLevel;              //【NSInteger】VIP等级
     * param balance;               //【CGFloat】玩家游戏币总额， 如 100 金币
     * param partyName;             //【NSString】帮派，公会名称。 若无，填 unknown
     * param roleCreatedTime;       //【NSInteger】角色创建的时间戳，单位：秒
     * param roleLevelUpgradedTime; //【NSInteger】角色升级的时间戳，单位：秒
     */
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"3",@"serverId",
                         @"魔兽世界-中国服",@"serverName",
                         @"3456",@"roleId",
                         @"玩家角色名",@"roleName",
                         @"10",@"roleLevel",
                         @"3",@"vipLevel",
                         @(10000),@"balance",
                         @"unknown",@"partyName",
                         @(1539571500),@"roleCreatedTime",
                         @(1539572950),@"roleLevelUpgradedTime",
                         nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
    
}

#pragma mark -- 事件上报【进入服务器、创建角色、角色升级、退出服务器】
+ (NSString *)reportActionInIndex:(NSInteger)index{
    NSArray *array = [[NSArray alloc] initWithObjects:
                      @"进入游戏区服（开启IAP）",
                      @"创建角色",
                      @"角色升级",
                      @"退出游戏区服（退出IAP）",nil];
    
    if (index < array.count) {
        return array[index];
    }else{
        return array[0];
    }
}



#pragma mark -- 商品ID列表（游戏需要根据自身的匹配相关的信息，开发者账号里面的【税务】方面的填写好，才能正常调用IAP方法），需要同步修改【amountWithProductID】方法
static NSString * const ReplacingStr = @"com.tuling.demo.pay"; //demo模拟数据，测试使用，用来判断当前商品【单价】
+ (NSString *)productIDInIndex:(NSInteger)index{
    NSArray *array = [[NSArray alloc] initWithObjects:
                      @"com.tuling.demo.pay6",
                      @"com.tuling.demo.pay12",
                      @"com.tuling.demo.pay18",
                      @"com.tuling.demo.pay25",nil];
    
    if (index < array.count) {
        return array[index];
    }else{
        return array[0];
    }
}



#pragma mark -- 游戏预订单生成，传参
+ (NSString *)gamePMOrderValueJaosnStringWithType:(PMTestType)type productId:(NSString *)productId{
    
    /*! @brief 生成订单接口【请注意上传的字段格式】
     *
     * param gameVersion;           //【NSString】游戏当前的版本号（SDK会根据版本号，做开关控制）
     * param amount;                //【NSInteger】充值金额，单位：分,必传
     * param orderId;               //【NSString】研发传入的订单号，必传
     * param roleId;                //【NSString】玩家角色id，必传
     * param roleName;              //【NSString】玩家角色名，必传
     * param roleLevel;             //【NSString】角色等级，必传
     * param serverId;              //【NSString】区服id，必传
     * param serverName;            //【NSString】区服名字，必传
     * param productId;             //【NSString】商品ID，必传,bundleID对应的苹果内购的商品ID，例如：com.TulingGame.SDKDemo.pay6
     * param productName;           //【NSString】商品名，商品名称前请不要添加任何量词。如钻石，月卡即可。必传
     * param payInfo;               //【NSString】商品描述信息，必传
     * param productCount;          //【NSString】购买的商品数量，必传
     * param notifyUrl;             //【NSString】支付结果回调地址，必传
     * param extraData;             //【NSString】透传参数，字符串，可选
     */
    
    
    //（SDK会根据版本号，做开关控制）
    //此处只是为了方便展示功能&测试，所以做了type操作判断，实际出包，请直接用【[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]】设置游戏版本号
    NSString *gameVersion = @"";
    NSInteger amount;
    NSString *orderId = @"";
    
    if (type == PMTestType_Threeparty) {
        gameVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]; //测试：demo的1.0.0是设置了走三方支付
        amount = 1; //0.01元（单位：分）
        
    }else{
        gameVersion = @"2.0.0"; //测试：demo的2.0.0是设置了走IAP支付
        NSString *price = [self amountWithProductID:productId];
        amount = price.intValue * 100; //单位：分
    }
    
    //模拟订单号
    {
        NSString *dateStr = [NSString stringWithFormat:@"%@",[self dateStringWithTimeStamp:[self timeStampOfDate:[NSDate date]] formatString:@"yyyy-MM-dd HH:mm:ss"]];
        orderId = [NSString stringWithFormat:@"%ld|%@",(long)[[self amountWithProductID:productId] integerValue],dateStr];

    }

    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         gameVersion,@"gameVersion",
                         @(amount),@"amount",
                         orderId,@"orderId",
                         @"3456",@"roleId",
                         @"玩家角色名",@"roleName",
                         @"10",@"roleLevel",
                         @"3",@"serverId",
                         @"魔兽世界-中国服",@"serverName",
                         productId,@"productId",
                         @"游戏钻石",@"productName",
                         @"充值100金币-10元",@"payInfo",
                         @"1",@"productCount",
                         @"https://u.tulinggame.com",@"notifyUrl",
                         @"这是一条测试订单",@"extraData",
                         nil];

    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
    
}

+(NSString *)amountWithProductID:(NSString *)productId{
    
    NSString *price = [productId stringByReplacingOccurrencesOfString:ReplacingStr withString:@""];
    
    return price;
}

+ (NSInteger)timeStampOfDate:(NSDate *)date{
    
    NSTimeInterval interval = [date timeIntervalSince1970]; //iOS原生得到秒级时间戳
    NSInteger time;
    time = (long)interval;
    time = (long)interval*1;
    return time;
}
//时间戳转换为时间方法
+ (NSString *)dateStringWithTimeStamp:(NSInteger)timeStamp formatString:(NSString *)formatString{
    NSDate *tmpDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:formatString];
    NSString *dateString = [format stringFromDate:tmpDate];
    return dateString;
}


@end
