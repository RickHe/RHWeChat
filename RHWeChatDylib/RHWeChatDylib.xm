// See http://iphonedevwiki.net/index.php/Logos

#import <UIKit/UIKit.h>

@interface MicroMessengerAppDelegate

- (BOOL)rh_isSameDay:(NSDate*)date1
               date2:(NSDate*)date2;

@end

%hook MicroMessengerAppDelegate

- (void)applicationDidBecomeActive:(id)arg1{
    %orig(arg1);

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
    
    //初始化AlertView
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:[NSString stringWithFormat:@"朋友这是你今天第%li次打开 app 了", openCount]
                                                   delegate:self
                                          cancelButtonTitle:@"确认"
                                          otherButtonTitles:nil];
    
    [alert show];
}

%new
- (BOOL)rh_isSameDay:(NSDate*)date1
                date2:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

%end
