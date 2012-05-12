//
//  DARecordManager.m
//  DungaAlerm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "DARecordManager.h"

@implementation DARecordManager
@synthesize records = records_;
const NSString* RECORD_KEY = @"records";


+ (id)sharedManager {
  static id sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[[self class] alloc] init];
  });
  return sharedInstance;
}

- (id)init {
  self = [super init];
  if (self) {
    records_ = [NSMutableArray arrayWithArray:[self loadRecordFromStorage]];
  }
  return self;
}

- (void)saveRecord:(DARecord *)record {
  [records_ addObject:record];
  NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
  [ud setObject:record forKey:(NSString*)RECORD_KEY];
}

- (NSArray*)loadRecordFromStorage {
  NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
  NSArray* records = [ud objectForKey:(NSString*)RECORD_KEY];
  if (records) {
    return records;
  }
  return [NSArray array];
}

@end
