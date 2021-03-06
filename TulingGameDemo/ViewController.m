//
//  ViewController.m
//  TulingGameDemo
//
//  Created by Nero on 29/9/2018.
//  Copyright © 2018 TulingGame. All rights reserved.
//

#import "ViewController.h"
#import "Util.h" //本地测试的工具集合
#import "SDKSingleObject.h"

#import <TulingGameSDK/TulingGameSDK.h>

static const CGFloat kButtonWidth                              = 200.0;
static const CGFloat kButtonHeigh                              = 35.0;
static const CGFloat kButtonPadding                            = 13.0;
static const CGFloat kTotalBtnNum                              = 5;


typedef NS_ENUM(NSInteger, ButtonType){
    ButtonType_ChangeAccount  = 0,    // 切换账号
    ButtonType_PM             = 1,    // 支付（SDK自身判断三方还是苹果内购）
    ButtonType_PM_IAP         = 2,    // 支付（SDK自身判断三方还是苹果内购）
    ButtonType_Report         = 3,    // 上报
    ButtonType_Logout         = 4,    // 退出游戏
    ButtonType_Login          = 5,    // 登录

};





@interface ViewController ()<UIActionSheetDelegate>
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
        case ButtonType_PM:
        {
            return @"支付（后台开关）";
        }break;
        case ButtonType_PM_IAP:
        {
            return @"苹果内购（仅供调试）";
        }break;
        case ButtonType_Report:
        {
            return @"上报数据";
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
            
        case ButtonType_PM:
        {
            //支付
            [self setupSDKPMViewWithType:PMTestType_Threeparty productId:[Util productIDInIndex:0]];
            
        }break;
            
        case ButtonType_PM_IAP:
        {
            //内购，用于展示【内购】测试功能，实际不接入这个方法
            [self showProductList];
//            [self setupSDKPMViewWithType:PMTestType_IAP productId:[Util productIDInIndex:0]];

            
        }break;
            
        case ButtonType_Report:
        {
            //上报数据
            [self showReportActiontList];
            
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

-(void)showReportActiontList{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"事件上报操作选择"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:
                                  [Util reportActionInIndex:TLGGameRoleEventType_EneterServer],
                                  [Util reportActionInIndex:TLGGameRoleEventType_CreateRole],
                                  [Util reportActionInIndex:TLGGameRoleEventType_UpgradeRoleLevel],
                                  [Util reportActionInIndex:TLGGameRoleEventType_QuitServer],nil];
    actionSheet.actionSheetStyle = UIBarStyleDefault;
    [actionSheet showInView:self.view];
    actionSheet.tag = 1;
}

-(void)showProductList{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"demo测试商品选择"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:
                                  [Util productIDInIndex:0],
                                  [Util productIDInIndex:1],
                                  [Util productIDInIndex:2],
                                  [Util productIDInIndex:3],nil];
    actionSheet.actionSheetStyle = UIBarStyleDefault;
    [actionSheet showInView:self.view];
    actionSheet.tag = 2;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 1) {
        //事件上报
        [[SDKSingleObject sharedInstance] sdkRoleReportType:buttonIndex];
        
    }else if (actionSheet.tag == 2){
        //商品选择
        if (buttonIndex <= 3) {
            //选择完，调起IAP支付
            [self setupSDKPMViewWithType:PMTestType_IAP productId:[Util productIDInIndex:buttonIndex]];
            
        }else{
            
        }

    }else{}
    
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
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

#pragma mark -- 更新UI界面
-(void)setupNoti{
    //根据登录状态，更新UI（demo展示）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:@"TLG_Game_UpdateLoginUI" object:nil];
}

-(void)updateUI:(NSNotification *)notification{
    id notiBody = notification.object;
    BOOL isLogined = [[notiBody objectForKey:@"isLogined"] boolValue];
    [self updateUIWithLoginStatus:isLogined];
}


#pragma mark ************************* 游戏操作部分，具体调用请参考【SingleObject单例】使用 *************************

#pragma mark -- 登录
-(void)setupSDKLoginView{
    [[SDKSingleObject sharedInstance] sdkLoginView];
}

#pragma mark -- 登出
-(void)logout{
    [[SDKSingleObject sharedInstance] sdkLogout];
}

#pragma mark -- 支付
//SDK本身会根据游戏的版本号，做后台开关，控制支付方式
//此处type只为方便展示&测试内容，（SDKDemo本身app version设置了0.0.1是走三方，如果设置了1.0.0就走内购）
-(void)setupSDKPMViewWithType:(PMTestType)type productId:(NSString *)productId{
    [[SDKSingleObject sharedInstance] sdkPMViewWithType:type productId:productId];
}


@end

