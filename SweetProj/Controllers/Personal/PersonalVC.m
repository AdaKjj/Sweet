//
//  PersonalVC.m
//  SweetProj
//
//  Created by 殷婕 on 2017/11/29.
//  Copyright © 2017年 AdaKjj. All rights reserved.
//

#import "PersonalVC.h"
#import "UIImage+Addition.h"
#import "PersonalCollectionViewCell.h"
#import "PersonalSettingsVC.h"
#import "XWScanImage.h"

#import "MyCommentVC.h"
#import "MyCardViewController.h"
#import "LoginVC.h"

@interface PersonalVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout> {
    NSArray *_moduleNameArr;
    NSArray *_moduleImageArr;
}

@property (nonatomic) UICollectionView *mainCollectionView;

@property (nonatomic) UIImageView *headerImageView;
@property (nonatomic) UIImageView *avatorImageView;
@property (nonatomic, assign) CGFloat originalHeaderImageViewHeight;


@end

@implementation PersonalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    if ([userDefaults objectForKey:@"username"]) {
//        [JXTAlertController ]
//    }
    
    _headerImageView = [[UIImageView alloc] init];
    _headerImageView.clipsToBounds = YES;
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headerImageView.image = [UIImage imageNamed:@"personalBg"];
    _headerImageView.userInteractionEnabled = YES;
    [self.view addSubview:_headerImageView];
    [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.equalTo(250);
    }];
    
    _avatorImageView = [[UIImageView alloc]init];
    _avatorImageView.backgroundColor = [UIColor lightGrayColor];
    _avatorImageView.layer.masksToBounds = YES;
    _avatorImageView.userInteractionEnabled = YES;
    _avatorImageView.layer.cornerRadius = 50.0;
    _avatorImageView.contentMode = UIViewContentModeScaleAspectFill;
    //_avatorImageView.image = [UIImage imageNamed:@"text1"];
    [self.headerImageView addSubview:_avatorImageView];
    [_avatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(0);
        make.height.width.equalTo(100);
    }];
    
    if ([USERDEFAULTS objectForKey:@"Session"]) {
        _avatorImageView.image = [UIImage imageNamed:@"头像"];
    }

    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick1:)];
    [_avatorImageView addGestureRecognizer:tapGestureRecognizer1];
    
    UIButton *settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [settingsBtn addTarget:self action:@selector(settingsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    settingsBtn.userInteractionEnabled = YES;
    [self.view addSubview:settingsBtn];
    [settingsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(25);
        make.right.equalTo(-25);
        make.width.height.equalTo(30);
    }];
    
    [self setModuleName];

    [self configCollectionView];
}

- (void)setModuleName {
    _moduleNameArr = [[NSArray alloc] initWithObjects:@"历史订单", @"会员卡", @"我的收藏", @"我的评价", nil];

    UIImage *image1 = [UIImage imageNamed:@"myComment"];
    UIImage *image2 = [UIImage imageNamed:@"myCards"];
    UIImage *image3 = [UIImage imageNamed:@"myCollection"];
    UIImage *image4 = [UIImage imageNamed:@"myLike"];

    _moduleImageArr = [[NSArray alloc] initWithObjects:image1, image2, image3, image4, nil];
}

// - 浏览大图点击事件
-(void)scanBigImageClick1:(UITapGestureRecognizer *)tap{
    DLog(@"点击图片");
    UIImageView *clickedImageView = (UIImageView *)tap.view;
    [XWScanImage scanBigImageWithImageView:clickedImageView];
}


- (void)configCollectionView {
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //该方法也可以设置itemSize
    //layout.itemSize = CGSizeMake(SCREEN_WIDTH/2-4, 100);
    //2.初始化collectionView
    _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 250, SCREEN_WIDTH, SCREEN_HEIGHT-250) collectionViewLayout:layout];
    [self.view addSubview:_mainCollectionView];

    _mainCollectionView.backgroundColor = [UIColor clearColor];
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [_mainCollectionView registerClass:[PersonalCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    
    //4.设置代理
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    if (![USERDEFAULTS objectForKey:@"Session"]) {
        LoginVC *loginVC = [[LoginVC alloc] init];
        loginVC.isFromCircle = YES;
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (void)settingsButtonPressed {
    PersonalSettingsVC *personalSettingsVC = [[PersonalSettingsVC alloc] init];
    personalSettingsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personalSettingsVC animated:YES];
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(SCREEN_WIDTH/2, 80);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PersonalCollectionViewCell *cell = (PersonalCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.iconImage.image = [_moduleImageArr objectAtIndex:indexPath.row];
    cell.countLabel.text = @"4";
    cell.moduleLabel.text = [_moduleNameArr objectAtIndex:indexPath.row];
    return cell;
}

// 左右边距
- (CGFloat)collectionView: (UICollectionView *)collectionView layout: (UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex: (NSInteger)section{
    return  0.0f;
}

/**
 * Section中每个Cell的上下边距
 */
- (CGFloat)collectionView: (UICollectionView *)collectionView layout: (UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex: (NSInteger)section{
    return 0.0f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MyCommentVC *vc = [[MyCommentVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 1) {
        MyCardViewController *cardlVC = [[MyCardViewController alloc] init];
        cardlVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cardlVC animated:YES];
    }
    
}
@end
