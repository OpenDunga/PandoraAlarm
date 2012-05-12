//
//  DAAlarmStandbyViewController.h
//  DungaAlarm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef enum {
  UIAlertViewTypeStop,
  UIAlertViewTypeEnd
} UIAlertViewType;

@interface DAAlarmStandbyViewController : UIViewController <UIAlertViewDelegate> {
  BOOL loaded_;
  BOOL ended_;
  NSTimer* timer_;
  NSDate* date_;
  IBOutlet UILabel* remainLabel_;
  AVAudioPlayer* player_;
}

- (id)initWithDate:(NSDate*)date;
- (IBAction)pressStopButton:(id)sender;

@end
