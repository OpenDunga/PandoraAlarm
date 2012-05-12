//
//  DAAlerm.m
//  DungaAlerm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "DAAlerm.h"

@implementation DAAlerm
@synthesize date;
@synthesize audioURL;

- (id)initWithDate:(NSDate *)d {
  self = [super init];
  if (self) {
    date = d;
  }
  return self;
}

- (void)registerNotification {
}

@end
