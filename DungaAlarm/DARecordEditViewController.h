//
//  DARecordEditViewController.h
//  DungaAlarm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DARecord.h"

@interface DARecordEditViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UITextFieldDelegate> {
  UIButton* recordButton_;
  AVAudioRecorder* recorder_;
  AVAudioPlayer* player_;
  IBOutlet UINavigationItem* cancel_;
}

@property(readwrite, strong) DARecord* recode;

- (id)initWithRecord:(DARecord*)record;

- (IBAction)pressSaveButton:(id)sender;
- (IBAction)pressCancelButton:(id)sender;

@end