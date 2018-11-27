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
     * param gameVersion  【NSString-游戏版本】
     * param gameKey      【NSString-给游戏分配的KEY】
     */
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @(23),@"gameID",
                         @(3),@"cid",
                         @(3),@"aid",
                         @"1.0",@"gameVersion",
                         @"Ggg18dKOam7Wj6IoMMNdgDE0UmMejKg7",@"gameKey",
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
                         @"图灵公会",@"partyName",
                         @(1539571500),@"roleCreatedTime",
                         @(1539572950),@"roleLevelUpgradedTime",
                         nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
    
}


#pragma mark -- 游戏预订单生成，传参
+ (NSString *)gamePaymentOrderValueJaosnStringWithType:(PaymentTestType)type{
    
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
    NSString *appVersion = @"";
    NSInteger amount;
    
    if (type == PaymentTestType_Threeparty) {
        appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        amount = 1;
        
    }else{
        appVersion = @"2.0.0";
        amount = 600;
    }
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         appVersion,@"gameVersion",
                         @(amount),@"amount",
                         @"2018101034t445675767",@"orderId",
                         @"3456",@"roleId",
                         @"玩家角色名",@"roleName",
                         @"10",@"roleLevel",
                         @"3",@"serverId",
                         @"魔兽世界-中国服",@"serverName",
                         [self productIDWithIndex:0],@"productId",
                         @"游戏钻石",@"productName",
                         @"充值100金币-10元",@"payInfo",
                         @"1",@"productCount",
                         @"https://www.baidu.com",@"notifyUrl",
                         @"这是一条测试订单",@"extraData",
                         nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
    
}

+(NSString *)productIDWithIndex:(NSInteger)index{
    NSArray *productArr= [[NSArray alloc] initWithObjects:
                          @"com.TulingGame.SDKDemo.pay6",
                          @"com.TulingGame.SDKDemo.pay18",
                          @"com.TulingGame.SDKDemo.pay25",
                          @"com.TulingGame.SDKDemo.pay40",
                          @"com.TulingGame.SDKDemo.pay50",
                          @"com.TulingGame.SDKDemo.pay88", nil];
    
    if (index < productArr.count) {
        return productArr[index];
    }else{
        return @"com.TulingGame.SDKDemo.pay6"; //默认值
    }
}


@end
