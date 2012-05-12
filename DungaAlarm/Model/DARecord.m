//
//  DARecord.m
//  DungaAlarm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "DARecord.h"
#import "CJSONDeserializer.h"

@interface DARecord()
- (NSString*)stringWithBytes:(NSData*)data;
@end

@implementation DARecord
@synthesize primaryKey;
@synthesize username;
@synthesize message;
@synthesize rawSound;
@synthesize soundURL;
@synthesize createdAt;

- (id)init {
  self = [super init];
  if (self) {
    primaryKey = -1;
    self.username = @"";
    self.message = @"";
    self.soundURL = [NSURL URLWithString:@""];
    self.rawSound = [NSData data];
    createdAt = nil;
  }
  return self;
}

- (id)initWithJSON:(NSData *)json {
  self = [super init];
  if (self) {
    NSError* err;
    NSDictionary* dict = [[CJSONDeserializer deserializer] deserializeAsDictionary:json error:&err];
    primaryKey = [[dict objectForKey:@"pk"] intValue];
    username = [dict objectForKey:@"username"];
    message = [dict objectForKey:@"messsage"];
    rawSound = [self dataFromHex:[dict objectForKey:@"sound"]];
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
  [aCoder encodeObject:self.soundURL forKey:@"soundURL"];
  [aCoder encodeObject:self.rawSound forKey:@"rawSound"];
  [aCoder encodeObject:self.createdAt forKey:@"createdAt"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if(self) {
    primaryKey = [(NSNumber*)[aDecoder decodeObjectForKey:@"primaryKey"] intValue];
    self.username = [aDecoder decodeObjectForKey:@"username"];
    self.message = [aDecoder decodeObjectForKey:@"message"];
    self.soundURL = [aDecoder decodeObjectForKey:@"soundURL"];
    self.rawSound = [aDecoder decodeObjectForKey:@"rawSound"];
    self.createdAt = [aDecoder decodeObjectForKey:@"createdAt"];
  }
  return self;
}

- (NSData*)dataFromHex:(NSString*)hex {
  NSString* command = [hex stringByReplacingOccurrencesOfString:@" " withString:@""];
  NSMutableData *commandToSend= [[NSMutableData alloc] init];
  unsigned char whole_byte;
  char byte_chars[3] = {'\0','\0','\0'};
  int i;
  for (i=0; i < [command length]/2; i++) {
    byte_chars[0] = [command characterAtIndex:i*2];
    byte_chars[1] = [command characterAtIndex:i*2+1];
    whole_byte = strtol(byte_chars, NULL, 16);
    [commandToSend appendBytes:&whole_byte length:1]; 
  }
  return commandToSend;
}

@end
