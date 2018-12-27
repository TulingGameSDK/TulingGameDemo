//
//  TulingGameSDK.h
//  TulingGameSDK
//
//  Created by Nero on 10/10/2018.
//  Copyright © 2018 TulingGame. All rights reserved.
//

#import <UIKit/UIKit.h>



/*
 ************************************************************
 
 #当前SDK版本：V1.0.3
 
 
 #版本更新记录
 V1.0.3
 SDK内购逻辑优化
 
 V1.0.2
 原生嵌套H5页面，操作全部在H5完成

 V1.0.1
 1.苹果内购IAP添加防丢单措施

 
 V1.0.0
 1.登录、支付（三方+IAP）、用户中心基本功能
 
 
 ************************************************************
*/






//! Project version number for TulingGameSDK.
FOUNDATION_EXPORT double TulingGameSDKVersionNumber;

//! Project version string for TulingGameSDK.
FOUNDATION_EXPORT const unsigned char TulingGameSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <TulingGameSDK/PublicHeader.h>


#if __has_include(<TulingGameSDK/TulingGameSDK.h>)


/*! @brief 游戏状态回调
 *
 */
#import <TulingGameSDK/TulingGameSDKHelper.h>


#else


/*! @brief 游戏状态回调
 *
 */
#import "TulingGameSDKHelper.h"


#endif




