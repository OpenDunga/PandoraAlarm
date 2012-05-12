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
- (NSString*)formatedTimeFromTimeInterval:(NSTimeInterval)interval;
@end

@implementation DAAlarmStandbyViewController
const NSString* GET_API_URL = @"http://192.168.11.125/~takamatsu/cookpad/get.php";

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
    date_ = date;
    timer_ = [NSTimer scheduledTimerWithTimeInterval:1.0 
                                              target:self 
                                            selector:@selector(update:) 
                                            userInfo:nil 
                                             repeats:YES];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  NSTimeInterval interval = [date_ timeIntervalSinceNow];
  remainLabel_.text = [self formatedTimeFromTimeInterval:interval];
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
  remainLabel_.text = [self formatedTimeFromTimeInterval:interval];
  if (interval <= 0) {
    HttpAsyncConnection* connection = [HttpAsyncConnection connection];
    connection.delegate = self;
    connection.responseSelector = @selector(onRecivedResponse:aConnection:);
    connection.finishSelector = @selector(onSucceed:aConnection:);
    [connection connectTo:[NSURL URLWithString:(NSString*)GET_API_URL]
                   params:[NSDictionary dictionary]
                   method:@"GET" 
                userAgent:@"DungaAlarm" 
               httpHeader:@"namaco"];
    [timer_ invalidate];
  }
}

- (void)onRecivedResponse:(NSURLResponse *)res aConnection:(HttpAsyncConnection *)aConnection {
}

- (void)onSucceed:(NSURLConnection *)connection aConnection:(HttpAsyncConnection *)aConnection {
  NSError* err;
  player_ = [[AVAudioPlayer alloc] initWithData:aConnection.data error:&err];
  if (err) {
    NSLog(@"%@", err);
  }
  [player_ play];
}

- (IBAction)pressStopButton:(id)sender {
  UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"アラームの停止" 
                                                  message:@"アラームを停止させて戻ります。よろしいですか？" 
                                                 delegate:self 
                                        cancelButtonTitle:@"キャンセル" 
                                        otherButtonTitles:@"停止", nil];
  [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    [self dismissModalViewControllerAnimated:YES];
  }
}

- (NSString*)formatedTimeFromTimeInterval:(NSTimeInterval)interval {
  NSMutableString* string = [NSMutableString string];
  if (interval <= 0) {
    [string appendString:@"0秒"];
    return string;
  }
  int hour = floor(interval / 3600);
  int minute = floor((interval - 3600 * hour) / 60);
  int second = floor(interval - 3600 * hour - minute * 60);
  if (hour > 0) {
    [string appendFormat:@"%d時間", hour];
  }
  if (minute > 0) {
    [string appendFormat:@"%d分", minute];
  }
  if (second > 0) {
    [string appendFormat:@"%d秒", second];
  }
  return string;
}

@end
