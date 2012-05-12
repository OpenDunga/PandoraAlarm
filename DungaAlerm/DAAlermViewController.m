//
//  DAAlermViewController.m
//  DungaAlerm
//
//  Created by  on 2012/5/12.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "DAAlermViewController.h"
#import "DAAlerm.h"
#import "HttpAsyncConnection.h"

@interface DAAlermViewController ()
- (void)onRecivedResponse:(NSURLResponse*)res aConnection:(HttpAsyncConnection*)aConnection;
- (void)onSucceed:(NSURLConnection*)connection aConnection:(HttpAsyncConnection*)aConnection;
@end

@implementation DAAlermViewController
const NSString* GET_API_URL = @"http://192.168.11.125/~takamatsu/cookpad/get.php";

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
  HttpAsyncConnection* connection = [HttpAsyncConnection connection];
  connection.delegate = self;
  connection.responseSelector = @selector(onRecivedResponse:aConnection:);
  connection.finishSelector = @selector(onSucceed:aConnection:);
  [connection connectTo:[NSURL URLWithString:(NSString*)GET_API_URL]
                                      params:[NSDictionary dictionary]
                                      method:@"GET" 
                                   userAgent:@"DungaAlerm" 
                                  httpHeader:@"namaco"];
  NSLog(@"%@", connection);
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

- (void)onRecivedResponse:(NSURLResponse *)res aConnection:(HttpAsyncConnection *)aConnection {
  NSLog(@"%@", aConnection);
}

- (void)onSucceed:(NSURLConnection *)connection aConnection:(HttpAsyncConnection *)aConnection {
  NSLog(@"%@", aConnection.data);
  NSError* err;
  player_ = [[AVAudioPlayer alloc] initWithData:aConnection.data error:&err];
  if (err) {
    NSLog(@"%@", err);
  }
  [player_ play];
}

@end
