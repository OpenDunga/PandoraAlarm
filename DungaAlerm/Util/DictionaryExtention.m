//
//  DictionaryExtention.m
//  DungaRadar
//
//  Created by giginet on 11/07/10.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "DictionaryExtention.h"


@implementation NSDictionary (DictionaryExtention)
- (NSString*)dump{
  if([self count]){
    NSMutableString* string = [NSMutableString string];
    for(id key in [self allKeys]){
      [string appendFormat:@"%@=%@&", key, [self objectForKey:key]];
    }
    [string deleteCharactersInRange:NSMakeRange([string length]-1, 1)];
    return (NSString*)string;
  }
  return @"";
}
@end
