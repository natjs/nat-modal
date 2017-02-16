//
//  NatModal.h
//
//  Created by huangyake on 17/1/7.
//  Copyright © 2017 Nat. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NatModal : NSObject

typedef void (^NatCallback)(id error, id result);

+ (NatModal *)singletonManger;
//alert 提示
- (void)alert:(NSDictionary *)params :(NatCallback)back;
// confirm
- (void)confirm:(NSDictionary *)params :(NatCallback)back;
// 带输入框的提示
- (void)prompt:(NSDictionary *)params :(NatCallback)back;
// 无操作的提示
- (void)toast:(NSDictionary *)params :(NatCallback)back;

@end
