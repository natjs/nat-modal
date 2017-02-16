//
//  WXToast.m
//
//  Created by huangyake on 17/1/7.
//  Copyright © 2017 Nat. All rights reserved.
//

#import "WXToast.h"
@interface WXToast ()


@end

@implementation WXToast
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
}

- (id)initWithParams:(NSDictionary *)params{
    if (self == [super init]) {
        CGFloat padding = 30;
//        CGRect rect = [[UIScreen mainScreen] bounds];
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding/2, padding/2, 230, 30)];
        messageLabel.numberOfLines =  0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.text = params[@"msg"];
        messageLabel.font = [UIFont boldSystemFontOfSize:14];
        messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        [messageLabel sizeToFit];
        CGFloat height = [WXToast customAutoHeigh:params[@"msg"] width:230 num:14];
        if (height<14) {
            height = 14;
        }

        _contentView = [[UIButton alloc] initWithFrame:CGRectMake(32, 0, messageLabel.frame.size.width+40, height+28)];
        _contentView.layer.cornerRadius = 22.0f;
        _contentView.layer.masksToBounds = YES;
    
        _contentView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.9];
        [_contentView addSubview:messageLabel];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _contentView.alpha = 0.0f;
        
        _duration = DEFAULT_DISPLAY_DURATION;

    }
    
    return self;
}

- (id)initWithText:(NSString *)text{
    if (self = [super init]) {
        
        _text = [text copy];
        
        UIFont *font = [UIFont boldSystemFontOfSize:14];
        CGRect rect = [[UIScreen mainScreen] bounds];
        CGFloat height = [WXToast customAutoHeigh:text width:rect.size.width-104 num:14];
        if (height<14) {
            height = 14;
        }
        
          UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, rect.size.width-64-40, height)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = font;
        textLabel.text = text;
        textLabel.numberOfLines = 0;
        textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [textLabel sizeToFit];
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(32, 0, textLabel.frame.size.width+40, height+28)];
        _contentView.layer.cornerRadius = 24.0f;
        _contentView.layer.masksToBounds = YES;
        _contentView.userInteractionEnabled = NO;
        _contentView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.9];
        [_contentView addSubview:textLabel];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _contentView.alpha = 0.0f;
        
        _duration = DEFAULT_DISPLAY_DURATION;
        
    }
    return self;
}

- (void)dismissToast
{
    [_contentView removeFromSuperview];
}

- (void)hideAnimation
{
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self dismissToast];
    }];
}
+ (CGFloat)autoWidth:(NSString *)nameString width:(CGFloat)width height:(CGFloat)height num:(CGFloat)num
{
    CGSize size = CGSizeMake(width, height);
    CGRect  labelSize = [nameString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    return  labelSize.size.width;
    
}

- (void)showinView:(UIView *)view
{
    _contentView.center = CGPointMake(view.center.x, _contentView.center.y);
    [view addSubview:_contentView];
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.alpha = 1.0;
    }];
}
+ (CGFloat)customAutoHeigh:(NSString *)contentString width:(CGFloat)width num:(CGFloat)num
{
    CGRect rect = [contentString boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    return rect.size.height;
}
@end
