//
//  LoginVC.h
//  SweetProj
//
//  Created by 殷婕 on 2017/11/21.
//  Copyright © 2017年 AdaKjj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController

@property (nonatomic) BOOL isFromCircle;
- (void)receiveLoginRequest:(NSString *)requestResult;

@end


