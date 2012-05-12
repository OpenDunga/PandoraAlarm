//
//  DAAlermViewController.h
//  DungaAlerm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface DAAlermViewController : UIViewController {
  IBOutlet UIDatePicker* datePicker_;
  AVAudioPlayer* player_;
}

@end
