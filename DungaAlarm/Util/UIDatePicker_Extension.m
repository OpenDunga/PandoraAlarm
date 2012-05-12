//
//  UIDatePicker+UIDatePicker_Extension.m
//  DungaAlarm
//
//  Created by  on 2012/5/13.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "UIDatePicker_Extension.h"

@implementation UIDatePicker (UIDatePicker_Extension)

- (void)transparentBackground {
  [(UIView*)[[self subviews] objectAtIndex:0] setBackgroundColor:[UIColor clearColor]];
  [[[(UIView*)[[self subviews] objectAtIndex:0] subviews] objectAtIndex:0] setHidden:YES];
  [[[(UIView*)[[self subviews] objectAtIndex:0] subviews] objectAtIndex:14] setHidden:YES];
}

@end
