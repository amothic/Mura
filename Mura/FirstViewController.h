//
//  FirstViewController.h
//  Mura
//
//  Created by Daichi TOMA on 11/27/11.
//  Copyright (c) 2011 Daichi TOMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITextField *messageText;
    IBOutlet UIButton *sendButton;
    IBOutlet UITableView *messageList;
    
    NSMutableData *receivedData;
    NSMutableArray *messages;
    int lastId;
    
    NSTimer *timer;
    
    NSXMLParser *chatParser;
    NSString *msgAdded;
    NSMutableString *msgUser;
    NSMutableString *msgText;
    int msgId;
    Boolean inText;
    Boolean inUser;
}

@property (nonatomic,retain) UITextField *messageText;
@property (nonatomic,retain) UIButton *sendButton;
@property (nonatomic,retain) UITableView *messageList;

- (IBAction)sendClicked:(id)sender;


@end
