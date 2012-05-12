//
//  DAAlarmViewController.m
//  DungaAlarm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "DAAlarmViewController.h"
#import "DAAlarmStandbyViewController.h"
#import "DAAlarm.h"
#import "HttpAsyncConnection.h"

@interface DAAlarmViewController ()
@end

@implementation DAAlarmViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"normal_bg.png"]];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)pressSetButton:(id)sender {
  NSDate* date = datePicker_.date;
  if ([date timeIntervalSinceNow] <= 0) {
    date = [NSDate dateWithTimeInterval:60 * 60 * 24 sinceDate:date];
  }
  DAAlarmStandbyViewController* controller = [[DAAlarmStandbyViewController alloc] initWithDate:date];
  [self presentModalViewController:controller animated:YES];
}

@end
