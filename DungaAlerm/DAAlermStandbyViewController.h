//
//  DAAlermStandbyViewController.h
//  DungaAlerm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface DAAlermStandbyViewController : UIViewController {
  NSTimer* timer_;
  NSDate* date_;
  IBOutlet UIButton* okButton_;
  AVAudioPlayer* player_;
}

- (id)initWithDate:(NSDate*)date;
- (IBAction)pressOKButton:(id)sender;

@end
