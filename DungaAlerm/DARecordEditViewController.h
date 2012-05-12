//
//  DARecordEditViewController.h
//  DungaAlerm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface DARecordEditViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AVAudioRecorderDelegate, AVAudioPlayerDelegate> {
  UIButton* recordButton_;
  AVAudioRecorder* recorder_;
  AVAudioPlayer* player_;
}

- (IBAction)pressSaveButton:(id)sender;
- (IBAction)pressCancelButton:(id)sender;

@end
