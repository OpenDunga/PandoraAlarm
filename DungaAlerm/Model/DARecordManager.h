//
//  DARecordManager.h
//  DungaAlerm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DARecord.h"

@interface DARecordManager : NSObject {
  NSMutableArray* records_;
}

@property(readonly) NSArray* records;

+ (id)sharedManager;
- (NSArray*)loadRecordFromStorage;
- (void)saveRecord:(DARecord*)record;
- (NSUInteger)count;

@end
