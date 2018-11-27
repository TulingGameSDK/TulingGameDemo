//
//  ViewController.m
//  TulingGameDemo
//
//  Created by Nero on 29/9/2018.
//  Copyright © 2018 TulingGame. All rights reserved.
//

#import "ViewController.h"
#import "Util.h" //本地测试的工具集合

#import <TulingGameSDK/TulingGameSDK.h>

static const CGFloat kButtonWidth                              = 200.0;
static const CGFloat kButtonHeigh                              = 35.0;
static const CGFloat kButtonPadding                            = 13.0;
static const CGFloat kTotalBtnNum                              = 4;


typedef NS_ENUM(NSInteger, ButtonType){
    ButtonType_ChangeAccount  = 0,    // 切换账号
    ButtonType_Payment        = 1,    // 支付（SDK自身判断三方还是苹果内购）
    ButtonType_Payment_IAP    = 2,    // 支付（SDK自身判断三方还是苹果内购）
    ButtonType_Logout         = 3,     // 退出游戏
    ButtonType_Login          = 4,    // 登录
    
};



@interface ViewController ()
@property (nonatomic, strong) UILabel *bundleIDLabel;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIView *containView;
@property (nonatomic, strong) UIImageView *backgroundImageView;



@end

@implementation ViewController

//最后在dealloc中移除通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    //    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //登出状态通知
    [self setupNoti];
    
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
    
    //模拟游戏内页显示
    _backgroundImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backgroundImageView.image = [UIImage imageNamed:@"iphonetime.jpeg"];
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_backgroundImageView];
    
    //bundle ID
    _bundleIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    _bundleIDLabel.font = [UIFont boldSystemFontOfSize:16.0];
    _bundleIDLabel.textColor = [UIColor blackColor];
    _bundleIDLabel.text = [[NSBundle mainBundle] bundleIdentifier];
    _bundleIDLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_bundleIDLabel];
    
    //登录
    {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setFrame:CGRectMake(0, kButtonHeigh, kButtonWidth, kButtonHeigh)];
        [_loginButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.tag = ButtonType_Login;
        _loginButton.backgroundColor = [UIColor whiteColor];
        _loginButton.contentMode = UIViewContentModeScaleToFill;
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _loginButton.layer.cornerRadius = 2.5;
        _loginButton.layer.masksToBounds = YES;
        [self.view addSubview:_loginButton];
        _loginButton.center = self.view.center;
        
    }
    
    //操作按钮【登录、切换账号、支付、退出游戏】
    _containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kButtonWidth, kButtonHeigh*kTotalBtnNum+kButtonPadding*(kTotalBtnNum-1))];
    [self.view addSubview:_containView];
    _containView.center = self.view.center;
    
    for (int i=0; i<kTotalBtnNum; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, kButtonHeigh*i+kButtonPadding*i, kButtonWidth, kButtonHeigh)];
        [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        button.backgroundColor = [UIColor whiteColor];
        button.contentMode = UIViewContentModeScaleToFill;
        [button setTitle:[self buttonTitleWithType:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        button.layer.cornerRadius = 2.5;
        button.layer.masksToBounds = YES;
        [_containView addSubview:button];
        
    }
    
    //登录\登出状态UI
    BOOL isLogin = [TulingGameSDKHelper sharedInstance].isLogin;
    [self updateUIWithLoginStatus:isLogin];
    
    //游戏界面方向检测
    [self setupUIOriginNoti];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(NSString *)buttonTitleWithType:(int)type{
    switch (type) {
        case ButtonType_Login:
        {
            return @"登录";
        }break;
        case ButtonType_ChangeAccount:
        {
            return @"切换账号";
        }break;
        case ButtonType_Payment:
        {
            return @"支付";
        }break;
        case ButtonType_Payment_IAP:
        {
            return @"苹果内购（仅供测试）";
        }break;
        case ButtonType_Logout:
        {
            return @"退出游戏";
        }break;
            
        default:
            return nil;
            break;
    }
}

//更新UI
-(void)updateUIWithLoginStatus:(BOOL)isLogin{
    _loginButton.hidden = isLogin;
    _containView.hidden = !isLogin;
    _bundleIDLabel.frame = CGRectMake(0, _containView.frame.origin.y -80, [UIScreen mainScreen].bounds.size.width, 30);
}


//点击事件
-(void)btnAction:(UIButton *)btn{
    
    switch (btn.tag) {
        case ButtonType_Login:
        {
            
            //登录框
            [self setupSDKLoginView];
            
            
        }break;
            
        case ButtonType_ChangeAccount:
        {
            //登录框
            [self setupSDKLoginView];
            
        }break;
            
        case ButtonType_Payment:
        {
            //支付
            [self setupSDKPaymentViewWithType:PaymentTestType_Threeparty];
            
        }break;
            
        case ButtonType_Payment_IAP:
        {
            //内购，用于展示【内购】测试功能，实际不接入这个方法
            [self setupSDKPaymentViewWithType:PaymentTestType_IAP];
            
        }break;
            
        case ButtonType_Logout:
        {
            //主动登出
            [self logout];
            
        }break;
            
        default:
            break;
    }
}



//控制界面方向(demo展示，游戏实际不需要接入这部分UI旋转控制)
- (UIInterfaceOrientationMask)supportedInterfaceOrientations//支持哪些方向
{
    return UIInterfaceOrientationMaskAllButUpsideDown; //demo暂定只有横屏设置
}

/**
 初始化自己的方向, 这个在旋转屏幕时候非常重要
 If you do not implement this method, the system presents the view controller using the current orientation of the status bar.
 
 说明如果我们没有override这个方法,系统会根据当前statusbar来决定当前使用的orientation
 */
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation//默认显示的方向
{
    return UIInterfaceOrientationLandscapeLeft;
}

/**
 如果返回NO，则无论你的项目如何设置，你的ViewController都只会使用preferredInterfaceOrientationForPresentation的返回值来初始化自己的方向，如果你没有重新定义这个函数，那么它就返回父视图控制器的preferredInterfaceOrientationForPresentation的值。
 */
- (BOOL)shouldAutorotate//是否支持旋转屏幕
{
    return YES;
}

-(void)setupUIOriginNoti{
    //以监听UIApplicationDidChangeStatusBarOrientationNotification通知为例
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleStatusBarOrientationChange:)
                                                name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

//界面方向改变的处理
- (void)handleStatusBarOrientationChange: (NSNotification *)notification{
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (interfaceOrientation) {
            
        case UIInterfaceOrientationUnknown:
            NSLog(@"未知方向");
            [self dealwithOriginWithType:1];
            break;
            
        case UIInterfaceOrientationPortrait:
            NSLog(@"界面直立");
            [self dealwithOriginWithType:0];
            
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            NSLog(@"界面直立，上下颠倒");
            [self dealwithOriginWithType:0];
            
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            NSLog(@"界面朝左");
            [self dealwithOriginWithType:1];
            
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            NSLog(@"界面朝右");
            [self dealwithOriginWithType:1];
            
            break;
            
        default:
            break;
    }
}

-(void)dealwithOriginWithType:(NSInteger)type{
    //0：竖屏 1：横屏
    self.view.frame = [UIScreen mainScreen].bounds;
    _loginButton.center = self.view.center;
    _containView.center = self.view.center;
    _backgroundImageView.frame = [UIScreen mainScreen].bounds;
    
    _bundleIDLabel.frame = CGRectMake(0, _containView.frame.origin.y -80, [UIScreen mainScreen].bounds.size.width, 30);

}



#pragma mark ************************* 以下为游戏CP需要接入代码部分 *************************

#pragma mark -- 登录
-(void)setupSDKLoginView{
    
    [[TulingGameSDKHelper sharedInstance] tlg_requestLoginWithGameInitJson:[Util gameInitializationValueJaosnString] block:^(BOOL isSuccess, id errorMsg, NSString *sdkUserID, NSString *sdkToken) {
        
        NSLog(@"\n\n【图灵SDK登录回调结果：】\n\nisSuccess:%d\nerrorMsg:%@\nuserId:%@\ntoken:%@\n\n",isSuccess,errorMsg,sdkUserID,sdkToken);
        
        if (isSuccess) {
            
            NSLog(@"\n\n\n\nTulingGameDemo-Block回调-登录成功");
            NSLog(@"\n\n登录成功-Block回调数据\nuserId：%@\ntoken:%@",sdkUserID,sdkToken);
            
            //单例读取SDK本地的userid、token方法
            if ([TulingGameSDKHelper sharedInstance].isLogin) {
                NSLog(@"\n\n登录成功-SDK本地存储数据读取方法\nuserId：%@\ntoken:%@",[TulingGameSDKHelper sharedInstance].userId,[TulingGameSDKHelper sharedInstance].token);
            }
            
            //更新UI显示（游戏代码自己控制界面更新）
            [self updateUIWithLoginStatus:isSuccess];
            
            //【进入服务器、创建角色、角色升级】3种情况，需要进行角色上报API调用
            /*! @brief 角色上报类型
             TLGGameRoleEventType_EneterServer         = 0,        // 进入服务器
             TLGGameRoleEventType_CreateRole           = 1,        // 创建角色
             TLGGameRoleEventType_UpgradeRoleLevel     = 2         // 角色升级
             */
            [[TulingGameSDKHelper sharedInstance] tlg_reportGameRoleWithJsonString:[Util gameRoleValueJaosnString] eventType:TLGGameRoleEventType_EneterServer block:^(BOOL isSuccess, id errorMsg) {
                NSLog(@"\n\n【图灵SDK角色上传回调结果：】\n\nisSuccess:%d\nerrorMsg:%@\n\n",isSuccess,errorMsg);
            }];
            
        }else{
            
        }
    }];
}

#pragma mark -- 登出
-(void)logout{
    //主动登出
    [[TulingGameSDKHelper sharedInstance] tlg_reportGameLogoutWithBlock:^(BOOL isSuccessLogout) {
        
        [self updateUIWithLoginStatus:!isSuccessLogout];
        
        NSLog(@"TulingGameDemo-Block回调-主动登出成功");
        
    }];
    
}

#pragma mark -- 支付
//SDK本身会根据游戏的版本号，做后台开关，控制支付方式
//此处type只为方便展示&测试内容，（SDKDemo本身app version设置了1.0.0是走三方，如果设置了2.0.0就走内购）
-(void)setupSDKPaymentViewWithType:(PaymentTestType)type{
    
#if (TARGET_IPHONE_SIMULATOR)
    // 在模拟器的情况下
    NSLog(@"请在真机上进行IAP测试操作");
#else
    // 在真机情况下
    //游戏需要组装参数，向SDK传支付相关的参数
    NSString *gameValueJson = [Util gamePaymentOrderValueJaosnStringWithType:type];
    
    [[TulingGameSDKHelper sharedInstance] tlg_requestPaymentWithGameValueJson:gameValueJson];
#endif
    

}

#pragma mark -- 本地通知（登录状态）【主动登出、被动登出（token失效）】
-(void)setupNoti{
    // 注册通知监听- 强制登出
    // 例如:当前账号token失效，账号被SDK强制下线
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutNotification:) name:@"TLG_Notification_Logout" object:nil];
    
    // 注册通知监听-某些情况SDK需要强制调起登录框
    // 例如：SDK内修改密码成功，需要强制调起一次登录框进行重新登录操作
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginViewNotification:) name:@"TLG_Notification_ShowLoginView" object:nil];
    
}

-(void)logoutNotification:(NSNotification *)notification{
    /*
     * 主要返回登出的回调【主动&被动】，针对一些被动登出情况，做处理
     * YES:主动登出
     * NO:被动登出
     */
    id notiBody = notification.object;
    
    BOOL isActiveLogout = [[notiBody objectForKey:@"activeLogout"] boolValue];
    
    if (!isActiveLogout) {
        NSLog(@"TulingGameDemo-本地通知方式-被动登出成功");
    }
    
    /*
     if (isActiveLogout) {
     //主动登出【block回调&本地通知回调，监听处理其中之一即可】
     NSLog(@"TulingGameDemo-本地通知方式-被动登出成功");
     
     }else{
     //被动登出
     NSLog(@"TulingGameDemo-本地通知方式-被动登出成功");
     }
     */
}

-(void)showLoginViewNotification:(NSNotification *)notification{
    
    NSLog(@"TulingGameDemo-本地通知方式-SDK强制调起登录框");
    
    //显示登录框
    [self setupSDKLoginView];
}



@end

