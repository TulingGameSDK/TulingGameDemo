//
//  TLGLoginVC.h
//  TulingGameSDK
//
//  Created by Nero on 1/10/2018.
//  Copyright © 2018 TulingGame. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//对接游戏，登录的状态回调
typedef void(^TLGLoginEnterGameSuccessBlcok)(BOOL isSuccessLogin,NSString *userId, NSString *token);


@interface TLGLoginVC : UIViewController

/** 是否成功登录（登录状态回调) **/
@property (nonatomic, copy) TLGLoginEnterGameSuccessBlcok tlg_loginVCLoginStatusBlock;

/*! @brief 添加视图去windows
 *
 */
-(void)tlg_addViewToFront;

@end

NS_ASSUME_NONNULL_END
