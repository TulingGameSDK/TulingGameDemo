//
//  TulingGameSDK.h
//  TulingGameSDK
//
//  Created by Nero on 29/9/2018.
//  Copyright © 2018 TulingGame. All rights reserved.
//

#import <UIKit/UIKit.h>

//test:version - 1.0.0.1

//! Project version number for TulingGameSDK.
FOUNDATION_EXPORT double TulingGameSDKVersionNumber;

//! Project version string for TulingGameSDK.
FOUNDATION_EXPORT const unsigned char TulingGameSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <TulingGameSDK/PublicHeader.h>


#if __has_include(<TulingGameSDK/TulingGameSDK.h>)

/*! @brief 登录部分
 *
 */
#import <TulingGameSDK/TLGLoginVC.h>

/*! @brief 支付部分
 *
 */
#import <TulingGameSDK/TLGPaymentVC.h>


/*! @brief 游戏状态回调
 *
 */
#import <TulingGameSDK/TulingGameSDKHelper.h>


#else

/*! @brief 登录部分
 *
 */
#import "TLGLoginVC.h"

/*! @brief 支付部分
 *
 */
#import "TLGPaymentVC.h"

/*! @brief 游戏状态回调
 *
 */
#import "TulingGameSDKHelper.h"


#endif




