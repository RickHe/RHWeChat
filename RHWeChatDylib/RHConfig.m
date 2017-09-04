//
//  RHConfig.m
//  RHWeChat
//
//  Created by hmy2015 on 2017/9/4.
//  Copyright © 2017年 何米颖大天才. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHConfig.h"

#define kRHUserDefaults [NSUserDefaults standardUserDefaults]
#define kRHAutoGrapEnvKey @"RHAutoGrapEnvKey"

@implementation RHConfig

+ (instancetype)sharedConfig {
    static dispatch_once_t onceToken;
    static RHConfig *_instance;
    dispatch_once(&onceToken, ^{
        _instance = [RHConfig new];
    });
    return _instance;
}

- (BOOL)isAutoGrapEnv {
    return [kRHUserDefaults boolForKey:kRHAutoGrapEnvKey];
}

- (void)setAutoGrapEnv:(BOOL)autoGrapEnv {
    [kRHUserDefaults setBool:autoGrapEnv forKey:kRHAutoGrapEnvKey];
    [kRHUserDefaults synchronize];
}

- (void)autoGrabEnvSwitchAction:(UISwitch *)autoGrabEnv {
    self.autoGrapEnv = autoGrabEnv.isOn;
}

@end
