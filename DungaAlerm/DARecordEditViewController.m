//
//  DARecordEditViewController.m
//  DungaAlerm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "DARecordEditViewController.h"

@interface DARecordEditViewController ()
- (void)pressRecordButton:(id)sender;
- (void)pressStopButton:(id)sender;
@end

@implementation DARecordEditViewController
@synthesize recode;

- (id)initWithRecord:(DARecord *)rec {
  self = [self initWithNibName:@"" bundle:nil];
  if (self) {
    recode = rec;
  }
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      recode = [[DARecord alloc] init];
      NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                               NSUserDomainMask,YES);
      NSString *documentDir = [filePaths objectAtIndex:0];    
      NSString *path = [documentDir stringByAppendingPathComponent:@"recording.caf"];
      NSURL *recordingURL = [NSURL fileURLWithPath:path];

      NSError* error = nil;
      NSDictionary* settings = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithUnsignedInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                      [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                      nil];
      recorder_ = [[AVAudioRecorder alloc] initWithURL:recordingURL settings:settings error:&error];
      recorder_.delegate = self;
      AVAudioSession *audioSession = [AVAudioSession sharedInstance];
      NSError *err = nil;
      // 使用している機種が録音に対応しているか
      if ([audioSession inputIsAvailable]) {
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&err];
      }
      if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
      }
      // 録音機能をアクティブにする
      [audioSession setActive:YES error:&err];
      if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
      }
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  NSString *CellIdentifier = [NSString stringWithFormat:@"Cell:%d_%d", indexPath.section, indexPath.row];
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.textLabel.text = @"hello";
    if (indexPath.section == 2) {
      recordButton_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
      recordButton_.frame = CGRectMake(10, 150, 150, 45);
      [recordButton_ addTarget:self action:@selector(pressRecordButton:) forControlEvents:UIControlEventTouchUpInside];
      [recordButton_ setTitle:@"録音" forState:UIControlStateNormal];
      cell.accessoryView = recordButton_;
    }
  }
  return cell;  
}

- (IBAction)pressSaveButton:(id)sender {
  //NSString* path = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"caf"];
  //NSURL* url = [NSURL fileURLWithPath:path];
  NSURL* url = recorder_.url;
  player_ = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
  player_.delegate = self;
  [player_ play];
}

- (IBAction)pressCancelButton:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

- (void)pressRecordButton:(id)sender {
  [recordButton_ addTarget:self action:@selector(pressStopButton:) forControlEvents:UIControlEventTouchUpInside];
  [recordButton_ setTitle:@"停止" forState:UIControlStateNormal];
  [recorder_ prepareToRecord];
  BOOL result = [recorder_ record];
  NSLog(@"%d", result);
}

- (void)pressStopButton:(id)sender {
  [recordButton_ addTarget:self action:@selector(pressRecordButton:) forControlEvents:UIControlEventTouchUpInside];
  [recordButton_ setTitle:@"録音" forState:UIControlStateNormal];
  [recorder_ stop];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
  NSLog(@"録音しますた");
}

@end
