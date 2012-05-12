//
//  DARecordTableCell.h
//  DungaAlarm
//
//  Created by  on 2012/5/13.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DARecord.h"

@interface DARecordTableCell : UITableViewCell 

@property(readonly) int count;

- (id)initWithRecord:(DARecord*)rec;

@end
