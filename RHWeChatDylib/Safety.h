//
//  Safety.h
//  IM_Expensive
//
//  Created by 蔡士章 on 15/10/2.
//  Copyright © 2015年 szcai. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * NSArray
 */
@interface NSArray (Safety)
- (id)SafetyObjectAtIndex:(NSUInteger)index;
@end


/*
 * NSMutableArray
 */
@interface NSMutableArray (Safety)
- (BOOL)SafetyAddObject:(id)anObject;
- (BOOL)SafetyInsertObject:(id)anObject atIndex:(NSUInteger)index;
- (BOOL)SafetyRemoveObject:(id)anObject;
- (BOOL)SafetyRemoveObjectAtIndex:(NSUInteger)index;
- (BOOL)SafetyReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
@end

/*
 * NSMutableDictionary
 */
@interface NSMutableDictionary (Safety)
- (void)SafetySetObject:(id)anObject forKey:(id <NSCopying>)aKey;
@end

@interface NSCalendar(Safety)
- (NSDate *)safeDateFromComponents:(NSDateComponents *)comps;
- (NSDateComponents *)safeComponents:(NSCalendarUnit)unitFlags fromDate:(NSDate *)date;
@end
