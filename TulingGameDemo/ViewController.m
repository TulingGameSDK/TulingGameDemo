//
//  ViewController.m
//  TulingGameDemo
//
//  Created by Nero on 29/9/2018.
//  Copyright © 2018 TulingGame. All rights reserved.
//

#import "ViewController.h"
#import <TulingGameSDK/TulingGameSDK.h>

static const CGFloat kButtonWidth                              = 200.0;
static const CGFloat kButtonHeigh                              = 35.0;
static const CGFloat kButtonPadding                            = 13.0;
static const CGFloat kTotalBtnNum                              = 3;


typedef NS_ENUM(NSInteger, ButtonType){
    ButtonType_ChangeAccount  = 0,    // 切换账号
    ButtonType_Payment        = 1,    // 支付
    ButtonType_Logout         = 2,     // 退出游戏
    ButtonType_Login          = 3,    // 登录

};


@interface ViewController ()
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIView *containView;
@property (nonatomic, strong) UIImageView *backgroundImageView;


@property (nonatomic, strong) TLGLoginVC *loginVC;
@property (nonatomic, strong) TLGPaymentVC *paymentVC;
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
        case ButtonType_Logout:
        {
            return @"退出游戏";
        }break;
            
        default:
            return nil;
            break;
    }
}

#pragma mark -- 游戏参数初始化
-(NSString *)gameInitializationValueJaosnString{
    
    /*! @brief 游戏传参（5个组成组成参数，需要NSDictionary转成一条json string传给SDK）
     *
     * param gameID       【NSInteger-游戏ID】
     * param cid          【NSInteger渠道ID】
     * param aid          【NSInteger广告位ID】
     * param gameVersion  【NSString-游戏版本】
     * param gameKey      【NSString-给游戏分配的KEY】
     */

    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @(23),@"gameID",
                         @(3),@"cid",
                         @(3),@"aid",
                         @"1.0",@"gameVersion",
                         @"Ggg18dKOam7Wj6IoMMNdgDE0UmMejKg7",@"gameKey",
                         nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;

}

#pragma mark -- 游戏角色上报
-(NSString *)gameRoleValueJaosnString{
    
    /*! @brief 创建角色上报【创建角色成功后调用】
     *
     * param serverId;              //【NSString】区服id
     * param serverName;            //【NSString】区服名字
     * param roleId;                //【NSString】角色id
     * param roleName;              //【NSString】角色名
     * param roleLevel;             //【NSInteger】角色等级
     * param vipLevel;              //【NSInteger】VIP等级
     * param balance;               //【CGFloat】玩家游戏币总额， 如 100 金币
     * param partyName;             //【NSString】帮派，公会名称。 若无，填 unknown
     * param roleCreatedTime;       //【NSInteger】角色创建的时间戳，单位：秒
     * param roleLevelUpgradedTime; //【NSInteger】角色升级的时间戳，单位：秒
     */
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"3",@"serverId",
                         @"魔兽世界-中国服",@"serverName",
                         @"3456",@"roleId",
                         @"玩家角色名",@"roleName",
                         @"10",@"roleLevel",
                         @"3",@"vipLevel",
                         @(10000),@"balance",
                         @"图灵公会",@"partyName",
                         @(1539571500),@"roleCreatedTime",
                         @(1539572950),@"roleLevelUpgradedTime",
                         nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
    
}


#pragma mark -- 游戏预订单生成，传参
-(NSString *)gamePaymentOrderValueJaosnString{
    
    /*! @brief 生成订单接口【请注意上传的字段格式】
     *
     * param amount;                //【NSInteger】充值金额，单位：分,必传
     * param orderId;               //【NSString】研发传入的订单号，必传
     * param roleId;                //【NSString】玩家角色id，必传
     * param roleName;              //【NSString】玩家角色名，必传
     * param roleLevel;             //【NSString】角色等级，必传
     * param serverId;              //【NSString】区服id，必传
     * param serverName;            //【NSString】区服名字，必传
     * param productId;             //【NSString】商品ID，必传
     * param productName;           //【NSString】商品名，商品名称前请不要添加任何量词。如钻石，月卡即可。必传
     * param payInfo;               //【NSString】商品描述信息，必传
     * param productCount;          //【NSString】购买的商品数量，必传
     * param notifyUrl;             //【NSString】支付结果回调地址，必传
     * param extraData;             //【NSString】透传参数，字符串，可选
     */

    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @(1),@"amount",
                         @"2018101034t445675767",@"orderId",
                         @"3456",@"roleId",
                         @"玩家角色名",@"roleName",
                         @"10",@"roleLevel",
                         @"3",@"serverId",
                         @"魔兽世界-中国服",@"serverName",
                         @"1",@"productId",
                         @"游戏钻石",@"productName",
                         @"充值100金币-10元",@"payInfo",
                         @"1",@"productCount",
                         @"https://www.baidu.com",@"notifyUrl",
                         @"这是一条测试订单",@"extraData",
                         nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
    
}

#pragma mark -- 登出状态的t本地通知【主动登出、被动登出（token失效）】
-(void)setupNoti{
    // 注册通知监听-是否token失效导致账号登出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutNotification:) name:@"TLG_Notification_Logout" object:nil];
    
    // 注册通知监听-某些情况SDK需要强制调起登录框
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
    
    if (isActiveLogout) {
        //主动登出【block回调&本地通知回调，处理其中之一就可以】
        NSLog(@"TulingGameDemo-本地通知方式-被动登出成功");

    }else{
        //被动登出
        NSLog(@"TulingGameDemo-本地通知方式-被动登出成功");
    }
}

-(void)showLoginViewNotification:(NSNotification *)notification{
    //显示登录框
    [self setupLoginView];
}


#pragma mark --根据登录状态，更新UI
-(void)updateUIWithLoginStatus:(BOOL)isLogin{
    _loginButton.hidden = isLogin;
    _containView.hidden = !isLogin;
}


#pragma mark -- 显示登录框
-(void)setupLoginView{
    /**
     TulinggameSDK初始化，
     游戏RootVC调用，必须使用强引用
     **/
    TLGLoginVC *loginVC = [TLGLoginVC new];
    self.loginVC = loginVC;//必须强引用
    [loginVC tlg_addViewToFront];
    
    //是否成功登录（登录状态回调）
    loginVC.tlg_loginVCLoginStatusBlock = ^(BOOL isSuccessLogin,NSString *userId,NSString *token) {
        
        [self updateUIWithLoginStatus:isSuccessLogin];
        
        //回调信息【userId、token】
        if (isSuccessLogin) {
            NSLog(@"\n\n\n\nTulingGameDemo-Block回调-登录成功");
            NSLog(@"\n\n登录成功-Block回调数据\nuserId：%@\ntoken:%@",userId,token);
            
            //单例读取SDK本地的userid、token方法
            if ([TulingGameSDKHelper sharedInstance].isLogin) {
                NSLog(@"\n\n登录成功-SDK本地存储数据\nuserId：%@\ntoken:%@",[TulingGameSDKHelper sharedInstance].userId,[TulingGameSDKHelper sharedInstance].token);
            }
            
            //【进入服务器、创建角色、角色升级】3种情况，需要进行角色上报API调用
            /*! @brief 角色上报类型
             TLGGameRoleEventType_EneterServer         = 0,        // 进入服务器
             TLGGameRoleEventType_CreateRole           = 1,        // 创建角色
             TLGGameRoleEventType_UpgradeRoleLevel     = 2         // 角色升级
             */
            [[TulingGameSDKHelper sharedInstance] tlg_reportGameRoleWithJsonString:[self gameRoleValueJaosnString] eventType:TLGGameRoleEventType_EneterServer];
            
        }else{
            NSLog(@"TulingGameDemo-Block回调-登录失败");
        }
        
    };
}

#pragma mark -- 显示支付框
-(void)setupPaymentView{
    /**
     TulinggameSDK 支付初始化，
     游戏RootVC调用，必须使用强引用
     **/
    TLGPaymentVC *paymentVC = [TLGPaymentVC new];
    self.paymentVC = paymentVC;//必须强引用
    paymentVC.gameValueJson = [self gamePaymentOrderValueJaosnString];//向SDK传支付相关的参数
    [paymentVC tlg_addViewToFront];
    
}

#pragma mark -- 点击事件
-(void)btnAction:(UIButton *)btn{
    
    switch (btn.tag) {
        case ButtonType_Login:
        {
            //【SDK初始化-必须调用，只需调用一次】
            if (![TulingGameSDKHelper sharedInstance].isInitializationValid) {
                [[TulingGameSDKHelper sharedInstance] tlg_dataInitializationWithGameJson:[self gameInitializationValueJaosnString]];
            }

            //登录框
            [self setupLoginView];
            
//            [[TulingGameSDKHelper sharedInstance] printLog];

        }break;
            
        case ButtonType_ChangeAccount:
        {
            //登录框
            [self setupLoginView];

        }break;
            
        case ButtonType_Payment:
        {
            //支付
            [self setupPaymentView];
            
        }break;
            
        case ButtonType_Logout:
        {
            //主动登出
            [[TulingGameSDKHelper sharedInstance] tlg_reportGameLogoutWithBlock:^(BOOL isSuccessLogout) {

                [self updateUIWithLoginStatus:!isSuccessLogout];
                
                NSLog(@"TulingGameDemo-Block回调-主动登出成功");

            }];

        }break;
            
        default:
            break;
    }
}


#pragma mark -- 控制界面方向(demo展示，游戏实际不需要接入这部分UI旋转控制)
#pragma mark - viewController orientation
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
}


@end
