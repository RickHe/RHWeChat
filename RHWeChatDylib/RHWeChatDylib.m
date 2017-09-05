//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  RHWeChatDylib.m
//  RHWeChatDylib
//
//  Created by hmy2015 on 2017/8/29.
//  Copyright (c) 2017年 何米颖大天才. All rights reserved.
//

#import "RHWeChatDylib.h"
#import "CaptainHook.h"
#import <UIKit/UIKit.h>
#import <Cycript/Cycript.h>
#import "RHConfig.h"

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

CHMethod(2, void, CMessageMgr, AsyncOnAddMsg, id, arg1, MsgWrap, id, arg2)
{
    CHSuper(2, CMessageMgr, AsyncOnAddMsg, arg1, MsgWrap, arg2);
    Ivar uiMessageTypeIvar = class_getInstanceVariable(objc_getClass("CMessageWrap"), "m_uiMessageType");
    ptrdiff_t offset = ivar_getOffset(uiMessageTypeIvar);
    unsigned char *stuffBytes = (unsigned char *)(__bridge void *)arg2;
    NSUInteger m_uiMessageType = * ((NSUInteger *)(stuffBytes + offset));
    
    Ivar nsFromUsrIvar = class_getInstanceVariable(objc_getClass("CMessageWrap"), "m_nsFromUsr");
    id m_nsFromUsr = object_getIvar(arg2, nsFromUsrIvar);
    
    Ivar nsContentIvar = class_getInstanceVariable(objc_getClass("CMessageWrap"), "m_nsContent");
    id m_nsContent = object_getIvar(arg2, nsContentIvar);
    
    switch(m_uiMessageType) {
        case 49: {
            //微信的服务中心
            Method methodMMServiceCenter = class_getClassMethod(objc_getClass("MMServiceCenter"), @selector(defaultCenter));
            IMP impMMSC = method_getImplementation(methodMMServiceCenter);
            id MMServiceCenter = impMMSC(objc_getClass("MMServiceCenter"), @selector(defaultCenter));
            //红包控制器
            id logicMgr = ((id (*)(id, SEL, Class))objc_msgSend)(MMServiceCenter, @selector(getService:),objc_getClass("WCRedEnvelopesLogicMgr"));
            //通讯录管理器
            id contactManager = ((id (*)(id, SEL, Class))objc_msgSend)(MMServiceCenter, @selector(getService:),objc_getClass("CContactMgr"));
            
            Method methodGetSelfContact = class_getInstanceMethod(objc_getClass("CContactMgr"), @selector(getSelfContact));
            IMP impGS = method_getImplementation(methodGetSelfContact);
            id selfContact = impGS(contactManager, @selector(getSelfContact));
            
            Ivar nsUsrNameIvar = class_getInstanceVariable([selfContact class], "m_nsUsrName");
            id m_nsUsrName = object_getIvar(selfContact, nsUsrNameIvar);
            
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
                    [parameters setObject:value forKey:key];
                }
                
                //红包参数
                NSMutableDictionary *params = [@{} mutableCopy];
                
                [params setObject:parameters[@"msgtype"]?:@"null" forKey:@"msgType"];
                [params setObject:parameters[@"sendid"]?:@"null" forKey:@"sendId"];
                [params setObject:parameters[@"channelid"]?:@"null" forKey:@"channelId"];
                
                id getContactDisplayName = objc_msgSend(selfContact, @selector(getContactDisplayName));
                id m_nsHeadImgUrl = objc_msgSend(selfContact, @selector(m_nsHeadImgUrl));
                
                [params setObject:getContactDisplayName forKey:@"nickName"];
                [params setObject:m_nsHeadImgUrl forKey:@"headImg"];
                [params setObject:[NSString stringWithFormat:@"%@", nativeUrl]?:@"null" forKey:@"nativeUrl"];
                [params setObject:m_nsFromUsr?:@"null" forKey:@"sessionUserName"];
                [RHUserDefaults setObject:params forKey:RHParamKey];
                
                [RHUserDefaults setBool:YES forKey:RHIsAutoOpenKey];
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
                [dictParam setObject:@"0" forKey:@"agreeDuty"];                                             //agreeDuty
                [dictParam setObject:parameters[@"channelid"]?:@"null" forKey:@"channelId"];        //channelId
                [dictParam setObject:@"1" forKey:@"inWay"];                                                 //inWay
                [dictParam setObject:parameters[@"msgtype"]?:@"null" forKey:@"msgType"];            //msgType
                [dictParam setObject:nativeUrl forKey:@"nativeUrl"];                                     //nativeUrl
                [dictParam setObject:parameters[@"sendid"]?:@"null" forKey:@"sendId"];              //sendId
                
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

CHOptimizedMethod1(self, void, WCRedEnvelopesLogicMgr, ReceiverQueryRedEnvelopesRequest, id, arg1) {
    CHSuper1(WCRedEnvelopesLogicMgr, ReceiverQueryRedEnvelopesRequest, arg1);
}

CHOptimizedMethod2(self, void, WCRedEnvelopesLogicMgr, OnWCToHongbaoCommonResponse, id, arg1, Request, id, arg2) {
    CHSuper2(WCRedEnvelopesLogicMgr, OnWCToHongbaoCommonResponse, arg1, Request, arg2);
    
    [RHUserDefaults setBool:YES forKey:RHIsAutoOpenKey];
    if ([RHUserDefaults boolForKey:RHIsAutoOpenKey]) {
        if ([NSStringFromClass([arg1 class]) isEqualToString:@"HongBaoRes"]) {
            NSData *data = [[arg1 retText] buffer];
            
            if (nil != data && 0 < [data length])
            {
                NSError* error = nil;
                id jsonObj = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
                if (nil != error)
                {
                    NSLog(@"HongBaoRes, json-error=%@", [error localizedDescription]);
                }
                else if (nil != jsonObj)
                {
                    if ([NSJSONSerialization isValidJSONObject:jsonObj]) {
                        if ([jsonObj isKindOfClass:[NSDictionary class]]) {
                            id idTemp = jsonObj[@"timingIdentifier"];
                            if (idTemp) {
                                NSMutableDictionary *params = [[RHUserDefaults objectForKey:RHParamKey] mutableCopy];
                                [RHUserDefaults setObject:[NSMutableDictionary dictionary] forKey:RHParamKey];
                                [params setObject:idTemp forKey:@"timingIdentifier"]; // "timingIdentifier"字段
                                
                                //微信的服务中心
                                Method methodMMServiceCenter = class_getClassMethod(objc_getClass("MMServiceCenter"), @selector(defaultCenter));
                                IMP impMMSC = method_getImplementation(methodMMServiceCenter);
                                id MMServiceCenter = impMMSC(objc_getClass("MMServiceCenter"), @selector(defaultCenter));
                                //红包控制器
                                id logicMgr = ((id (*)(id, SEL, Class))objc_msgSend)(MMServiceCenter, @selector(getService:),objc_getClass("WCRedEnvelopesLogicMgr"));
                                
                                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
                                dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                                    ((void (*)(id, SEL, NSMutableDictionary*))objc_msgSend)(logicMgr, @selector(OpenRedEnvelopesRequest:), params);
                                    [RHUserDefaults setBool:NO forKey:RHIsAutoOpenKey];
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
    
    CHLoadLateClass(NewSettingViewController);
    CHClassHook0(NewSettingViewController, reloadTableData);
    
    CHLoadLateClass(MMTableViewInfo);
    CHLoadLateClass(MMTableView);
    CHLoadLateClass(MMTableViewCellInfo);
    CHLoadLateClass(MMTableViewSectionInfo);
}

