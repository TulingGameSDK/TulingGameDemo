//
//  TulingGameSDKHelper.h
//  TulingGameSDK
//
//  Created by Nero on 9/10/2018.
//  Copyright © 2018 TulingGame. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! @brief 角色上报类型
 *
 */
typedef NS_ENUM(NSInteger,TLGGameRoleEventType){
    TLGGameRoleEventType_EneterServer         = 0,        // 进入服务器
    TLGGameRoleEventType_CreateRole           = 1,        // 创建角色
    TLGGameRoleEventType_UpgradeRoleLevel     = 2,         // 角色升级
    TLGGameRoleEventType_QuitServer           = 3         // 退出服务器
};


//对接游戏，登录的状态回调
typedef void(^TLGLoginStatusBlcok)(BOOL isSuccess,id errorMsg,NSString *sdkUserID, NSString *sdkToken);


//是否成功登出
typedef void(^TLGLogoutStatusBlock)(BOOL isSuccessLogout);

//事件上报
typedef void(^TLGRoleReportStatusBlcok)(BOOL isSuccess,id errorMsg,TLGGameRoleEventType evenType);

/*! @brief 请求游戏订单
 *
 * @param productID  IAP后台配置好的商品的ID，全网唯一
 * @param price      该productID对应的价钱（单位：分）V1.0.2新增
 */
typedef void(^TLGGameOrderParamRequestBlcok)(NSString *productID, NSString *price, NSString *sdkUserID);



/*! @brief 订单是否支付成功（三方+苹果内购）
 *
 * @param isSuccess 是否支付成功
 * @param errorMsg  错误信息，如果是成功，错误信息为nil
 * @param gameOrderID 支付成功，会附带游戏的订单号,失败返回nil
 */
typedef void(^TLGPMStatusBlock)(BOOL isSuccess,id errorMsg, NSString *gameOrderID);

@interface TulingGameSDKHelper : NSObject

/** 判断当前的初始化是否有效 **/
@property (nonatomic, assign,readonly) BOOL isInitializationValid;

/** 判断当前的登录状态 YES、NO**/
@property (nonatomic, assign,readonly) BOOL isLogin;

/** 当前登录用户的userId **/
@property (nonatomic, copy,readonly) NSString *sdkUserId;

/** 当前登录用户的token **/
@property (nonatomic, copy,readonly) NSString *sdkToken;


/*! @brief 单例
 *
 */
+ (instancetype)sharedInstance;

#pragma mark ************************* 登录部分 *************************

#pragma mark -- 登录
/** 登录初始化 **/
/*! @brief 游戏传参（5个组成组成参数，需要NSDictionary转成一条json string传给SDK）
 *  SDK数据初始化【必须调用，只需调用一次】
 * param gameID       【必传】【NSInteger-游戏ID】
 * param cid          【必传】【NSInteger渠道ID】
 * param aid          【必传】【NSInteger广告位ID】
 * param gameVersion  【必传】【NSString-游戏版本】
 * param gameKey      【必传】【NSString-给游戏分配的KEY】
 */
-(void)tlg_requestLoginWithGameInitJson:(NSString *)GameInitJson block:(TLGLoginStatusBlcok)block;

#pragma mark -- 操作上报【进入游戏区服、创建角色、角色升级、退出服务器】
/*! @brief 创建角色上报【创建角色成功后调用】
 *
 * param serverId;              //【必传】【NSString】区服id
 * param serverName;            //【必传】【NSString】区服名字
 * param roleId;                //【必传】【NSString】角色id
 * param roleName;              //【必传】【NSString】角色名
 * param roleLevel;             //【必传】【NSString】角色等级
 * param vipLevel;              //【必传】【NSString】VIP等级
 * param balance;               //【必传】【CGFloat】玩家游戏币总额， 如 100 金币
 * param partyName;             //【选传】【NSString】帮派，公会名称
 * param roleCreatedTime;       //【必传】【NSInteger】角色创建的时间戳，单位：秒
 * param roleLevelUpgradedTime; //【必传】【NSInteger】角色升级的时间戳，单位：秒
 */
-(void)tlg_reportGameRoleWithJsonString:(NSString *)jsonString eventType:(TLGGameRoleEventType)eventType block:(TLGRoleReportStatusBlcok)block;


#pragma mark -- 退出登录
/*! @brief 主动退出登录【游戏账号退出后调用】
 *
 */
-(void)tlg_reportGameLogoutWithBlock:(TLGLogoutStatusBlock)block;


#pragma mark ************************* 支付部分 *************************

#pragma mark -- 支*结果统一回调（三方+IAP）
/*! @brief 支付结果统一回调（三方+IAP）
 *
 */
-(void)tlg_PMCallBack:(TLGPMStatusBlock)block;


#pragma mark -- 【IAP】注册IAP状态监听
/*! @brief 注册全局的IAP操作监听(含丢单处理逻辑)
 *
 */
-(void)tlg_registerIAPNoti;


#pragma mark -- 发起支付（三方+IAP）
/** 【必传】游戏支付相关参数 **/
/*   生成订单接口【请注意上传的字段格式】
 *
 * param gameVersion;           //【必传】【NSString】游戏当前的版本号
 * param amount;                //【必传】【NSInteger】充值金额，单位：分,必传
 * param orderId;               //【必传】【NSString】研发传入的订单号，必传
 * param roleId;                //【必传】【NSString】玩家角色id，必传
 * param roleName;              //【必传】【NSString】玩家角色名，必传
 * param roleLevel;             //【必传】【NSString】角色等级，必传
 * param serverId;              //【必传】【NSString】区服id，必传
 * param serverName;            //【必传】【NSString】区服名字，必传
 * param productId;             //【必传】【NSString】商品ID，必传
 * param productName;           //【必传】【NSString】商品名，商品名称前请不要添加任何量词。如钻石，月卡即可。必传
 * param payInfo;               //【必传】【NSString】商品描述信息，必传
 * param productCount;          //【必传】【NSString】购买的商品数量，必传
 * param notifyUrl;             //【必传】【NSString】支付结果回调地址，必传
 * param extraData;             //【NSString】透传参数，字符串，可选
 */
/*! @brief 支付操作三方+IAP统一入口(SDK根据游戏的版本号，出不同的支付操作)
 *
 * param gameValueJson;          //订单信息
 */
-(void)tlg_requestPMWithGameValueJson:(NSString *)gameValueJson;


#pragma mark -- APP支付[微*、支**支付状态接收]
/*! @brief 处理通过URL启动App时传递的数据[微*、支**支付状态回调]
 *
 * 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
 * @param url 微*启动第三方应用时传递过来的URL
 * @return 成功返回YES，失败返回NO。
 */
-(BOOL)tlg_handleOpenURL:(NSURL *) url;





@end

