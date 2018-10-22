//
//  TulingGameSDKHelper.h
//  TulingGameSDK
//
//  Created by Nero on 9/10/2018.
//  Copyright © 2018 TulingGame. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*! @brief 角色上报类型
 *
 */
typedef NS_ENUM(NSInteger,TLGGameRoleEventType){
    TLGGameRoleEventType_EneterServer         = 0,        // 进入服务器
    TLGGameRoleEventType_CreateRole           = 1,        // 创建角色
    TLGGameRoleEventType_UpgradeRoleLevel     = 2         // 角色升级
};

//是否成功登出
typedef void(^TLGLogoutStatusBlock)(BOOL isSuccessLogout);

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

/*! @brief 处理通过URL启动App时传递的数据[微信、支付宝支付状态回调]
 *
 * 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
 * @param url 微信启动第三方应用时传递过来的URL
 * @return 成功返回YES，失败返回NO。
 */
+(BOOL)tlg_handleOpenURL:(NSURL *) url;


/*! @brief 游戏传参（5个组成组成参数，需要NSDictionary转成一条json string传给SDK）
 *  SDK数据初始化【必须调用，只需调用一次】
 * param gameID       【NSInteger-游戏ID】
 * param cid          【NSInteger渠道ID】
 * param aid          【NSInteger广告位ID】
 * param gameVersion  【NSString-游戏版本】
 * param gameKey      【NSString-给游戏分配的KEY】
 */
-(void)tlg_dataInitializationWithGameJson:(NSString *)gameJson;


/*! @brief 激活上报【成功进入游戏后调用】
 *
 */
-(void)tlg_reportGameActivate;

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

/*! @brief 屏幕旋转，同步更新悬浮按钮位置
 *
 */
-(void)updateDragBtnFrame;

@end

NS_ASSUME_NONNULL_END
