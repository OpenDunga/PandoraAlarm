//
//  DARecordEditViewController.m
//  DungaAlarm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "DARecordEditViewController.h"
#import "DAMessageEditViewController.h"
#import "HttpAsyncConnection.h"
#import "CJSONDeserializer.h"
#import "DARecordManager.h"
#import <AudioToolbox/AudioToolbox.h>

@interface DARecordEditViewController ()
- (NSString*)filenameFromCurrentTime;
- (void)pressRecordButton:(id)sender;
- (void)pressStopButton:(id)sender;
- (void)changeLabelField:(id)sender;
- (void)onRecivedResponse:(NSURLResponse*)res aConnection:(HttpAsyncConnection*)aConnection;
- (void)onSucceedCreation:(NSURLConnection*)connection aConnection:(HttpAsyncConnection*)aConnection;
@end

const NSString* API_URL = @"http://phptest.kawaz.org/save.php";

@implementation DARecordEditViewController
@synthesize recode;
const float MAX_MEGABYTE = 1;
const NSString* LAST_NAME_KEY = @"lastUsername";

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
    recording_ = NO;
    self.title = @"メッセージの追加";
    recode = [[DARecord alloc] init];
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask,YES);
    NSString *documentDir = [filePaths objectAtIndex:0];    
    NSString *path = [documentDir stringByAppendingPathComponent:[self filenameFromCurrentTime]];
    NSURL *recordingURL = [NSURL fileURLWithPath:path];
    
    NSError* error = nil;
    NSDictionary* settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithUnsignedInt:kAudioFormatLinearPCM], AVFormatIDKey,
                              [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                              nil];
    recode.soundURL = recordingURL;
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

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                          target:self 
                                                                                          action:@selector(pressSaveButton:)];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                         target:self 
                                                                                         action:@selector(pressCancelButton:)];
  recordButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
  recordButton_.frame = CGRectMake(100, 200, 120, 120);
  [recordButton_ addTarget:self action:@selector(pressRecordButton:) forControlEvents:UIControlEventTouchUpInside];
  [recordButton_ setImage:[UIImage imageNamed:@"rec.png"] forState:UIControlStateNormal];
  [tableView_ addSubview:recordButton_];
  tableView_.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"normal_bg.png"]];
  
  recordingLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(60, 140, 200, 40)];
  recordingLabel_.text = @"Now Recording";
  recordingLabel_.textColor = [UIColor whiteColor];
  recordingLabel_.backgroundColor = [UIColor clearColor];
  recordingLabel_.textAlignment = UITextAlignmentCenter;
  recordingLabel_.font = [UIFont systemFontOfSize:24];
  recordingLabel_.hidden = YES;
  [self.view addSubview:recordingLabel_];
  
}

- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
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
      NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
      NSString* lastName = [ud objectForKey:(NSString*)LAST_NAME_KEY];
      if (lastName) {
        field.text = lastName;
        self.recode.username = lastName;
      }
      [field addTarget:self 
                action:@selector(changeLabelField:) 
      forControlEvents:UIControlEventEditingChanged];
      cell.accessoryView = field;
    } else if (indexPath.section == 1) {
      cell.textLabel.text = @"メッセージ";
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
  }
  return cell;  
}

- (NSString*)filenameFromCurrentTime {
  NSDate* date = [NSDate date];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyyMMddHHmmss"];
  NSString *filename = [formatter stringFromDate:date];
  return filename;
}

- (IBAction)pressSaveButton:(id)sender {
  if (recording_) return;
  NSData* rawSound = [NSData dataWithContentsOfURL:recorder_.url];
  recode.rawSound = rawSound;
  BOOL error = NO;
  float size = (float)[self.recode.rawSound length] / (float)pow(2, 20);
  NSString* errorText = @"";
  if ([self.recode.rawSound length] == 0) {
    error = YES;
    errorText = @"音声が録音されていません";
  } else if ([self.recode.username length] == 0) {
    error = YES;
    errorText = @"名前が設定されていません";
  } else if ([self.recode.message length] == 0) {
    error = YES;
    errorText = @"メッセージが設定されていません";
  } else if (size >= MAX_MEGABYTE) {
    error = YES;
    errorText = @"音声の容量が大きすぎます";
  }
  if (error) {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"投稿エラー" 
                                                    message:errorText 
                                                   delegate:nil 
                                          cancelButtonTitle:@"戻る" 
                                          otherButtonTitles:nil];
    [alert show];
  } else {
    HttpAsyncConnection* connection = [HttpAsyncConnection connection];
    connection.delegate = self;
    connection.finishSelector = @selector(onSucceedCreation:aConnection:);
    NSURL* apiURL = [NSURL URLWithString:(NSString*)API_URL];
    [connection connectTo:apiURL params:[recode dump] 
                   method:@"POST" 
                userAgent:@"DungaAlarm" 
               httpHeader:@"namaco"];
  }
  NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
  [ud setObject:self.recode.username forKey:(NSString*)LAST_NAME_KEY];
}

- (IBAction)pressCancelButton:(id)sender {
  if (recording_) return;
  [self dismissModalViewControllerAnimated:YES];
}

- (void)pressRecordButton:(id)sender {
  recording_ = YES;
  [recordButton_ addTarget:self action:@selector(pressStopButton:) forControlEvents:UIControlEventTouchUpInside];
  [recordButton_ setImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
  [recorder_ prepareToRecord];
  [recorder_ record];
  recordingLabel_.hidden = NO;
}

- (void)pressStopButton:(id)sender {
  recording_ = NO;
  [recordButton_ addTarget:self action:@selector(pressRecordButton:) forControlEvents:UIControlEventTouchUpInside];
  [recordButton_ setImage:[UIImage imageNamed:@"rec.png"] forState:UIControlStateNormal];
  [recorder_ stop];
  recordingLabel_.hidden = YES;
}

- (void)changeLabelField:(id)sender {
  UITextField* field = (UITextField*)sender;
  recode.username = field.text;
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
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

- (void)onRecivedResponse:(NSURLResponse *)res aConnection:(HttpAsyncConnection *)aConnection {
}

- (void)onSucceedCreation:(NSURLConnection *)connection aConnection:(HttpAsyncConnection *)aConnection {
  NSError* err;
  NSDictionary* dict = [[CJSONDeserializer deserializer] deserializeAsDictionary:aConnection.data error:&err];
  int pk = [[dict objectForKey:@"pk"] intValue];
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  formatter.dateFormat = @"yyyy-mm-dd HH:mm:ss";
  NSDate* createdAt = [formatter dateFromString:[dict objectForKey:@"created_at"]];
  self.recode.primaryKey = pk;
  self.recode.createdAt = createdAt;
  DARecordManager* manager = [DARecordManager sharedManager];
  [manager saveRecord:self.recode];
  [self dismissModalViewControllerAnimated:YES];
}

@end
