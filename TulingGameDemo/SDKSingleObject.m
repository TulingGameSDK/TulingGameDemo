//
//  SDKSingleObject.m
//  TulingGameDemo
//
//  Created by Nero on 29/11/2018.
//  Copyright © 2018 TulingGame. All rights reserved.
//

#import "SDKSingleObject.h"


@implementation SDKSingleObject

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[[self class] alloc] init];
    });
    return _sharedInstance;
}

-(void)sdkInitialization{
    
    //登出状态注册监听
    [self setupLogoutNoti];
    
    //IAP监听注册 && 支付结果回调
    [self setupPMCorrelationAction];

}

//type (0:登出状态 1：登录状态)
-(void)postLoginStatusWithLoginStatus:(BOOL)isLogined{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TLG_Game_UpdateLoginUI" object:@{@"isLogined":@(isLogined)}];
}

#pragma mark ************************* 以下为游戏CP需要接入代码部分 *************************

#pragma mark -- 登出状态回调
//注册登出监听
- (void)setupLogoutNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutNotification:) name:@"TLG_Notification_Logout" object:nil];
}

-(void)logoutNotification:(NSNotification *)notification{
    /*
     * 主要返回登出的回调【主动&被动】，针对一些被动登出情况，做处理
     * YES:主动登出
     * NO:被动登出
     */
    id notiBody = notification.object;
    
    BOOL isActiveLogout = [[notiBody objectForKey:@"activeLogout"] boolValue];
    BOOL isSuccessLogout = [[notiBody objectForKey:@"result"] boolValue];
    
    if (isSuccessLogout) {
        if (isActiveLogout) {
            //主动登出【block回调&本地通知回调，监听处理其中之一即可】
            NSLog(@"TulingGameDemo-本地通知方式-主动登出成功");
            
        }else{
            //被动登出
            NSLog(@"TulingGameDemo-本地通知方式-被动登出成功");
        }
        
        //登出之后，要强制回到SDK的登录页面(此处做调用举例展示，实际接入游戏,按需调整)
        [self postLoginStatusWithLoginStatus:!isSuccessLogout];
        
        //显示登录框(此处做调用举例展示，实际接入游戏,按需调整)
//        [[SDKSingleObject sharedInstance] sdkLoginView];

    }else{
        NSLog(@"SDK服务器，退出登录API失败");
    }
    
}


#pragma mark -- 登录
-(void)sdkLoginView{
    
    [[TulingGameSDKHelper sharedInstance] tlg_requestLoginWithGameInitJson:[Util gameInitializationValueJaosnString] block:^(BOOL isSuccess, id errorMsg, NSString *sdkUserID, NSString *sdkToken) {
        
        NSLog(@"\n\n【图灵SDK登录，统一回调结果：】\n\nisSuccess:%d\nerrorMsg:%@\nuserId:%@\ntoken:%@\n\n",isSuccess,errorMsg,sdkUserID,sdkToken);
        
        if (isSuccess) {
            
            NSLog(@"\n\n\n\nTulingGameDemo-Block回调-登录成功");
            NSLog(@"\n\n登录成功-Block回调数据\nuserId：%@\ntoken:%@",sdkUserID,sdkToken);
            
            //单例读取SDK本地的userid、token方法（此处做调用举例展示，实际接入游戏，按需调整）
            if ([TulingGameSDKHelper sharedInstance].isLogin) {
                NSLog(@"\n\n登录成功-SDK本地存储数据读取方法\nuserId：%@\ntoken:%@",[TulingGameSDKHelper sharedInstance].userId,[TulingGameSDKHelper sharedInstance].token);
            }
            
            //更新UI显示（此处做调用举例展示，实际接入游戏，游戏代码自己控制界面更新）
            [self postLoginStatusWithLoginStatus:isSuccess];
            
            //角色上传（此处做调用举例展示，实际接入游戏，请按相关位置调用处理）
            [self sdkRoleReportType:TLGGameRoleEventType_EneterServer];
            
        }else{
            
        }
    }];
}

#pragma mark -- 角色上报（创建角色、角色升级、进入服务器、退出服务器）
-(void)sdkRoleReportType:(TLGGameRoleEventType)type{
    //本地测试，延时操作
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //【进入服务器、创建角色、角色升级、退出服务器】3种情况，需要调用上报API
        /*! @brief 上报类型
         typedef NS_ENUM(NSInteger,TLGGameRoleEventType){
         TLGGameRoleEventType_EneterServer         = 0,        // 进入服务器
         TLGGameRoleEventType_CreateRole           = 1,        // 创建角色
         TLGGameRoleEventType_UpgradeRoleLevel     = 2,         // 角色升级
         TLGGameRoleEventType_QuitServer           = 3         // 退出服务器
         };
         */
        
        [[TulingGameSDKHelper sharedInstance] tlg_reportGameRoleWithJsonString:[Util gameRoleValueJaosnString] eventType:TLGGameRoleEventType_EneterServer block:^(BOOL isSuccess, id errorMsg) {
            NSLog(@"\n\n【图灵SDK角色上传，统一回调结果：】\n\nisSuccess:%d\nerrorMsg:%@\n\n",isSuccess,errorMsg);
            
            if (type == TLGGameRoleEventType_EneterServer) {
                //进入服务器之后，才调用补单操作（此处做调用举例展示，实际接入游戏，请按相关位置调用处理）
                [[TulingGameSDKHelper sharedInstance] tlg_requestIAPOrderSupportCheckAfterEnterGameServer];
            }
            
        }];
        
    });
}

#pragma mark -- 登出（主动登出）
-(void)sdkLogout{
    //主动登出
    //登出状态的回调，全部在【-(void)logoutNotification:(NSNotification *)notification】，登出结果，本地通知监听
    [[TulingGameSDKHelper sharedInstance] tlg_reportGameLogoutWithBlock:nil];
    
}

#pragma mark -- 支付（三方+IAP）
-(void)sdkPMViewWithType:(PMTestType)type productId:(NSString *)productId{
    
    //SDK本身会根据游戏的版本号，做后台开关，控制支付方式
    //此处type只为方便展示&测试内容，（SDKDemo本身app version设置了0.0.1是走三方，如果设置了1.0.0就走内购）

    //游戏需要组装参数，向SDK传支付相关的参数
    NSString *gameValueJson = [Util gamePMOrderValueJaosnStringWithType:type productId:productId];
    
    [[TulingGameSDKHelper sharedInstance] tlg_requestPMWithGameValueJson:gameValueJson];
    
}


#pragma mark -- IAP注册监听 & 支付结果回调
- (void)setupPMCorrelationAction{
    //【图灵SDK】注册全局的IAP操作监听(含丢单处理逻辑)
    [[TulingGameSDKHelper sharedInstance] tlg_registerIAPNotiWithBlock:^(NSString *productID, NSString *price, NSString *sdkUserID) {
        
        //游戏重新向SDK传支付订单参数
        //SDK内部有判断当前登录的账户信息，内购凭证全部是跟SDK的userID挂钩并且本地h持久化存储（放丢单）
        //IAP防丢当操作方案:IAP先完成支付操作，支付成功之后（还没进行内购凭证的有效性验证），才向游戏请求gameOrderID，绑定订单号
        //苹果内购IAP：游戏根据SDK传过来的productID,price，重新组装当前时间点的订单相关参数，传给SDK
        NSString *gameOrderJson = [Util gamePMOrderValueJaosnStringWithType:PMTestType_IAP productId:productID];
        
        //SDK开始绑定订单号，并且验证【内购凭证】
        [[TulingGameSDKHelper sharedInstance] tlg_requestIAPWithGameOrderJson:gameOrderJson];
        
    }];
    
    //支付结果回调（IAP+三方）
    [[TulingGameSDKHelper sharedInstance] tlg_PMCallBack:^(BOOL isSuccess, id errorMsg, NSString *gameOrderID) {
        //支付结果(苹果内购-丢单部分重新下单)
        NSLog(@"\n\n【图灵SDK支付，统一回调结果：】\nisSuccess:%d\nerrorMsg:%@\ngameOrderID:%@\n\n",isSuccess,errorMsg,gameOrderID);
    }];
    
}

#pragma mark -- 三方支付APP响应方法
-(BOOL)sdkHandleOpenURL:(NSURL *) url{
    return [[TulingGameSDKHelper sharedInstance] tlg_handleOpenURL:url];
}

@end
