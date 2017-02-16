//
//  NatModal.m
//
//  Created by huangyake on 17/1/7.
//  Copyright © 2017 Nat. All rights reserved.
//

#import "NatModal.h"
#import "UIAlertView+Expand.h"
#import "WXToast.h"

@implementation NatModal

+ (NatModal *)singletonManger{
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)alert:(NSDictionary *)params :(NatCallback)back{
    
    NSString *okButton = @"OK";
    if (params[@"okButton"]) {
        okButton= params[@"okButton"];
    }
    
    [[[UIAlertView alloc] initWithTitle:params[@"title"] message:params[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:okButton, nil] showAlertViewWithCompleteBlock:^(NSInteger buttonIndex, UIAlertView *alertView) {
        back(nil,nil);
    }];
}

- (void)confirm:(NSDictionary *)params :(NatCallback)back{
    NSString *okButton = @"OK";
    NSString *cancel = @"Cancel";
    if (params[@"okButton"]) {
        okButton= params[@"okButton"];
    }
    if (params[@"cancelButton"]) {
        cancel = params[@"cancelButton"];
    }
    
    [[[UIAlertView alloc] initWithTitle:params[@"title"] message:params[@"message"] delegate:self cancelButtonTitle:cancel otherButtonTitles:okButton, nil] showAlertViewWithCompleteBlock:^(NSInteger buttonIndex, UIAlertView *alertView) {
        if (buttonIndex == 0) {
            back(nil,@0);
        }else{
            back(nil,@1);
        }
    }];
}

- (void)prompt:(NSDictionary *)params :(NatCallback)back{
    NSString *okButton = @"OK";
    NSString *cancel = @"Cancel";
    if (params[@"okButton"]) {
        okButton= params[@"okButton"];
    }
    if (params[@"cancelButton"]) {
        cancel = params[@"cancelButton"];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:params[@"title"] message:params[@"message"] delegate:self cancelButtonTitle:cancel otherButtonTitles:okButton,nil];
    alert.alertViewStyle  = UIAlertViewStylePlainTextInput;
    UITextField *tf=[alert textFieldAtIndex:0];
    tf.text = params[@"text"];
    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex, UIAlertView *alertView) {
        if (buttonIndex == 0) {
            back(nil,@{@"result":@0,@"data":tf.text});
        }else{
           back(nil,@{@"result":@1,@"data":tf.text});
        }
    }];
}


- (void)toast:(NSDictionary *)params :(NatCallback)back{
    UIView *vcView = [[self getCurrentVC] view];
    WXToast *toast = [[WXToast alloc] initWithText:params[@"message"]];
    int time = [params[@"duration"] intValue];
    int64_t second = time / 1000;
    CGFloat width = [NatModal autoWidth:params[@"message"] width:0 height:14 num:14] ;
    
    if (width >  vcView.frame.size.width-64-40) {
        width =  vcView.frame.size.width-64;
    }else{
        width = width + 40;
    }
    if (params[@"position"]) {
        if ([params[@"position"] isEqual:@"top"]) {
            toast.contentView.center = CGPointMake(vcView.frame.size.width/2, toast.contentView.frame.size.height + 55);
        }else if([params[@"position"] isEqual:@"middle"]){
            toast.contentView.center = vcView.center;
        }else{
            toast.contentView.center = CGPointMake(vcView.frame.size.width/2, vcView.frame.size.height-48-toast.contentView.frame.size.height/2);
        }
    }else{
        toast.contentView.center = CGPointMake(vcView.frame.size.width/2, vcView.frame.size.height-48-toast.contentView.frame.size.height/2);
         
        
    }
    
    
    [toast showinView:vcView];
    back(nil,nil);
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [toast hideAnimation];
    });
}

+ (CGFloat)customAutoHeigh:(NSString *)contentString width:(CGFloat)width num:(CGFloat)num
{
    CGRect rect = [contentString boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    return rect.size.height;
}
+ (CGFloat)autoWidth:(NSString *)nameString width:(CGFloat)width height:(CGFloat)height num:(CGFloat)num
{
    CGSize size = CGSizeMake(width, height);
    CGRect  labelSize = [nameString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    return  labelSize.size.width;
    
}

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}


@end
