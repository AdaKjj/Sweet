//
//  MainVC.m
//  SweetProj
//
//  Created by 殷婕 on 2017/11/21.
//  Copyright © 2017年 AdaKjj. All rights reserved.
//

#import "MainVC.h"
#import "Masonry.h"
#import "LoginVC.h"
#import "AdCell.h"
#import "AdCellLayout.h"
#import "MainItemCell.h"
#import "UIImage+Addition.h"
#import "FoodPreviewVC.h"
#import "FoodDetailVC.h"

#import "JFLocation.h"
#import "JFAreaDataManager.h"
#import "JFCityViewController.h"
#import <CoreLocation/CoreLocation.h>

#import "MainManager.h"
#import "UIImageView+WebCache.h"

#define KCURRENTCITYINFODEFAULTS [NSUserDefaults standardUserDefaults]

@interface MainVC ()<UISearchBarDelegate, UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, JFCityViewControllerDelegate, CLLocationManagerDelegate>

@property (nonatomic) UIButton *loginBtn;
@property (nonatomic) UISearchBar *searchBar;

@property (nonatomic) UIButton *locBtn;
@property (nonatomic) UILabel *locLabel;
/** 城市定位管理器*/
@property (nonatomic, strong) JFLocation *locationManager;
/** 城市数据管理器*/
@property (nonatomic, strong) JFAreaDataManager *manager;

@property (nonatomic) UICollectionView *topicCollectionView;

@property (nonatomic) UICollectionView *foodCollectionView;
@property (nonatomic) UIButton *moreFoodBtn;
@property (nonatomic) UICollectionView *relaxCollectionView;
@property (nonatomic) UIButton *moreRelaxBtn;
@property (assign,  nonatomic) bool isPop;

@property (nonatomic) CLLocationManager *clLocationManager;
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(243, 243, 243);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self startLocation];
    [self setupSearchBar];
    
    [self configCollectionView];
    [self setupAdArr];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setupLoginBtn];
    [self.navigationController setNavigationBarHidden:NO];
    [self.tabBarController setHidesBottomBarWhenPushed:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupLoginBtn {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isLogin = [userDefaults objectForKey:@"username"];
    if (!isLogin) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_loginBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_loginBtn];
        [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(20);
            make.height.width.equalTo(50);
        }];
    }
    else {
        _loginBtn.hidden = YES;
    }
}

- (void)configCollectionView
{
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    scrollView.backgroundColor = RGB(243, 243, 243);
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.right.equalTo(0);
        make.bottom.equalTo(0);
    }];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 0);


    UIImage *bgImage = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(SCREEN_WIDTH, 40)];
    
    UIImageView *noUseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    noUseImageView.image = bgImage;
    noUseImageView.userInteractionEnabled = YES;
    [scrollView addSubview:noUseImageView];

    _locBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _locBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_locBtn setImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
    [_locBtn setTitle:@"定位" forState:UIControlStateNormal];
    [_locBtn.titleLabel setFont:BoldSystemFont(20)];
    [_locBtn addTarget:self action:@selector(locBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [noUseImageView addSubview:_locBtn];
    [_locBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(22);
        make.height.equalTo(22);
        make.centerY.equalTo(0);
        make.left.equalTo(20);
    }];
    
    _locLabel = [[UILabel alloc] init];
    [_locLabel setFont:BoldSystemFont(20)];
    _locLabel.text = @"定位";
    _locLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locBtnClicked)];
    [_locLabel addGestureRecognizer:labelTapGestureRecognizer];
    [noUseImageView addSubview:_locLabel];
    [_locLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_locBtn.mas_right);
        make.bottom.equalTo(_locBtn.mas_bottom);
        make.height.equalTo(24);
        make.width.equalTo(100);
    }];
    
    //————————————————————————————专题
    //1.初始化ToopicAdlayout
    AdCellLayout *layout = [[AdCellLayout alloc] init];
    //2.初始化collectionView
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _topicCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, 220) collectionViewLayout:layout];
    _topicCollectionView.tag = 0;
    [scrollView addSubview:_topicCollectionView];
    
    //隐藏水平滚动条
    _topicCollectionView.showsHorizontalScrollIndicator = NO;
    _topicCollectionView.backgroundColor = [UIColor whiteColor];
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [_topicCollectionView registerClass:[AdCell class] forCellWithReuseIdentifier:@"topicCell"];
    //4.设置代理
    _topicCollectionView.delegate = self;
    _topicCollectionView.dataSource = self;
    

    
    //————————————————————————————————————美食导航栏
    UIImage *whiteImage = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(SCREEN_WIDTH, 30)];
    UIImageView *foodToolBar = [[UIImageView alloc]initWithImage:whiteImage];
    foodToolBar.userInteractionEnabled = YES;
    [scrollView addSubview:foodToolBar];
    [foodToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(290);
        make.left.equalTo(0);
        make.height.equalTo(35);
        make.width.equalTo(SCREEN_WIDTH);
    }];
    
    UILabel *foodLabel = [[UILabel alloc]init];
    foodLabel.text = @"美食";
    foodLabel.textColor = RGB(75, 173, 96);
    [foodLabel setFont:systemFont(22)];
    [foodToolBar addSubview:foodLabel];
    [foodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(2);
        make.left.equalTo(15);
        make.width.equalTo(70);
        make.height.equalTo(30);
    }];
    
    _moreFoodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreFoodBtn setTitle:@"查看更多 >" forState:UIControlStateNormal];
    [_moreFoodBtn setTitleColor:RGB(75, 173, 96) forState:UIControlStateNormal];
    [_moreFoodBtn.titleLabel setFont:systemFont(15)];
    _moreFoodBtn.contentHorizontalAlignment =  UIControlContentVerticalAlignmentBottom;
    [_moreFoodBtn addTarget:self action:@selector(moreFoodBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [foodToolBar addSubview:_moreFoodBtn];
    [_moreFoodBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-2);
        make.right.equalTo(-12);
        make.width.equalTo(80);
        make.height.equalTo(30);
    }];
    
    //————————————————————————————美食
    UICollectionViewFlowLayout *foodLayout = [[UICollectionViewFlowLayout alloc] init];
    foodLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _foodCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 325, SCREEN_WIDTH, 180) collectionViewLayout:foodLayout];
    _foodCollectionView.tag = 2;
    [scrollView addSubview:_foodCollectionView];
    
    _foodCollectionView.showsVerticalScrollIndicator = NO;
    _foodCollectionView.backgroundColor = [UIColor whiteColor];
    [_foodCollectionView registerClass:[MainItemCell class] forCellWithReuseIdentifier:@"mainCell"];
    _foodCollectionView.delegate = self;
    _foodCollectionView.dataSource = self;
    
    //————————————————————————————————————休闲娱乐导航栏
    UIImageView *relaxToolBar = [[UIImageView alloc]initWithImage:whiteImage];
    relaxToolBar.userInteractionEnabled = YES;
    [scrollView addSubview:relaxToolBar];
    [relaxToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(520);
        make.left.equalTo(0);
        make.height.equalTo(35);
        make.width.equalTo(SCREEN_WIDTH);
    }];
    
    UILabel *relaxLabel = [[UILabel alloc]init];
    relaxLabel.text = @"休闲娱乐";
    relaxLabel.textColor = RGB(84, 123, 199);
    [relaxLabel setFont:systemFont(22)];
    [relaxToolBar addSubview:relaxLabel];
    [relaxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(2);
        make.left.equalTo(15);
        make.width.equalTo(100);
        make.height.equalTo(25);
    }];
    
    _moreRelaxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreRelaxBtn setTitle:@"查看更多 >" forState:UIControlStateNormal];
    
    [_moreRelaxBtn setTitleColor:RGB(84, 123, 199) forState:UIControlStateNormal];
    [_moreRelaxBtn.titleLabel setFont:systemFont(15)];
    _moreRelaxBtn.contentHorizontalAlignment = UIControlContentVerticalAlignmentBottom;
    [_moreRelaxBtn addTarget:self action:@selector(moreRelaxBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [relaxToolBar addSubview:_moreRelaxBtn];
    [_moreRelaxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-2);
        make.right.equalTo(-12);
        make.width.equalTo(80);
        make.height.equalTo(30);
    }];
    //————————————————————————————休闲娱乐
    UICollectionViewFlowLayout *relaxLayout = [[UICollectionViewFlowLayout alloc] init];
    relaxLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _relaxCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 555, SCREEN_WIDTH, 180) collectionViewLayout:relaxLayout];
    _relaxCollectionView.tag = 3;
    [scrollView addSubview:_relaxCollectionView];
    
    _relaxCollectionView.showsVerticalScrollIndicator = NO;
    _relaxCollectionView.backgroundColor = [UIColor whiteColor];
    [_relaxCollectionView registerClass:[MainItemCell class] forCellWithReuseIdentifier:@"relaxCell"];
    _relaxCollectionView.delegate = self;
    _relaxCollectionView.dataSource = self;
    
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _relaxCollectionView.frame.origin.y + _relaxCollectionView.frame.size.height);
}

//TODO: 真机测试
- (void)setupAdArr
{
    self.recreationModel = [[RecreationModel alloc] initWithDictionary:[MainManager getMainDic] error:nil];
    self.foodModel = [[FoodCollectionModel alloc] initWithDictionary:[MainManager getMainDic] error:nil];
    self.advertisingModel = [[AdvertisingModel alloc] initWithDictionary:[MainManager getMainDic] error:nil];
}

- (void)loginBtnClick
{
    LoginVC *loginVC = [[LoginVC alloc] init];
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)setupSearchBar
{
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH - 70,40)];
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.frame = CGRectMake(0,2,SCREEN_WIDTH - 70,35);
    searchBar.layer.cornerRadius = 18;
    searchBar.layer.masksToBounds = YES;
    //边框线粗细
    [searchBar.layer setBorderWidth:8];
    //设置边框为白色是为了盖住UISearchBar上的灰色
    [searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];
    searchBar.placeholder = @"在Sweet上搜索";
    [titleView addSubview:searchBar];
    self.navigationItem.titleView = titleView;
}

- (void)moreFoodBtnClicked {
    FoodPreviewVC *vc = [[FoodPreviewVC alloc]init];
    vc.topicString = @"美食";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)moreRelaxBtnClicked {
    FoodPreviewVC *vc = [[FoodPreviewVC alloc]init];
    vc.topicString = @"休闲娱乐";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)locBtnClicked {
    JFCityViewController *cityViewController = [[JFCityViewController alloc] init];
    cityViewController.delegate = self;
    cityViewController.title = @"城市";
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cityViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

-(void)startLocation{
    if ([CLLocationManager locationServicesEnabled]) {//判断定位操作是否被允许
        self.clLocationManager = [[CLLocationManager alloc] init];
        self.clLocationManager.delegate = self;//遵循代理
        self.clLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.clLocationManager.distanceFilter = 10.0f;
        [self.clLocationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8以上版本定位需要）
        [self.clLocationManager startUpdatingLocation];//开始定位
    }
    else {
        // TODO:定位不成功时返回
        //不能定位用户的位置的情况再次进行判断，并给与用户提示
        //1.提醒用户检查当前的网络状况
        //2.提醒用户打开定位开关
    }
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //当前所在城市的坐标值
    CLLocation *currLocation = [locations lastObject];
    NSLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
    _latitude = currLocation.coordinate.latitude;
    _longitude = currLocation.coordinate.longitude;
    //根据经纬度反向地理编译出地址信息
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSDictionary *address = [placemark addressDictionary];
            //  Country(国家)  State(省)  City（市）
            NSLog(@"#####%@",address);
            NSLog(@"%@", [address objectForKey:@"Country"]);
            NSLog(@"%@", [address objectForKey:@"State"]);
            NSLog(@"%@", [address objectForKey:@"City"]);
            _locLabel.text = [address objectForKey:@"City"];
        }
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if ([error code] == kCLErrorDenied){
        //访问被拒绝
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
    }
}


#pragma mark - JFCityViewControllerDelegate

- (void)cityName:(NSString *)name {
    _locLabel.text = name;
}

#pragma mark --- JFLocationDelegate
//定位中...
- (void)locating {
    NSLog(@"定位中...");
}

//定位成功
- (void)currentLocation:(NSDictionary *)locationDictionary {
    NSString *city = [locationDictionary valueForKey:@"City"];
    if (![_locLabel.text isEqualToString:city]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"您定位到%@，确定切换城市吗？",city] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _locLabel.text = city;
            [KCURRENTCITYINFODEFAULTS setObject:city forKey:@"locationCity"];
            [KCURRENTCITYINFODEFAULTS setObject:city forKey:@"currentCity"];
            [self.manager cityNumberWithCity:city cityNumber:^(NSString *cityNumber) {
                [KCURRENTCITYINFODEFAULTS setObject:cityNumber forKey:@"cityNumber"];
            }];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

/// 拒绝定位
- (void)refuseToUsePositioningSystem:(NSString *)message {
    NSLog(@"%@",message);
}

/// 定位失败
- (void)locateFailure:(NSString *)message {
    NSLog(@"%@",message);
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 0) {
        return [self.advertisingModel.advertising count];
    }
    return [self.recreationModel.recreation count] ;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView .tag == 0) {
        return CGSizeMake(224, 160);
    }
    else if (collectionView.tag == 1) {
        return CGSizeMake(140, 100);
    }
    else {
        return CGSizeMake(190, 180);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 0) {
        self.adUrlModel = self.advertisingModel.advertising[indexPath.row];
        NSURL *imageUrl = _adUrlModel.url;
        AdCell *cell = (AdCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"topicCell" forIndexPath:indexPath];
        [cell.adImageView sd_setImageWithURL:imageUrl];
        return cell;
    }
    else if (collectionView.tag ==2) {
        self.oneRecreationModel = self.recreationModel.recreation[indexPath.row];
        
        
        MainItemCell *cell = (MainItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"mainCell" forIndexPath:indexPath];
        [cell.storeImageView sd_setImageWithURL:self.oneRecreationModel.pho_url];
        cell.storNameLabel.text = self.oneRecreationModel.name;
        cell.distanceLabel.text = [NSString stringWithFormat:@"%f公里",self.oneRecreationModel.distance];
        cell.numOfCommentLabel.text = [NSString stringWithFormat:@"%d条评论",self.oneRecreationModel.time];
        cell.typeLabel.text = self.oneRecreationModel.classify;
            cell.storNameLabel.textColor = RGB(75, 173, 96);
            cell.numOfCommentLabel.textColor = RGB(75, 173, 96);
            cell.typeLabel.textColor = RGB(75, 173, 96);

        return cell;
    }
    else {
        self.oneRecreationModel = self.foodModel.food[indexPath.row];
        MainItemCell *cell = (MainItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"relaxCell" forIndexPath:indexPath];
        [cell.storeImageView sd_setImageWithURL:self.oneRecreationModel.pho_url];
        cell.storNameLabel.text = self.oneRecreationModel.name;
        cell.distanceLabel.text = [NSString stringWithFormat:@"%f公里",self.oneRecreationModel.distance];
        cell.numOfCommentLabel.text = [NSString stringWithFormat:@"%d条评论",self.oneRecreationModel.time];
        cell.typeLabel.text = self.oneRecreationModel.classify;
        cell.storNameLabel.textColor = RGB(84, 123, 199);
        cell.numOfCommentLabel.textColor = RGB(84, 123, 199);
        cell.typeLabel.textColor = RGB(84, 123, 199);
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 2 || collectionView.tag == 3) {
        MainItemCell *cell = (MainItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        FoodDetailVC *detailVC = [[FoodDetailVC alloc] init];
        detailVC.storeString = cell.storNameLabel.text;
        detailVC.topImage = cell.storeImageView.image;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

/**
 * Section中每个Cell的上下边距
 */
- (CGFloat)collectionView: (UICollectionView *)collectionView layout: (UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex: (NSInteger)section{
    if (collectionView.tag == 2 || collectionView.tag == 3)
    {
        return 20.0f;
    }
    return 15.0f;
}


//Asks the delegate for the margins to apply to content in the specified section.安排初始位置
//使前后项都能居中显示
- (UIEdgeInsets)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView.tag == 0) {
    NSInteger itemCount = [self collectionView:collectionView numberOfItemsInSection:section];
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    CGSize firstSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:firstIndexPath];
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:itemCount - 1 inSection:section];
    CGSize lastSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:lastIndexPath];
    return UIEdgeInsetsMake(0, (collectionView.bounds.size.width - firstSize.width) / 2,
                            0, (collectionView.bounds.size.width - lastSize.width) / 2);
    }
    else {
        return UIEdgeInsetsMake(0,10,0,10);
    }
}

@end