//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  RHWeChatDylib.m
//  RHWeChatDylib
//
//  Created by hmy2015 on 2017/8/29.
//  Copyright (c) 2017年 何米颖. All rights reserved.
//

#import "RHWeChatDylib.h"
#import "CaptainHook.h"
#import <UIKit/UIKit.h>
#import <Cycript/Cycript.h>
#import "RHConfig.h"
#import "RHSafety.h"

#define RHParamKey @"RHParamKey"
#define RHIsAutoOpenKey @"RHIsAutoOpenKey"
#define RHUserDefaults [NSUserDefaults standardUserDefaults]


CHDeclareClass(MMTableViewInfo);
CHDeclareClass(MMTableView);
CHDeclareClass(MMTableViewCellInfo);
CHDeclareClass(MMTableViewSectionInfo);


static __attribute__((constructor)) void entry(){
    NSLog(@"\n               🎉!!！congratulations!!！🎉\n👍----------------insert dylib success----------------👍");
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        CYListenServer(6666);
    }];
}

#pragma mark - CMessageMgr
CHDeclareClass(CMessageMgr);

CHMethod(2, void, CMessageMgr, AsyncOnAddMsg, id, arg1, MsgWrap, id, arg2) {
    CHSuper(2, CMessageMgr, AsyncOnAddMsg, arg1, MsgWrap, arg2);

    NSUInteger m_uiMessageType = [arg2 m_uiMessageType];
    
    id m_nsFromUsr = [arg2 m_nsFromUsr];
    id m_nsContent = [arg2 m_nsContent];
    
    switch(m_uiMessageType) {
        case 49: {
            id logicMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("WCRedEnvelopesLogicMgr")];
            id contactManager =[[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("CContactMgr")];
            id selfContact = [contactManager getSelfContact];
            id m_nsUsrName = [selfContact m_nsUsrName];
            
            if ([m_nsFromUsr isEqualToString:m_nsUsrName]) {
                return;
            }
           
            if ([m_nsContent rangeOfString:@"wxpay://"].location != NSNotFound) {
                if (!kRHConfig.isAutoGrapEnv) {
                    return;
                }
                
                NSString *nativeUrl = m_nsContent;
                NSRange rangeStart = [m_nsContent rangeOfString:@"wxpay://c2cbizmessagehandler/hongbao"];
                if (rangeStart.location != NSNotFound) {
                    NSUInteger locationStart = rangeStart.location;
                    nativeUrl = [nativeUrl substringFromIndex:locationStart];
                }
                
                NSRange rangeEnd = [nativeUrl rangeOfString:@"]]"];
                if (rangeEnd.location != NSNotFound) {
                    NSUInteger locationEnd = rangeEnd.location;
                    nativeUrl = [nativeUrl substringToIndex:locationEnd];
                }
                
                NSString *naUrl = [nativeUrl substringFromIndex:[@"wxpay://c2cbizmessagehandler/hongbao/receivehongbao?" length]];
                
                NSArray *parameterPairs =[naUrl componentsSeparatedByString:@"&"];
                
                NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:[parameterPairs count]];
                for (NSString *currentPair in parameterPairs) {
                    NSRange range = [currentPair rangeOfString:@"="];
                    if(range.location == NSNotFound)
                        continue;
                    NSString *key = [currentPair substringToIndex:range.location];
                    NSString *value =[currentPair substringFromIndex:range.location + 1];
                    [parameters SafetySetObject:value forKey:key];
                }
                
                //红包参数
                NSMutableDictionary *params = [@{} mutableCopy];
                
                [params SafetySetObject:parameters[@"msgtype"] forKey:@"msgType"];
                [params SafetySetObject:parameters[@"sendid"] forKey:@"sendId"];
                [params SafetySetObject:parameters[@"channelid"] forKey:@"channelId"];
                
                id getContactDisplayName = [selfContact getContactDisplayName];
                id m_nsHeadImgUrl = [selfContact m_nsHeadImgUrl];
                
                [params SafetySetObject:getContactDisplayName forKey:@"nickName"];
                [params SafetySetObject:m_nsHeadImgUrl forKey:@"headImg"];
                [params SafetySetObject:[NSString stringWithFormat:@"%@", nativeUrl] forKey:@"nativeUrl"];
                [params SafetySetObject:m_nsFromUsr forKey:@"sessionUserName"];
                
                [RHUserDefaults setObject:params forKey:RHParamKey];
                
                NSMutableDictionary* dictParam = [NSMutableDictionary dictionary];
                /*    
                 agreeDuty = 0;
                 channelId = 1;
                 inWay = 1;
                 msgType = 1;
                 nativeUrl = "wxpay://c2cbizmessagehandler/hongbao/receivehongbao?msgtype=1&channelid=1&sendid=1000039501201709047019673006344&sendusername=ljl4323108&ver=6&sign=99690d3a66ff93739b339d1e1fc71ec12f026f3e34a0806aec19f05f6ab09c9604e4a5a63eef95b25b87cff49fa5bd0d87e46e8a35eca8189fc1020479fc23ad04c00ab0ca78ede59440ed8c63da189b60df7e8f9c7795ca43d1a78410f4ab47";
                 wxpay://c2cbizmessagehandler/hongbao/receivehongbao?msgtype=1&channelid=1&sendid=1000039501201709047018482497054&sendusername=ljl4323108&ver=6&sign=4bee27fc5aeec1399701f05959a48100fbd01fb263d295dd29e13129b8d94c8939232ee668a1e68bf164ee9bead0f4ff14001333427f3a653519efa1578d6f74b7ee48ba20034727fb1c64105b91153c0891f0f29c979437c46f9e9b289a14a8
                 sendId = 1000039501201709047019673006344;
                 */
                [dictParam SafetySetObject:@"0" forKey:@"agreeDuty"];                                             //agreeDuty
                [dictParam SafetySetObject:parameters[@"channelid"] forKey:@"channelId"];        //channelId
                [dictParam SafetySetObject:@"1" forKey:@"inWay"];                                                 //inWay
                [dictParam SafetySetObject:parameters[@"msgtype"] forKey:@"msgType"];            //msgType
                [dictParam SafetySetObject:nativeUrl forKey:@"nativeUrl"];                                     //nativeUrl
                [dictParam SafetySetObject:parameters[@"sendid"] forKey:@"sendId"];              //sendId
                
                NSLog(@"dictParam=%@", dictParam);
                ((void (*)(id, SEL, NSMutableDictionary*))objc_msgSend)(logicMgr, @selector(ReceiverQueryRedEnvelopesRequest:), dictParam);
                
                return;
            }
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - WCRedEnvelopesLogicMgr

CHDeclareClass(WCRedEnvelopesLogicMgr);

CHOptimizedMethod1(self, void, WCRedEnvelopesLogicMgr, OpenRedEnvelopesRequest, id, arg1) {
    NSLog(@"%@", arg1);
    CHSuper1(WCRedEnvelopesLogicMgr, OpenRedEnvelopesRequest, arg1);
}

CHOptimizedMethod1(self, void, WCRedEnvelopesLogicMgr, ReceiverQueryRedEnvelopesRequest, id, arg1) {
    CHSuper1(WCRedEnvelopesLogicMgr, ReceiverQueryRedEnvelopesRequest, arg1);
}

CHOptimizedMethod2(self, void, WCRedEnvelopesLogicMgr, OnWCToHongbaoCommonResponse, id, arg1, Request, id, arg2) {
    NSLog(@"%@", arg1);
    NSLog(@"%@", arg2);
    /*
     <HongBaoRes: 0x1123400f0>
     <HongBaoReq: 0x1123805f0>
     */
    
    CHSuper2(WCRedEnvelopesLogicMgr, OnWCToHongbaoCommonResponse, arg1, Request, arg2);
    
    if ([RHUserDefaults boolForKey:RHIsAutoOpenKey]) {
        if ([NSStringFromClass([arg1 class]) isEqualToString:@"HongBaoRes"]) {
            NSData *data = [[arg1 retText] buffer];
            
            if (nil != data && 0 < [data length]) {
                NSError* error = nil;
                id jsonObj = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
                if (nil != error) {
                    NSLog(@"error %@", [error localizedDescription]);
                }
                else if (nil != jsonObj)
                {
                    if ([NSJSONSerialization isValidJSONObject:jsonObj]) {
                        if ([jsonObj isKindOfClass:[NSDictionary class]]) {
                            id idTemp = jsonObj[@"timingIdentifier"];
                            if (idTemp) {
                                NSMutableDictionary *params = [[RHUserDefaults objectForKey:RHParamKey] mutableCopy];
                                [RHUserDefaults setObject:[NSMutableDictionary dictionary] forKey:RHParamKey];
                                [params SafetySetObject:idTemp forKey:@"timingIdentifier"]; // "timingIdentifier"字段
                                
                                // 防止重复请求
                                if (params.allKeys.count < 2) {
                                    return;
                                }
                                
                                id logicMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("WCRedEnvelopesLogicMgr")];
                                
                                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
                                dispatch_after(delayTime, dispatch_get_main_queue(), ^(void) {
                                    ((void (*)(id, SEL, NSMutableDictionary*))objc_msgSend)(logicMgr, @selector(OpenRedEnvelopesRequest:), params);
                                });
                            }
                        }
                    }
                }
            }
        }
    }
}

#pragma mark - NewSettingViewController
CHDeclareClass(NewSettingViewController)

CHOptimizedMethod0(self, void, NewSettingViewController, reloadTableData) {
    CHSuper0(NewSettingViewController, reloadTableData);
    MMTableViewInfo *tableInfo = [self valueForKey:@"m_tableViewInfo"];
    MMTableViewSectionInfo *sectionInfo = [objc_getClass("MMTableViewSectionInfo") sectionInfoDefaut];
    
    MMTableViewCellInfo *autoGrapRedEnvCellInfo = [objc_getClass("MMTableViewCellInfo") switchCellForSel:@selector(autoGrabEnvSwitchAction:)
                                                                                 target:kRHConfig
                                                                                  title:@"自动抢红包"
                                                                                     on:kRHConfig.isAutoGrapEnv];
    [sectionInfo addCell:autoGrapRedEnvCellInfo];
    
    [tableInfo insertSection:sectionInfo At:0];
    MMTableView *tableView = [tableInfo getTableView];
    [tableView reloadData];
}

#pragma mark - CHConstructor

CHConstructor{
    CHLoadLateClass(CMessageMgr);
    CHClassHook(2, CMessageMgr, AsyncOnAddMsg, MsgWrap);
    
    CHLoadLateClass(WCRedEnvelopesLogicMgr);
    CHClassHook2(WCRedEnvelopesLogicMgr, OnWCToHongbaoCommonResponse, Request);
    CHClassHook1(WCRedEnvelopesLogicMgr, ReceiverQueryRedEnvelopesRequest);
    CHClassHook1(WCRedEnvelopesLogicMgr, OpenRedEnvelopesRequest);
    
    CHLoadLateClass(NewSettingViewController);
    CHClassHook0(NewSettingViewController, reloadTableData);
    
    CHLoadLateClass(MMTableViewInfo);
    CHLoadLateClass(MMTableView);
    CHLoadLateClass(MMTableViewCellInfo);
    CHLoadLateClass(MMTableViewSectionInfo);
}

