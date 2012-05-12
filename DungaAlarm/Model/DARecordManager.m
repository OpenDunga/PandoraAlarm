//
//  DARecordManager.m
//  DungaAlarm
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
  NSMutableArray* array = [NSMutableArray array];
  for (DARecord* record in self.records) {
    NSData* d = [NSKeyedArchiver archivedDataWithRootObject:record];
    [array addObject:d];
  }
  [ud setObject:array forKey:(NSString*)RECORD_KEY];
}

- (NSArray*)loadRecordFromStorage {
  NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
  NSArray* archives = [ud objectForKey:(NSString*)RECORD_KEY];
  NSMutableArray* records = [NSMutableArray array];
  if (archives) {
    for (NSData* data in archives) {
      DARecord* record = [NSKeyedUnarchiver unarchiveObjectWithData:data];
      [records addObject:record];
    }
  }
  return records;
}

- (NSUInteger)count {
  return [self.records count];
}

@end
