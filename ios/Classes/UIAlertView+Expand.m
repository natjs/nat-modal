//
//  UIAlertView+Expand.m
//  jike
//
//  Created by tauCross on 16/3/31.
//  Copyright © 2016年 tauCross. All rights reserved.
//

#import "UIAlertView+Expand.h"

#import <objc/runtime.h>

static char alert_view_complete_block_key;

@implementation UIAlertView (Expand)

- (void)showAlertViewWithCompleteBlock:(AlertViewCompleteBlock)block
{
    if(block)
    {
        objc_removeAssociatedObjects(self);
        objc_setAssociatedObject(self, &alert_view_complete_block_key, block, OBJC_ASSOCIATION_COPY);
        self.delegate = self;
    }
    [self show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AlertViewCompleteBlock block = objc_getAssociatedObject(self, &alert_view_complete_block_key);
    if(block)
    {
        block(buttonIndex, alertView);
    }
}

@end

