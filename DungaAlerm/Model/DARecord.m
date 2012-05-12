//
//  DARecord.m
//  DungaAlerm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "DARecord.h"

@interface DARecord()
- (NSString*)stringWithBytes:(NSData*)data;
@end

@implementation DARecord
@synthesize primaryKey;
@synthesize username;
@synthesize message;
@synthesize rawSound;
@synthesize audioURL;
@synthesize createdAt;
@dynamic validated;

- (id)init {
  self = [super init];
  if (self) {
    primaryKey = -1;
    self.username = @"";
    self.message = @"";
    self.rawSound = [NSData data];
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

- (NSDictionary*)dump {
  NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        self.username, @"username", 
                        self.message, @"message",
                        [self stringWithBytes:self.rawSound], @"sound",
                        nil];
  return dict;
}

- (NSString*) stringWithBytes:(NSData *)data {
  NSMutableString *stringBuffer = [NSMutableString
                                   stringWithCapacity:([data length] * 2)];
  const unsigned char *dataBuffer = [data bytes];
  int i;
  
  for (i = 0; i < [data length]; ++i) {
    [stringBuffer appendFormat:@"%02X", (unsigned long)dataBuffer[ i ]];
  }
  return stringBuffer;
}

@end
