//
//  DARecordViewController.h
//  DungaAlerm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DARecordManager.h"

@interface DARecordViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
  DARecordManager* manager_;
  IBOutlet UITableView* tableView_;
}

- (IBAction)pressAddButton:(id)sender;

@end
