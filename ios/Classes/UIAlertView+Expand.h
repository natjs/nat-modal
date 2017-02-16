//
//  UIAlertView+Expand.h
//  jike
//
//  Created by tauCross on 16/3/31.
//  Copyright © 2016年 tauCross. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertViewCompleteBlock) (NSInteger buttonIndex, UIAlertView *alertView);

@interface UIAlertView (Expand)

- (void)showAlertViewWithCompleteBlock:(AlertViewCompleteBlock)block;

@end
