#line 1 "/Users/DaFenQI/Desktop/RHWeChat/RHWeChatDylib/RHWeChatDylib.xm"


#import <UIKit/UIKit.h>

@interface MicroMessengerAppDelegate


- (BOOL)rh_isSameDay:(NSDate*)date1 date2:(NSDate*)date2;

@end


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class MicroMessengerAppDelegate; 
static void (*_logos_orig$_ungrouped$MicroMessengerAppDelegate$applicationDidBecomeActive$)(_LOGOS_SELF_TYPE_NORMAL MicroMessengerAppDelegate* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$MicroMessengerAppDelegate$applicationDidBecomeActive$(_LOGOS_SELF_TYPE_NORMAL MicroMessengerAppDelegate* _LOGOS_SELF_CONST, SEL, id); static BOOL _logos_method$_ungrouped$MicroMessengerAppDelegate$rh_isSameDay$date2$(_LOGOS_SELF_TYPE_NORMAL MicroMessengerAppDelegate* _LOGOS_SELF_CONST, SEL, NSDate*, NSDate*); 

#line 12 "/Users/DaFenQI/Desktop/RHWeChat/RHWeChatDylib/RHWeChatDylib.xm"


static void _logos_method$_ungrouped$MicroMessengerAppDelegate$applicationDidBecomeActive$(_LOGOS_SELF_TYPE_NORMAL MicroMessengerAppDelegate* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1){
    _logos_orig$_ungrouped$MicroMessengerAppDelegate$applicationDidBecomeActive$(self, _cmd, arg1);

    NSInteger openCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"openCount"];
    if (!openCount) {
        openCount = 0;
    }
    NSDate *currentDate = [NSDate date];
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"date"];
    
    if ([self rh_isSameDay:currentDate
                     date2:date]) {
        openCount++;
    } else {
        openCount = 1;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:@"date"];
    [[NSUserDefaults standardUserDefaults] setInteger:openCount forKey:@"openCount"];
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:[NSString stringWithFormat:@"朋友这是你今天第%li次打开 app 了", openCount]
                                                   delegate:self
                                          cancelButtonTitle:@"确认"
                                          otherButtonTitles:nil];
    
    [alert show];
}



static BOOL _logos_method$_ungrouped$MicroMessengerAppDelegate$rh_isSameDay$date2$(_LOGOS_SELF_TYPE_NORMAL MicroMessengerAppDelegate* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSDate* date1, NSDate* date2) {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$MicroMessengerAppDelegate = objc_getClass("MicroMessengerAppDelegate"); MSHookMessageEx(_logos_class$_ungrouped$MicroMessengerAppDelegate, @selector(applicationDidBecomeActive:), (IMP)&_logos_method$_ungrouped$MicroMessengerAppDelegate$applicationDidBecomeActive$, (IMP*)&_logos_orig$_ungrouped$MicroMessengerAppDelegate$applicationDidBecomeActive$);{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(BOOL), strlen(@encode(BOOL))); i += strlen(@encode(BOOL)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSDate*), strlen(@encode(NSDate*))); i += strlen(@encode(NSDate*)); memcpy(_typeEncoding + i, @encode(NSDate*), strlen(@encode(NSDate*))); i += strlen(@encode(NSDate*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$MicroMessengerAppDelegate, @selector(rh_isSameDay:date2:), (IMP)&_logos_method$_ungrouped$MicroMessengerAppDelegate$rh_isSameDay$date2$, _typeEncoding); }} }
#line 59 "/Users/DaFenQI/Desktop/RHWeChat/RHWeChatDylib/RHWeChatDylib.xm"
