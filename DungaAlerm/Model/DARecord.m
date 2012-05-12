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

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:[NSNumber numberWithInt:self.primaryKey] forKey:@"primaryKey"];
  [aCoder encodeObject:self.username forKey:@"username"];
  [aCoder encodeObject:self.message forKey:@"message"];
  [aCoder encodeObject:self.rawSound forKey:@"rawSound"];
  [aCoder encodeObject:self.createdAt forKey:@"createdAt"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if(self) {
    primaryKey = [(NSNumber*)[aDecoder decodeObjectForKey:@"primaryKey"] intValue];
    self.username = [aDecoder decodeObjectForKey:@"username"];
    self.message = [aDecoder decodeObjectForKey:@"message"];
    self.rawSound = [aDecoder decodeObjectForKey:@"rawSound"];
    self.createdAt = [aDecoder decodeObjectForKey:@"createdAt"];
  }
  return self;
}

@end
