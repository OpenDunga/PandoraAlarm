//
//  DAAlermViewController.m
//  DungaAlerm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "DAAlermViewController.h"
#import "DAAlermStandbyViewController.h"
#import "DAAlerm.h"
#import "HttpAsyncConnection.h"

@interface DAAlermViewController ()
@end

@implementation DAAlermViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
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
  DAAlermStandbyViewController* controller = [[DAAlermStandbyViewController alloc] initWithDate:date];
  [self presentModalViewController:controller animated:YES];
}

@end
