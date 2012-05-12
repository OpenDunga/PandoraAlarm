//
//  DAMessageEditViewController.m
//  DungaAlarm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "DAMessageEditViewController.h"

@interface DAMessageEditViewController ()

@end

@implementation DAMessageEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithRecord:(DARecord *)rec {
  self = [super initWithNibName:@"DAMessageEditView" bundle:nil];
  if (self) {
    record_ = rec;
    self.title = @"メッセージ";
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  textView_.text = record_.message;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)textViewDidChange:(UITextView *)textView {
  record_.message = textView.text;
}

@end
