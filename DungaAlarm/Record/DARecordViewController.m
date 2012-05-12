//
//  DARecordViewController.m
//  DungaAlarm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "DARecordViewController.h"
#import "DARecordEditViewController.h"
#import "DARecordTableCell.h"

@interface DARecordViewController ()
@end

@implementation DARecordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    manager_ = [DARecordManager sharedManager];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [tableView_ reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [manager_ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  NSString *CellIdentifier = [NSString stringWithFormat:@"Cell:%d_%d", indexPath.section, indexPath.row];
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    DARecord* record = [manager_.records objectAtIndex:indexPath.row];
    cell = [[DARecordTableCell alloc] initWithRecord:record];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  return cell;  
}

- (IBAction)pressAddButton:(id)sender {
  DARecordEditViewController* editViewController = [[DARecordEditViewController alloc] initWithRecord:[[DARecord alloc] init]];
  UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:editViewController];
  [self presentModalViewController:navigationController animated:YES];
}

@end
