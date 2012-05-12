//
//  DARecord.m
//  DungaAlerm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "DARecord.h"

@implementation DARecord
@synthesize label;
@synthesize message;
@synthesize rawAudio;
@synthesize audioURL;

- (id)init {
  self = [super init];
  if (self) {
    self.label = @"";
    self.message = @"";
    self.rawAudio = [NSData data];
  }
  return self;
}

@end
