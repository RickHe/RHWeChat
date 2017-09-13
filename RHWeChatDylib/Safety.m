//
//  Safety.m
//  IM_Expensive
//
//  Created by 蔡士章 on 15/10/2.
//  Copyright © 2015年 szcai. All rights reserved.
//

#import "Safety.h"

@implementation NSArray (Safety)

- (id)SafetyObjectAtIndex:(NSUInteger)index
{
    if (self.count <= index)
    {
        return nil;
    }
    return [self objectAtIndex:index];
}

@end

@implementation NSMutableArray (Safety)

- (BOOL)SafetyAddObject:(id)anObject
{
    if (anObject)
    {
        [self addObject:anObject];
        return YES;
    }
    return NO;
}

- (BOOL)SafetyInsertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (!anObject || self.count <= index)
    {
        return NO;
    }
    [self insertObject:anObject atIndex:index];
    return YES;
}

- (BOOL)SafetyRemoveObject:(id)anObject
{
    if(anObject && [self containsObject:anObject])
    {
        [self removeObject:anObject];
        return YES;
    }
    return NO;
}

- (BOOL)SafetyRemoveObjectAtIndex:(NSUInteger)index
{
    if (self.count <= index)
    {
        return NO;
    }
    [self removeObjectAtIndex:index];
    return YES;
}

- (BOOL)SafetyReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (self.count <= index || !anObject)
    {
        return NO;
    }
    [self replaceObjectAtIndex:index withObject:anObject];
    return YES;
}
@end

@implementation NSMutableDictionary (Safety)

- (void)SafetySetObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    if (anObject)
    {
        [self setObject:anObject forKey:aKey];
    }
}

@end

@implementation NSCalendar(Safety)
- (NSDate *)safeDateFromComponents:(NSDateComponents *)comps{
    return (comps != nil) ? [self dateFromComponents:comps] : nil;
}

- (NSDateComponents *)safeComponents:(NSCalendarUnit)unitFlags fromDate:(NSDate *)date{
    return (date != nil) ? [self components:unitFlags fromDate:date] : nil;
}
@end
