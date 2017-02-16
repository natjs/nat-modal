//
//  WXToast.h
//
//  Created by huangyake on 17/1/7.
//  Copyright © 2017 Nat. All rights reserved.
//

#import <UIKit/UIKit.h>
#define DEFAULT_DISPLAY_DURATION 2.0f

@interface WXToast : UIView
@property(nonatomic, strong)NSString *text;
@property(nonatomic, strong)UIView *contentView;
@property(nonatomic, assign)CGFloat duration;
//初始化
- (instancetype)initWithText:(NSString *)text ;
//关闭
- (void)dismissToast;
//隐藏
- (void)hideAnimation;
//显示
- (void)showinView:(UIView *)view;

@end
