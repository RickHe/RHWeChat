//
//  RHSafety.h
//  RHWeChat
//
//  Created by hmy2015 on 2017/9/4.
//  Copyright © 2017年 何米颖. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * NSArray
 */
@interface NSArray (RHSafety)

- (id)SafetyObjectAtIndex:(NSUInteger)index;

@end


/*
 * NSMutableArray
 */
@interface NSMutableArray (RHSafety)

- (BOOL)SafetyAddObject:(id)anObject;
- (BOOL)SafetyInsertObject:(id)anObject atIndex:(NSUInteger)index;
- (BOOL)SafetyRemoveObject:(id)anObject;
- (BOOL)SafetyRemoveObjectAtIndex:(NSUInteger)index;
- (BOOL)SafetyReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

@end

/*
 * NSMutableDictionary
 */
@interface NSMutableDictionary (RHSafety)

- (void)SafetySetObject:(id)anObject forKey:(id <NSCopying>)aKey;

@end

@interface NSCalendar(RHSafety)

- (NSDate *)safeDateFromComponents:(NSDateComponents *)comps;
- (NSDateComponents *)safeComponents:(NSCalendarUnit)unitFlags fromDate:(NSDate *)date;

@end
