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
    TLGGameRoleEventType_UpgradeRoleLevel     = 2         // 角色升级
};

/*! @brief 支付方式
 *
 */
typedef NS_ENUM(NSInteger,TLGPaymentModeType){
    TLGPaymentModeType_AppleIAP         = 0,       // 苹果内购
    TLGPaymentModeType_Threeparty       = 1       //  第三方
};


//对接游戏，登录的状态回调
typedef void(^TLGLoginStatusBlcok)(BOOL isSuccess,id errorMsg,NSString *userId, NSString *token);


//是否成功登出
typedef void(^TLGLogoutStatusBlock)(BOOL isSuccessLogout);

/*! @brief 订单是否支付成功（三方+苹果内购）
 *
 * @param isSuccess 是否支付成功
 * @param errorMsg  错误信息，如果是成功，错误信息为nil
 * @param gameOrderID 支付成功，会附带游戏的订单号,失败返回nil
 */
typedef void(^TLGPaymentStatusBlock)(BOOL isSuccess,id errorMsg, NSString *gameOrderID);


//支付方式
typedef void(^TLGPaymentModeTypeBlock)(TLGPaymentModeType type);


@interface TulingGameSDKHelper : NSObject

/** 判断当前的初始化是否有效 **/
@property (nonatomic, assign) BOOL isInitializationValid;

/** 判断当前的登录状态 YES、NO**/
@property (nonatomic, assign) BOOL isLogin;

/** 当前登录用户的userId **/
@property (nonatomic, copy) NSString *userId;

/** 当前登录用户的token **/
@property (nonatomic, copy) NSString *token;


@property (nonatomic, copy) TLGLogoutStatusBlock tlg_logoutStatusBlock;


/*! @brief 单例
 *
 */
+ (instancetype)sharedInstance;


/** 登录初始化 **/
/*! @brief 游戏传参（5个组成组成参数，需要NSDictionary转成一条json string传给SDK）
 *  SDK数据初始化【必须调用，只需调用一次】
 * param gameID       【NSInteger-游戏ID】
 * param cid          【NSInteger渠道ID】
 * param aid          【NSInteger广告位ID】
 * param gameVersion  【NSString-游戏版本】
 * param gameKey      【NSString-给游戏分配的KEY】
 */
-(void)tlg_requestLoginWithGameInitJson:(NSString *)GameInitJson block:(TLGLoginStatusBlcok)block;



/*! @brief 创建角色上报【创建角色成功后调用】
 *
 * param serverId;              //【NSString】区服id
 * param serverName;            //【NSString】区服名字
 * param roleId;                //【NSString】角色id
 * param roleName;              //【NSString】角色名
 * param roleLevel;             //【NSString】角色等级
 * param vipLevel;              //【NSString】VIP等级
 * param balance;               //【CGFloat】玩家游戏币总额， 如 100 金币
 * param partyName;             //【NSString】帮派，公会名称。 若无，填 unknown
 * param roleCreatedTime;       //【NSInteger】角色创建的时间戳，单位：秒
 * param roleLevelUpgradedTime; //【NSInteger】角色升级的时间戳，单位：秒
 */
-(void)tlg_reportGameRoleWithJsonString:(NSString *)jsonString eventType:(TLGGameRoleEventType)eventType;

/*! @brief 主动退出登录【游戏账号退出后调用】
 *
 */
-(void)tlg_reportGameLogoutWithBlock:(TLGLogoutStatusBlock)block;

/** 【必传】游戏支付相关参数 **/
/*   生成订单接口【请注意上传的字段格式】
 *
 * param gameVersion;           //【NSString】游戏当前的版本号
 * param amount;                //【NSInteger】充值金额，单位：分,必传
 * param orderId;               //【NSString】研发传入的订单号，必传
 * param roleId;                //【NSString】玩家角色id，必传
 * param roleName;              //【NSString】玩家角色名，必传
 * param roleLevel;             //【NSString】角色等级，必传
 * param serverId;              //【NSString】区服id，必传
 * param serverName;            //【NSString】区服名字，必传
 * param productId;             //【NSString】商品ID，必传
 * param productName;           //【NSString】商品名，商品名称前请不要添加任何量词。如钻石，月卡即可。必传
 * param payInfo;               //【NSString】商品描述信息，必传
 * param productCount;          //【NSString】购买的商品数量，必传
 * param notifyUrl;             //【NSString】支付结果回调地址，必传
 * param extraData;             //【NSString】透传参数，字符串，可选
 */
/*! @brief 支付操作(SDK根据游戏的版本号，出不同的支付操作)
 *
 * param gameVersion;          //游戏客户端版本
 * param block;               //返回成功或者失败
 */
-(void)tlg_requestPaymentWithGameValueJson:(NSString *)gameValueJson block:(TLGPaymentStatusBlock)block;

/*! @brief 处理通过URL启动App时传递的数据[微信、支付宝支付状态回调]
 *
 * 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
 * @param url 微信启动第三方应用时传递过来的URL
 * @return 成功返回YES，失败返回NO。
 */
-(BOOL)tlg_handleOpenURL:(NSURL *) url;

/*! @brief 处理内购丢单问题，SDK每次进入界面，会查询本地近路的内购凭证，验证后，清空本地记录的全部内购凭证
 *
 */
-(void)tlg_handleIAPUnfinishOrderWithBlock:(TLGPaymentStatusBlock)block;




@end

