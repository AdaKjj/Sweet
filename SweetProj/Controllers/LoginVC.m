//
//  LoginVC.m
//  SweetProj
//
//  Created by 殷婕 on 2017/11/21.
//  Copyright © 2017年 AdaKjj. All rights reserved.
//

#import "LoginVC.h"
#import "RegisterVC.h"
#import "LoginRegisterManager.h"
#import "UITextFieldEx.h"
#import "UIImage+Addition.h"

@interface LoginVC ()<UITextFieldDelegate>
@property (nonatomic) UIImageView *bgImageView;
@property (nonatomic) UIImageView *loginLogo;

@property (nonatomic) UITextFieldEmail *emailTF;
@property (nonatomic) UITextFieldPwd *pwdTF;

@property (nonatomic) UIButton *fogetPwdBtn;
@property (nonatomic) UIButton *registerBtn;

@property (nonatomic) UIButton *loginBtn;

@property (nonatomic) UIButton *wechatLoginBtn;
@property (nonatomic) UIButton *qqLoginBtn;
@property (nonatomic) UIButton *weiboLoginBtn;

@property (nonatomic) LoginRegisterManager *loginManager;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)configViewController {
    _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userBg"]];
    [self.view addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(0);
        make.bottom.equalTo(0);
        make.right.equalTo(0);
    }];
    
    //设置导航条
    self.navigationItem.title = @"登录";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    [self.navigationController.navigationBar setTitleTextAttributes:textAttrs];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(self.view.frame.size.width, 0.5)]];
    
    UIImage *backBarImage = [UIImage imageNamed:@"backBarBtnClicked"];
    backBarImage = [self reSizeImage:backBarImage toSize:CGSizeMake(30, 22)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:backBarImage
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(backBtnPressed)];
    self.navigationItem.leftBarButtonItem = item;
    
    _loginLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginLogo"]];
    [self.view addSubview:_loginLogo];
    [_loginLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(90);
        make.height.width.equalTo(175);
    }];
    
    UIImageView *emailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 26)];
    emailImageView.image = [UIImage imageNamed:@"user"];
    emailImageView.contentMode = UIViewContentModeScaleAspectFit;
    _emailTF = [[UITextFieldEmail alloc] init];
    _emailTF.borderStyle = UITextBorderStyleNone;
    _emailTF.textColor = [UIColor colorWithRed:155/255.0 green:175/255.0 blue:182/255.0 alpha:1];
    _emailTF.backgroundColor = [UIColor clearColor];
    _emailTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入邮箱地址"
                                                                     attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:155/255.0 green:175/255.0 blue:182/255.0 alpha:1]}];
    _emailTF.layer.borderWidth = 2.0f;
    _emailTF.layer.cornerRadius = 20;
    _emailTF.layer.borderColor = [UIColor colorWithRed:155/255.0 green:175/255.0 blue:182/255.0 alpha:1].CGColor;
    _emailTF.clearButtonMode = UITextFieldViewModeAlways;
    _emailTF.leftView = emailImageView;
    _emailTF.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_emailTF];
    [_emailTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(_loginLogo.mas_bottom).inset(50);
        make.height.equalTo(40);
        make.width.equalTo(300);
    }];
    _emailTF.delegate = self;
    
    UIImageView *pwdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 26)];
    pwdImageView.image = [UIImage imageNamed:@"pwd"];
    pwdImageView.contentMode = UIViewContentModeScaleAspectFit;
    _pwdTF = [[UITextFieldPwd alloc] init];
    _pwdTF.borderStyle = UITextBorderStyleNone;
    _pwdTF.textColor = [UIColor colorWithRed:155/255.0 green:175/255.0 blue:182/255.0 alpha:1];
    _pwdTF.backgroundColor = [UIColor clearColor];
    _pwdTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码"
                                                                   attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:155/255.0 green:175/255.0 blue:182/255.0 alpha:1]}];
    _pwdTF.layer.borderWidth = 2.0f;
    _pwdTF.layer.cornerRadius = 20;
    _pwdTF.layer.borderColor = [UIColor colorWithRed:155/255.0 green:175/255.0 blue:182/255.0 alpha:1].CGColor;
    _pwdTF.clearButtonMode = UITextFieldViewModeAlways;
    _pwdTF.leftView = pwdImageView;
    _pwdTF.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_pwdTF];
    [_pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(_emailTF.mas_bottom).inset(20);
        make.height.equalTo(40);
        make.width.equalTo(300);
    }];
    _pwdTF.delegate = self;
    
    _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [_registerBtn setTitleColor:[UIColor whiteColor]
                       forState:UIControlStateNormal];
    [_registerBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_registerBtn addTarget:self action:@selector(registerBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerBtn];
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_pwdTF.mas_left);
        make.top.equalTo(_pwdTF.mas_bottom).inset(16);
    }];
    
    _fogetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fogetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_fogetPwdBtn setTitleColor:[UIColor whiteColor]
                       forState:UIControlStateNormal];
    [_fogetPwdBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_fogetPwdBtn addTarget:self action:@selector(fogetPwdBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_fogetPwdBtn];
    [_fogetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_pwdTF.mas_right);
        make.top.equalTo(_pwdTF.mas_bottom).inset(16);
    }];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor blackColor]
                    forState:UIControlStateNormal];
    [_loginBtn setBackgroundColor:[UIColor whiteColor]];
    _loginBtn.layer.cornerRadius = 20;
    [_loginBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_loginBtn addTarget:self action:@selector(loginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(_registerBtn.mas_bottom).inset(25);
        make.height.equalTo(40);
        make.width.equalTo(150);
    }];
    
    _qqLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_qqLoginBtn setImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    [_qqLoginBtn setImage:[UIImage imageNamed:@"qqPerssed"] forState:UIControlStateHighlighted];
    [_qqLoginBtn addTarget:self action:@selector(qqLoginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_qqLoginBtn];
    [_qqLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.bottom.equalTo(-40);
        make.height.equalTo(25);
        make.width.equalTo(25);
    }];
    
    _wechatLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_wechatLoginBtn setImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
    [_wechatLoginBtn setImage:[UIImage imageNamed:@"wechatPressed"] forState:UIControlStateHighlighted];
    [_wechatLoginBtn addTarget:self action:@selector(wechatLoginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_wechatLoginBtn];
    [_wechatLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_qqLoginBtn.mas_left).inset(30);
        make.bottom.equalTo(-40);
        make.height.equalTo(25);
        make.width.equalTo(25);
    }];
    
    
    
    _weiboLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_weiboLoginBtn setImage:[UIImage imageNamed:@"weibo"] forState:UIControlStateNormal];
    [_weiboLoginBtn setImage:[UIImage imageNamed:@"weiboPerssed"] forState:UIControlStateHighlighted];
    [_weiboLoginBtn addTarget:self action:@selector(weiboLoginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_weiboLoginBtn];
    [_weiboLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_qqLoginBtn.mas_right).inset(30);
        make.bottom.equalTo(-40);
        make.height.equalTo(25);
        make.width.equalTo(25);
    }];
}
- (void)fogetPwdBtnClicked {
    RegisterVC *registerVC = [RegisterVC new];
    registerVC.fromVCStr = @"密码找回";
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)registerBtnClicked {
    RegisterVC *registerVC = [RegisterVC new];
    registerVC.fromVCStr = @"注册";
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)loginBtnClicked {
    NSString *errorMessage;
    if (_emailTF.text.length == 0 || _pwdTF.text.length == 0) {
        errorMessage = [NSString stringWithFormat:@"请输入正确的邮箱及密码"];
    }
    else {
        if ([_emailTF isValid:&errorMessage] && [_pwdTF isValid:&errorMessage]) {
            LoginRegisterManager *manager = [[LoginRegisterManager alloc] init];
            manager.loginVC = self;
            [manager sendRequest:LOGINUSERLOGIN email:self.emailTF.text pwd:self.pwdTF.text verdificationCode:nil];
            return;
        }
    }
    [self jxt_showAlertWithTitle:nil message:errorMessage appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.addActionCancelTitle(@"确定");
    } actionsBlock:nil];
    
}

- (void)wechatLoginBtnClicked {
    
}

- (void)qqLoginBtnClicked {
    
}

- (void)weiboLoginBtnClicked {
    
}

- (void)backBtnPressed {
    if (_isFromCircle) {
        self.tabBarController.selectedIndex = 0;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)receiveLoginRequest:(NSString *)requestResult {
    if (requestResult.length == 32) {
        [USERDEFAULTS setObject:_emailTF.text forKey:@"username"];
        [USERDEFAULTS setObject:_pwdTF.text forKey:@"password"];
        [USERDEFAULTS setObject:requestResult forKey:@"Session"];
        [USERDEFAULTS synchronize];
        
        [self.navigationController popViewControllerAnimated:NO];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"请输入正确的邮箱和密码"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}


- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 不能加空格
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return  NO;
    }
    return YES;
}
@end
