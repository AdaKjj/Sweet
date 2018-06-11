//
//  TopicVC.m
//  SweetProj
//
//  Created by 殷婕 on 2017/11/29.
//  Copyright © 2017年 AdaKjj. All rights reserved.
//

#import "TopicVC.h"
#import "UIImage+Addition.h"
#import "TopicTableViewCell.h"
#import "UIButton+EdgeInsets.h"
#import "TopicItemCell.h"
#import "CircleModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CircleManager.h"
#import <YYLabel.h>
#import "LoginVC.h"
#import "XWScanImage.h"

#define UIScreenWidth   [UIScreen mainScreen].bounds.size.width
#define UIScreenHeight  [UIScreen mainScreen].bounds.size.height
#define LayoutWidth     (UIScreenWidth - margin*2 - 40 - 8*2 - 10)

@interface TopicVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) UIButton *addTopicBtn;
@property (nonatomic) UIImageView *lineImageView;
//@property (nonatomic) UIImageView *circleBgImageView;
//@property (nonatomic) UIImageView *circleDetailImageView;

@property (nonatomic) UIButton *friendsBtn;
@property (nonatomic) UIButton *todayBtn;
@property (nonatomic) UIButton *circleBtn;

@property (nonatomic) UITableView *photoTableView;

@property (nonatomic) int textHeight;

@end

static CGFloat margin = 20.f;

@implementation TopicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSearchBar];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _addTopicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  //  [_addTopicBtn setTitle:@"发布" forState:UIControlStateNormal];
    [_addTopicBtn setImage:[UIImage imageNamed:@"头像"] forState:UIControlStateNormal];
   // [_addTopicBtn addTarget:self action:@selector(onTouchAddTopic) forControlEvents:UIControlEventTouchUpInside];
    [_addTopicBtn setTitleColor:SYSTEMCOLOR forState:UIControlStateNormal];
    [_addTopicBtn.titleLabel setFont:systemFont(14)];
    _addTopicBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _addTopicBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    _addTopicBtn.layer.masksToBounds = YES;
    _addTopicBtn.layer.cornerRadius = 22;
   // [_addTopicBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageTop imageTitlespace:3];
    [self.view addSubview:_addTopicBtn];
    [_addTopicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-25);
        make.top.equalTo(25);
        make.height.width.equalTo(44);
    }];
    
//    // 添加边框
//    CALayer * layer = [_avatarImageView layer];
//    layer.borderColor = RGB(173, 173, 173).CGColor;
//    layer.borderWidth = 2.0f;
    
    _friendsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _friendsBtn.selected = YES;
    _friendsBtn.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    [_friendsBtn setTitle:@"朋友" forState:UIControlStateNormal];
    [_friendsBtn.titleLabel setFont:systemFont(20)];
    [_friendsBtn setTitleColor:RGB(173, 173, 173) forState:UIControlStateNormal];
    [_friendsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_friendsBtn addTarget:self action:@selector(friendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_friendsBtn];
    [_friendsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(30);
        make.left.equalTo(25);
        make.width.equalTo(40);
        make.height.equalTo(25);
    }];
    
    _todayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _todayBtn.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    [_todayBtn setTitle:@"今日" forState:UIControlStateNormal];
    [_todayBtn.titleLabel setFont:systemFont(20)];
    [_todayBtn setTitleColor:RGB(173, 173, 173) forState:UIControlStateNormal];
    [_todayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_todayBtn addTarget:self action:@selector(todayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_todayBtn];
    [_todayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(30);
        make.left.equalTo(_friendsBtn.mas_right).inset(15);
        make.width.equalTo(40);
        make.height.equalTo(25);
    }];
    
    _circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _circleBtn.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    [_circleBtn setTitle:@"广场" forState:UIControlStateNormal];
    [_circleBtn.titleLabel setFont:systemFont(20)];
    [_circleBtn setTitleColor:RGB(173, 173, 173) forState:UIControlStateNormal];
    [_circleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_circleBtn addTarget:self action:@selector(circleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_circleBtn];
    [_circleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(30);
        make.left.equalTo(_todayBtn.mas_right).equalTo(15);
        make.width.equalTo(40);
        make.height.equalTo(25);
    }];
    
    UIImage *lingImage = [UIImage imageWithColor:RGB(173, 173, 173) size:CGSizeMake(SCREEN_WIDTH - 50, 3.0)];
    UIImageView *_lineImageView = [[UIImageView alloc]initWithImage:lingImage];
    [self.view addSubview:_lineImageView];
    [_lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addTopicBtn.mas_bottom).equalTo(10);
        make.left.equalTo(20);
        make.height.equalTo(3);
        make.width.equalTo(SCREEN_WIDTH - 40);
    }];
    
    self.photoTableView = [[UITableView alloc] init];
    self.photoTableView.dataSource = self;
    self.photoTableView.delegate = self;
    self.photoTableView.tableHeaderView = nil;
    [self.photoTableView registerClass:[TopicItemCell class] forCellReuseIdentifier:@"TopicCell"];
    [self.photoTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //[self.view addSubview: self.photoTableView];
//    [self.photoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_lineImageView.mas_bottom);
//        make.left.right.equalTo(0);
//        make.bottom.equalTo(0);
//    }];
    
    CircleManager *manager = [CircleManager new];
    manager.type = @"朋友";
    manager.start = @"0";
    manager.topicVC = self;
    [manager sendRequestWithType:@"朋友" andStart:@"0"];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    if (![USERDEFAULTS objectForKey:@"Session"]) {
        LoginVC *loginVC = [[LoginVC alloc] init];
        loginVC.isFromCircle = YES;
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (void)friendBtnClick:(id)sender {
    _friendsBtn.selected = YES;
    _todayBtn.selected = NO;
    _circleBtn.selected = NO;
    
    CircleManager *manager = [CircleManager new];
    manager.type = @"朋友";
    manager.start = @"0";
    manager.topicVC = self;
    [manager sendRequestWithType:@"朋友" andStart:@"0"];
}

- (void)todayBtnClick {
    _friendsBtn.selected = NO;
    _todayBtn.selected = YES;
    _circleBtn.selected = NO;
    CircleManager *manager = [CircleManager new];
    manager.type = @"今日";
    manager.start = @"0";
    manager.topicVC = self;
    [manager sendRequestWithType:@"今日" andStart:@"0"];
}

- (void)circleBtnClick {
    _friendsBtn.selected = NO;
    _todayBtn.selected = NO;
    _circleBtn.selected = YES;
    CircleManager *manager = [CircleManager new];
    manager.type = @"广场";
    manager.start = @"0";
    manager.topicVC = self;
    [manager sendRequestWithType:@"广场" andStart:@"0"];
}

- (void)getCircleArr:(NSDictionary *)jsonDic {
    self.circleArr = [[CircleModel alloc] initWithDictionary:jsonDic error:nil];
    
    if (!self.photoTableView) {
        self.photoTableView = [[UITableView alloc] init];
        self.photoTableView.dataSource = self;
        self.photoTableView.delegate = self;
        self.photoTableView.tableHeaderView = nil;
        [self.photoTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//        [self.view addSubview: self.photoTableView];
//        [self.photoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_lineImageView.mas_bottom);
//            make.left.right.equalTo(0);
//            make.bottom.equalTo(0);
//        }];
    }
    else {
        [self.photoTableView reloadData];
    }

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

#pragma mark -  tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.circleArr.circleList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicCell"];
    
    if (!cell) {
        cell = [[TopicItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TopicCell"];
        cell.circleItem = self.circleArr.circleList[indexPath.row];
        [cell setCircleItem:self.circleArr.circleList[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleItem *item = self.circleArr.circleList[indexPath.row];
    YYTextContainer *container2 = [YYTextContainer containerWithSize:CGSizeMake(LayoutWidth, CGFLOAT_MAX)];
    
    NSMutableAttributedString *attributeString2 = [[NSMutableAttributedString alloc] initWithString:item.content attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:__RGB_75,NSKernAttributeName:@1.5f}];
    
    NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle2 setLineSpacing:5.0];
    [attributeString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [item.content length])];
    
    YYTextLayout *layout2 = [YYTextLayout layoutWithContainer:container2 text:attributeString2];
    
    CGFloat contentHeight = layout2.textBoundingSize.height;
    
    CGFloat collectionHeight = 0;
    
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    CGFloat numberInLine = floor((item.photoUrl.count - 1)/3.0) + 1;
    CGFloat numberInRow = 0.0;
    switch (item.photoUrl.count) {
        case 1:numberInRow = 1;
            break;
        case 2:numberInRow = 2;
            break;
        case 3:numberInRow = 3;
            break;
        case 4:numberInRow = 2;
            break;
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:numberInRow = 3;
            break;
        default:
            break;
    }
    
    CGFloat itemWidth;
    if (item.photoUrl.count == 1)
        itemWidth = LayoutWidth - edgeInset.left - edgeInset.right;
    else
        itemWidth = (LayoutWidth - edgeInset.left - edgeInset.right - (numberInRow-1)*4)/numberInRow;
    
    collectionHeight = floor(itemWidth + edgeInset.top + edgeInset.bottom + (numberInLine -1)*4);
    
    DLog(@"高度是%f和%f",contentHeight, collectionHeight);
    
    return contentHeight + collectionHeight + 100 + 18;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

@end
