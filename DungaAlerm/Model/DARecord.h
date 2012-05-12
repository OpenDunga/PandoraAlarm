//
//  DARecord.h
//  DungaAlerm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DARecord : NSObject

@property(readwrite) int primaryKey;
@property(readwrite, strong) NSString* username;
@property(readwrite, strong) NSString* message;
@property(readwrite, strong) NSData* rawSound;
@property(readwrite, strong) NSURL* audioURL;
@property(readwrite, strong) NSDate* createdAt;
@property(readonly) BOOL validated;

- (id)initWithJSON:(NSString*)json;
- (NSDictionary*)dump;

@end
