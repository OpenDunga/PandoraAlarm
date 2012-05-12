//
//  DAAlarmStandbyViewController.m
//  DungaAlarm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "DAAlarmStandbyViewController.h"
#import "HttpAsyncConnection.h"

@interface DAAlarmStandbyViewController ()
- (void)update:(NSTimer*)timer;
- (void)onRecivedResponse:(NSURLResponse*)res aConnection:(HttpAsyncConnection*)aConnection;
- (void)onSucceed:(NSURLConnection*)connection aConnection:(HttpAsyncConnection*)aConnection;
- (void)updateRemainLabel;
- (NSString*)formatedTimeFromTimeInterval:(NSTimeInterval)interval separator:(NSString*)separator;
- (void)onEndTimer;
@end

@implementation DAAlarmStandbyViewController
const NSString* GET_API_URL = @"http://192.168.11.125/~takamatsu/cookpad/fetch.php";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (id)initWithDate:(NSDate *)date {
  self = [self initWithNibName:@"DAAlarmStandbyView" bundle:nil];
  if (self) {
    ended_ = NO;
    loaded_ = NO;
    date_ = date;
    timer_ = [NSTimer scheduledTimerWithTimeInterval:1.0 
                                              target:self 
                                            selector:@selector(update:) 
                                            userInfo:nil 
                                             repeats:YES];
    UIImage* image = [UIImage imageNamed:@"wait_bg.png"];
    UIColor* bgColor = [UIColor colorWithPatternImage:image];
    self.view.backgroundColor = bgColor;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self updateRemainLabel];
  HttpAsyncConnection* connection = [HttpAsyncConnection connection];
  connection.delegate = self;
  connection.responseSelector = @selector(onRecivedResponse:aConnection:);
  connection.finishSelector = @selector(onSucceed:aConnection:);
  [connection connectTo:[NSURL URLWithString:(NSString*)GET_API_URL]
                 params:[NSDictionary dictionary]
                 method:@"GET" 
              userAgent:@"DungaAlarm" 
             httpHeader:@"namaco"];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)update:(NSTimer *)timer {
  NSTimeInterval interval = [date_ timeIntervalSinceNow];
  [self updateRemainLabel];
  if (interval <= 0) {
    ended_ = YES;
    if (loaded_) {
      [self onEndTimer];
    }
    [timer_ invalidate];
  }
}

- (void)onRecivedResponse:(NSURLResponse *)res aConnection:(HttpAsyncConnection *)aConnection {
}

- (void)onSucceed:(NSURLConnection *)connection aConnection:(HttpAsyncConnection *)aConnection {
  NSError* err;
  record_ = [[DARecord alloc] initWithJSON:aConnection.data];
  player_ = [[AVAudioPlayer alloc] initWithData:record_.rawSound error:&err];
  player_.numberOfLoops = -1;
  if (err) {
    NSLog(@"%@", err);
  }
  loaded_ = YES;
  if (ended_) {
    [self onEndTimer];
  }
}

- (IBAction)pressStopButton:(id)sender {
  UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"アラームの停止" 
                                                  message:@"アラームを停止させて戻ります。よろしいですか？" 
                                                 delegate:self 
                                        cancelButtonTitle:@"キャンセル" 
                                        otherButtonTitles:@"停止", nil];
  alert.tag = UIAlertViewTypeStop;
  [alert show];
}

- (void)updateRemainLabel {
  NSTimeInterval interval = [date_ timeIntervalSinceNow];
  remainLabel_.text = [self formatedTimeFromTimeInterval:interval separator:@":"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (alertView.tag == UIAlertViewTypeStop) {
    if (buttonIndex == 1) {
      [timer_ invalidate];
      [self dismissModalViewControllerAnimated:YES];
    }
  } else {
    if (buttonIndex == 0) {
      [player_ stop];
      [timer_ invalidate];
      [self dismissModalViewControllerAnimated:YES];
    }
  }
}

- (NSString*)formatedTimeFromTimeInterval:(NSTimeInterval)interval separator:(NSString *)separator {
  NSMutableString* string = [NSMutableString string];
  if (interval <= 0) {
    [string appendString:@"0"];
    return string;
  }
  int hour = floor(interval / 3600);
  int minute = floor((interval - 3600 * hour) / 60);
  int second = floor(interval - 3600 * hour - minute * 60);
  if (hour > 0) {
    if (hour < 10) {
      [string appendFormat:@"0%d%@", hour, separator];
    } else {
      [string appendFormat:@"%d%@", hour, separator];
    }
  }
  if (minute > 0) {
    if (minute < 10) {
      [string appendFormat:@"0%d%@", minute, separator];
    } else {
      [string appendFormat:@"%d%@", minute, separator];
    }}
  if (second >= 0) {
    if (second < 10) {
      [string appendFormat:@"0%d", second];
    } else {
      [string appendFormat:@"%d", second];
    }}
  return string;
}

- (void)onEndTimer {
  [player_ play];
  UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@さん", record_.username] 
                                                  message:record_.message
                                                 delegate:self 
                                        cancelButtonTitle:@"キャンセル" 
                                        otherButtonTitles:nil];
  alert.tag = UIAlertViewTypeEnd;
  [alert show]; 
}

@end
