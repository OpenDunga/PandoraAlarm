//
//  DARecord.h
//  DungaAlerm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DARecord : NSObject

@property(readwrite, strong) NSString* label;
@property(readwrite, strong) NSString* message;
@property(readwrite, strong) NSData* rawAudio;
@property(readwrite, strong) NSURL* audioURL;

@end