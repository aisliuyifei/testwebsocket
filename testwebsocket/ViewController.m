//
//  ViewController.m
//  testwebsocket
//
//  Created by wupeng on 20/12/2017.
//  Copyright © 2017 wupeng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [label setText:@""];
    [self initSocket];
}

-(void)initSocket{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://localhost:3000/cable"]];
    _webSocket = [PSWebSocket clientSocketWithRequest:request];
    _webSocket.delegate = self;
    [_webSocket open];
}

-(void)joinChannel:(NSString *)channelName
{
    NSString *strChannel = [NSString stringWithFormat:@"{ \"channel\": \"%@\" }",channelName];
    
    id data = @{
                @"command": @"subscribe",
                @"identifier": strChannel
                };
    
    NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:data options:0 error:nil];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"myString= %@", myString);
    
    [_webSocket send:myString];
}


-(void)webSocketDidOpen:(PSWebSocket *)webSocket
{
    NSLog(@"The websocket handshake completed and is now open!");
    
    [self joinChannel:@"MessagesChannel"];
}

-(void)webSocket:(PSWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSString *messageType = json[@"type"];
    
    if(![messageType isEqualToString:@"ping"] && ![messageType isEqualToString:@"welcome"] &&![messageType isEqualToString:@"confirm_subscription"])
    {
        NSLog(@"The websocket received a message: %@", json[@"message"]);
        [label setText:[NSString stringWithFormat:@"%@%@: %@\n",[label text],json[@"message"][@"user"],json[@"message"][@"message"]]];
    }
}

-(void)webSocket:(PSWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"The websocket handshake/connection failed with an error: %@", error);
}

-(void)webSocket:(PSWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"The websocket closed with code: %@, reason: %@, wasClean: %@", @(code), reason, (wasClean) ? @"YES": @"NO");
}





@end
