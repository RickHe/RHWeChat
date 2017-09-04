//
//  RHConfig.h
//  RHWeChat
//
//  Created by hmy2015 on 2017/9/4.
//  Copyright © 2017年 何米颖大天才. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRHConfig [RHConfig sharedConfig]

@interface RHConfig : NSObject

+ (instancetype)sharedConfig;

@property (nonatomic, getter = isAutoGrapEnv) BOOL autoGrapEnv;

- (void)autoGrabEnvSwitchAction:(UISwitch *)autoGrabEnv;

@end
