//
//  DAAlermStandbyViewController.m
//  DungaAlerm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "DAAlermStandbyViewController.h"
#import "HttpAsyncConnection.h"

@interface DAAlermStandbyViewController ()
- (void)update:(NSTimer*)timer;
- (void)onRecivedResponse:(NSURLResponse*)res aConnection:(HttpAsyncConnection*)aConnection;
- (void)onSucceed:(NSURLConnection*)connection aConnection:(HttpAsyncConnection*)aConnection;
@end

@implementation DAAlermStandbyViewController
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
  self = [self initWithNibName:@"DAAlertStandbyView" bundle:nil];
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

- (void)update:(NSTimer *)timer {
  NSTimeInterval interval = [date_ timeIntervalSinceNow];
  if (interval <= 0) {
    HttpAsyncConnection* connection = [HttpAsyncConnection connection];
    connection.delegate = self;
    connection.responseSelector = @selector(onRecivedResponse:aConnection:);
    connection.finishSelector = @selector(onSucceed:aConnection:);
    [connection connectTo:[NSURL URLWithString:(NSString*)GET_API_URL]
                   params:[NSDictionary dictionary]
                   method:@"GET" 
                userAgent:@"DungaAlerm" 
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
}

@end
