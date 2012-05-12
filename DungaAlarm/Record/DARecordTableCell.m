//
//  DARecordTableCell.m
//  DungaAlarm
//
//  Created by  on 2012/5/13.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "DARecordTableCell.h"
#import "HttpAsyncConnection.h"

@interface DARecordTableCell()
- (void)onSucceedCreation:(NSURLConnection*)connection aConnection:(HttpAsyncConnection*)aConnection;
@end

@implementation DARecordTableCell
@synthesize count;
const NSString* COUNT_API_URL = @"http://phptest.kawaz.org/count.php";

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithRecord:(DARecord *)rec {
  self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[NSString stringWithFormat:@"Cell_%d", rec.primaryKey]];
  if (self) {
    count = -1;
    HttpAsyncConnection* connection = [HttpAsyncConnection connection];
    connection.delegate = self;
    connection.finishSelector = @selector(onSucceedCreation:aConnection:);
    [connection connectTo:[NSURL URLWithString:[NSString stringWithFormat:@"%@?pk=%d", (NSString*)COUNT_API_URL, rec.primaryKey]]
                                       params:nil 
                                       method:@"GET" 
                                    userAgent:@"DungaAlarm" 
                                   httpHeader:@"namaco"];
    self.textLabel.text = rec.message;
    self.detailTextLabel.text = @"読み込み中...";
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)onSucceedCreation:(NSURLConnection *)connection aConnection:(HttpAsyncConnection *)aConnection {
  NSString* intString = [[NSString alloc] initWithData:aConnection.data encoding:NSUTF8StringEncoding];
  count = [intString intValue];
  if (self.count == 0) {
    self.detailTextLabel.text = @"まだ誰にも再生されていません";
  } else {
    self.detailTextLabel.text = [NSString stringWithFormat:@"%d回再生されました", self.count];
  }
}

@end
