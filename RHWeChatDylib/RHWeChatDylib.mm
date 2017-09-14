#line 1 "/Users/DaFenQI/Desktop/RHWeChat/RHWeChatDylib/RHWeChatDylib.xm"


#import <UIKit/UIKit.h>


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

@class WCBizUtil; 
static id (*_logos_meta_orig$_ungrouped$WCBizUtil$dictionaryWithDecodedComponets$separator$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id, id); static id _logos_meta_method$_ungrouped$WCBizUtil$dictionaryWithDecodedComponets$separator$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id, id); 

#line 5 "/Users/DaFenQI/Desktop/RHWeChat/RHWeChatDylib/RHWeChatDylib.xm"


static id _logos_meta_method$_ungrouped$WCBizUtil$dictionaryWithDecodedComponets$separator$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, id arg2) {
    HBLogDebug(@"+[<WCBizUtil: %p> dictionaryWithDecodedComponets:%@ separator:%@]", self, arg1, arg2);
    return _logos_meta_orig$_ungrouped$WCBizUtil$dictionaryWithDecodedComponets$separator$(self, _cmd, arg1, arg2);
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$WCBizUtil = objc_getClass("WCBizUtil"); Class _logos_metaclass$_ungrouped$WCBizUtil = object_getClass(_logos_class$_ungrouped$WCBizUtil); MSHookMessageEx(_logos_metaclass$_ungrouped$WCBizUtil, @selector(dictionaryWithDecodedComponets:separator:), (IMP)&_logos_meta_method$_ungrouped$WCBizUtil$dictionaryWithDecodedComponets$separator$, (IMP*)&_logos_meta_orig$_ungrouped$WCBizUtil$dictionaryWithDecodedComponets$separator$);} }
#line 13 "/Users/DaFenQI/Desktop/RHWeChat/RHWeChatDylib/RHWeChatDylib.xm"
