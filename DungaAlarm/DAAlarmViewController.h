//
//  DAAlarmViewController.h
//  DungaAlarm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface DAAlarmViewController : UIViewController {
  IBOutlet UIDatePicker* datePicker_;
  IBOutlet UIButton* setButton_;
}

- (IBAction)pressSetButton:(id)sender;

@end
