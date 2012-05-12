//
//  DARecord.h
//  DungaAlarm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DARecord : NSObject <NSCoding>

@property(readwrite) int primaryKey;
@property(readwrite, strong) NSString* username;
@property(readwrite, strong) NSString* message;
@property(readwrite, strong) NSData* rawSound;
@property(readwrite, strong) NSURL* soundURL;
@property(readwrite, strong) NSDate* createdAt;

- (id)initWithJSON:(NSData*)json;
- (NSDictionary*)dump;
- (BOOL)validated;

@end
