//
//  SDKSingleObject.h
//  TulingGameDemo
//
//  Created by Nero on 29/11/2018.
//  Copyright © 2018 TulingGame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Util.h" //本地测试的工具集合(测试用途，游戏按实际需要修改)

#import <TulingGameSDK/TulingGameSDK.h>

/*
 ************************************************************
 
 #本类为TulingGameSDK的使用调用方法的单例，游戏接入可以做下参考（按需调整）
 
 ************************************************************
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDKSingleObject : NSObject

//单例
+ (instancetype)sharedInstance;

//初始化
-(void)sdkInitialization;

//三方PM回调响应
-(BOOL)sdkHandleOpenURL:(NSURL *) url;

//调起登录
-(void)sdkLoginView;

//登出
-(void)sdkLogout;

//【创建角色、角色升级、进入服务器、退出服务器】4种情况，需要调用上报API
-(void)sdkRoleReportType:(TLGGameRoleEventType)type;

//统一支付（三方+IAP）
-(void)sdkPMViewWithType:(PMTestType)type productId:(NSString *)productId;


@end

NS_ASSUME_NONNULL_END
