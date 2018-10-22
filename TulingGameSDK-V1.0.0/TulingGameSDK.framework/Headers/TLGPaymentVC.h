//
//  TLGPaymentVC.h
//  TulingGameSDK
//
//  Created by Nero on 7/10/2018.
//  Copyright © 2018 TulingGame. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface TLGPaymentVC : UIViewController

/** 【必传】游戏支付相关参数 **/
@property (nonatomic, copy) NSString *gameValueJson;


/*! @brief 添加视图去windows
 *
 */
-(void)tlg_addViewToFront;

@end

NS_ASSUME_NONNULL_END
