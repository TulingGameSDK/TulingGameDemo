//
//  AppDelegate.m
//  TulingGameDemo
//
//  Created by Nero on 29/9/2018.
//  Copyright © 2018 TulingGame. All rights reserved.
//

#import "AppDelegate.h"
#import "Util.h" //本地测试的工具集合

#import <TulingGameSDK/TulingGameSDK.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];

    UIViewController *VC = [NSClassFromString(@"ViewController") new];
    UINavigationController *NC = [[UINavigationController alloc] initWithRootViewController:VC];
    self.window.rootViewController = NC;
    
#pragma mark -- IAP监听注册 && 支付结果回调
    //【图灵SDK】注册全局的IAP操作监听(含丢单处理逻辑)
    [[TulingGameSDKHelper sharedInstance] tlg_registerIAPNotiWithBlock:^(NSString *productID) {
        
        //游戏重新向SDK传支付订单参数
        //IAP防丢当操作方案:IAP先完成支付操作，支付成功之后，才向游戏请求gameOrderID，绑定订单号
        //苹果内购IAP：游戏根据SDK传过来的productID，重新组装当前时间的订单相关参数，传给SDK
        NSString *gameOrderJson = [Util gamePaymentOrderValueJaosnStringWithType:PaymentTestType_IAP];

        //SDK开始绑定订单号，并且验证【内购凭证】
        [[TulingGameSDKHelper sharedInstance] tlg_requestIAPWithGameOrderJson:gameOrderJson];
        
    }];
    
    //支付结果回调（IAP+三方）
    [[TulingGameSDKHelper sharedInstance] tlg_paymentCallBack:^(BOOL isSuccess, id errorMsg, NSString *gameOrderID) {
        //支付结果(苹果内购-丢单部分重新下单)
        NSLog(@"\n\n【图灵SDK支付回调结果：】\nisSuccess:%d\nerrorMsg:%@\ngameOrderID:%@\n\n",isSuccess,errorMsg,gameOrderID);
    }];
    
    return YES;
}

#pragma mark -- 三方支付APP回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[TulingGameSDKHelper sharedInstance] tlg_handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[TulingGameSDKHelper sharedInstance] tlg_handleOpenURL:url];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
