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

@interface DARecordEditViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AVAudioRecorderDelegate, UITextFieldDelegate> {
  BOOL recording_;
  UILabel* recordingLabel_;
  UIButton* recordButton_;
  AVAudioRecorder* recorder_;
  IBOutlet UINavigationItem* cancel_;
  IBOutlet UITableView* tableView_;
}

@property(readwrite, strong) DARecord* recode;

- (id)initWithRecord:(DARecord*)record;

- (IBAction)pressSaveButton:(id)sender;
- (IBAction)pressCancelButton:(id)sender;

@end
