//
//  AppDelegate.m
//  TulingGameDemo
//
//  Created by Nero on 29/9/2018.
//  Copyright © 2018 TulingGame. All rights reserved.
//

#import "AppDelegate.h"
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
    
    
    //处理未经过SDK服务器验证的【苹果内购凭证】
    //    [self handleIAPUnfinishOrder];

    
    return YES;
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
    
    //处理未经过SDK服务器验证的【苹果内购凭证】
//    [self handleIAPUnfinishOrder];
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark -- 微信\支付宝 APP回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[TulingGameSDKHelper sharedInstance] tlg_handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[TulingGameSDKHelper sharedInstance] tlg_handleOpenURL:url];
}
#pragma mark -- 处理【苹果内购】丢单问题
-(void)handleIAPUnfinishOrder{
    [[TulingGameSDKHelper sharedInstance] tlg_handleIAPUnfinishOrderWithBlock:^(BOOL isSuccess, id errorMsg, NSString *gameOrderID) {
        //支付结果(苹果内购)
        NSLog(@"\n\n【图灵SDK苹果内购防丢单回调结果：】\n\nisSuccess:%d\nerrorMsg:%@\nsdkOrderID:%@\n\n",isSuccess,errorMsg,gameOrderID);
        
    }];
}



@end
