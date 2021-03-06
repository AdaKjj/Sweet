//
//  RightTableViewCell.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import "RightTableViewCell.h"
#import "CategoryModel.h"
#import "UIControl+hitTest.h"
#import "OSSManager.h"
@interface RightTableViewCell ()

@end

@implementation RightTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
        [self.contentView addSubview:self.imageV];

        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(82, 5, 200, 20)];
        self.nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.nameLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(82, 50, 100, 20)];
        self.priceLabel.font = [UIFont systemFontOfSize:14];
        self.priceLabel.textColor = RGB(158, 202, 35);
        [self.contentView addSubview:self.priceLabel];
        
        self.commentLabel = [[UILabel alloc] init];
        self.commentLabel.text = @"评论数：500";
        self.commentLabel.font = systemFont(11);
        self.commentLabel.textColor = RGB(215, 215, 215);
        [self.contentView addSubview:self.commentLabel];
        [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).inset(5);
            make.left.equalTo(self.nameLabel.mas_left);
            make.width.equalTo(100);
            make.height.equalTo(15);
        }];
        
        
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.layer.masksToBounds = YES;
        _addBtn.layer.cornerRadius = 10;
        _addBtn.layer.borderColor = [UIColor blackColor].CGColor;
        self.addBtn.layer.borderWidth = 1.0f;
        _addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _addBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_addBtn addTarget:self action:@selector(clickPuls:) forControlEvents:UIControlEventTouchUpInside];
        [self.addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.addBtn setTitle:@"+" forState:UIControlStateNormal];
        [self.contentView addSubview:self.addBtn];
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(260);
            make.bottom.equalTo(self.priceLabel.mas_bottom);
            make.height.equalTo(20);
            make.width.equalTo(20);
        }];
        [_addBtn setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
        
        _countt = 0;
        
        _countLabel = [[UILabel alloc] init];
        self.countLabel.text = [NSString stringWithFormat:@"%d",_countt];
        self.countLabel.textAlignment = NSTextAlignmentCenter;
        self.countLabel.font = systemFont(14);
        [self.contentView addSubview:self.countLabel];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_addBtn.mas_top);
            make.right.equalTo(_addBtn.mas_left).inset(4);
            make.width.equalTo(30);
            make.height.equalTo(20);
        }];
        
        _minBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _minBtn.layer.masksToBounds = YES;
        _minBtn.layer.cornerRadius = 10;
        _minBtn.layer.borderColor = [UIColor blackColor].CGColor;
        self.minBtn.layer.borderWidth = 1.0f;
        _minBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _minBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_minBtn addTarget:self action:@selector(clickMin:) forControlEvents:UIControlEventTouchUpInside];
        [self.minBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.minBtn setTitle:@"-" forState:UIControlStateNormal];
        [self.contentView addSubview:self.minBtn];
        [self.minBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_countLabel.mas_left).inset(4);
            make.bottom.equalTo(self.priceLabel.mas_bottom);
            make.height.equalTo(20);
            make.width.equalTo(20);
        }];
        [_minBtn setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    }
    return self;
}

- (void)setModel:(ItemModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f",model.univalence];
    self.imageV.image = [UIImage imageWithData:model.photoData];
    self.countLabel.text = [NSString stringWithFormat:@"%d",[model.count intValue]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _countt = [self.model.count intValue];
    _countLabel.text = [NSString stringWithFormat:@"%d",_countt];
}

- (void)clickPuls:(UIButton *)btn
{
    _countt++;
    self.countLabel.text = [NSString stringWithFormat:@"%d",_countt];
    self.operationBlock(self.countt,YES);
}
- (void)clickMin:(UIButton *)btn
{
    if (_countt > 0) {
        _countt--;
        self.countLabel.text = [NSString stringWithFormat:@"%d",_countt];
        self.operationBlock(self.countt,NO);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
