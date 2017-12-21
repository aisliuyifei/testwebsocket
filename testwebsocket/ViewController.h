//
//  ViewController.h
//  testwebsocket
//
//  Created by wupeng on 20/12/2017.
//  Copyright © 2017 wupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PocketSocket/PSWebSocket.h>

@interface ViewController : UIViewController<PSWebSocketDelegate >{
    IBOutlet UILabel *label;
    PSWebSocket *_webSocket;
}


@end

