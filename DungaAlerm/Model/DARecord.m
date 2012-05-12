//
//  DARecord.m
//  DungaAlerm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "DARecord.h"

@implementation DARecord
@synthesize primaryKey;
@synthesize label;
@synthesize message;
@synthesize rawAudio;
@synthesize audioURL;
@synthesize createdAt;
@dynamic validated;

- (id)init {
  self = [super init];
  if (self) {
    primaryKey = -1;
    self.label = @"";
    self.message = @"";
    self.rawAudio = [NSData data];
    createdAt = nil;
  }
  return self;
}

- (id)initWithJSON:(NSString *)json {
  self = [super init];
  if (self) {
  }
  return self;
}

- (BOOL)validated {
  return self.primaryKey >= 0;
}

@end
