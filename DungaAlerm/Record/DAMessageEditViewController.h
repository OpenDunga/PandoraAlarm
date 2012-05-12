//
//  DAMessageEditViewController.h
//  DungaAlerm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DARecord.h"

@interface DAMessageEditViewController : UIViewController <UITextViewDelegate> {
  DARecord* record_;
  IBOutlet UITextView* textView_;
}

- (id)initWithRecord:(DARecord*)rec;

@end
