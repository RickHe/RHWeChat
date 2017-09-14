// See http://iphonedevwiki.net/index.php/Logos

#import <UIKit/UIKit.h>

%hook WCBizUtil

+ (id)dictionaryWithDecodedComponets:(id)arg1 separator:(id)arg2 {
    %log;
    return %orig;
}

%end
