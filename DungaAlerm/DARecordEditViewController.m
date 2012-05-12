//
//  DARecordEditViewController.m
//  DungaAlerm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "DARecordEditViewController.h"
#import "DAMessageEditViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface DARecordEditViewController ()
- (void)pressRecordButton:(id)sender;
- (void)pressStopButton:(id)sender;
- (void)changeLabelField:(id)sender;
- (void)changeMessageField:(id)sender;
@end

@implementation DARecordEditViewController
@synthesize recode;

- (id)initWithRecord:(DARecord *)rec {
  self = [self initWithNibName:@"DARecordEditView" bundle:nil];
  if (self) {
    recode = rec;
  }
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = @"メッセージの追加";
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
    // 音量をでかくするけどなぞ
    // http://stackoverflow.com/questions/5662297/how-to-record-and-play-sound-in-iphone-app
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;                
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,          
                             sizeof (audioRouteOverride),&audioRouteOverride);
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                          target:self 
                                                                                          action:@selector(pressSaveButton:)];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                         target:self 
                                                                                         action:@selector(pressCancelButton:)];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
      cell.textLabel.text = @"名前";
      UITextField* field = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 170, 25)];
      field.delegate = self;
      field.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1];
      field.textAlignment = UITextAlignmentRight;
      field.returnKeyType = UIReturnKeyDone;
      field.placeholder = @"あなたの名前";
      [field addTarget:self 
                action:@selector(changeLabelField:) 
      forControlEvents:UIControlEventEditingChanged];
      cell.accessoryView = field;
    } else if (indexPath.section == 1) {
      cell.textLabel.text = @"メッセージ";
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    } else if (indexPath.section == 2) {
      cell.textLabel.text = @"音声";
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
  player_.volume = 1.0;
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

- (void)changeLabelField:(id)sender {
}

- (void)changeMessageField:(id)sender {
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
  NSLog(@"録音しますた");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 1) {
    DAMessageEditViewController* controller = [[DAMessageEditViewController alloc] initWithRecord:self.recode];
    [self.navigationController pushViewController:controller animated:YES];
  }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if([textField canResignFirstResponder]) {
    [textField resignFirstResponder];
  }
  return YES;
}

@end
