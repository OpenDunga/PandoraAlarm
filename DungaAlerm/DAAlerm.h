//
//  DAAlerm.h
//  DungaAlerm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DAAlerm : NSObject

@property(readwrite) NSDate* date;
@property(readwrite) NSURL* audioURL;

- (id)initWithDate:(NSDate*)date;
- (void)registerNotification;

@end
