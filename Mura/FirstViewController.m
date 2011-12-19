//
//  FirstViewController.m
//  Mura
//
//  Created by Daichi TOMA on 11/27/11.
//  Copyright (c) 2011 Daichi TOMA. All rights reserved.
//

#import "FirstViewController.h"

@implementation FirstViewController

@synthesize messageText, sendButton, messageList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		lastId = 0;
		chatParser = NULL;
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}

// Getting the message

- (void)getNewMessages {
	NSString *url = [NSString stringWithFormat:@"http://web.amothic.com/chat/messages.php?past=%ld&t=%ld",
					 lastId, time(0) ];

	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:url]];
	[request setHTTPMethod:@"GET"];

    NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn)
    {
        receivedData = [NSMutableData data];
    }
    else
    {
    }
}

- (void)timerCallback {
	[self getNewMessages];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	if ( messages == nil )
		messages = [[NSMutableArray alloc] init];

        chatParser = [[NSXMLParser alloc] initWithData:receivedData];
        [chatParser setDelegate:self];

    [chatParser parse];

	[messageList reloadData];

	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                [self methodSignatureForSelector: @selector(timerCallback)]];
	[invocation setTarget:self];
	[invocation setSelector:@selector(timerCallback)];
	timer = [NSTimer scheduledTimerWithTimeInterval:5.0 invocation:invocation repeats:NO];
}

// Parsing the XML message list

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	if ( [elementName isEqualToString:@"message"] ) {
		msgAdded = [attributeDict objectForKey:@"added"];
		msgId = [[attributeDict objectForKey:@"id"] intValue];
		msgUser = [[NSMutableString alloc] init];
		msgText = [[NSMutableString alloc] init];
		inUser = NO;
		inText = NO;
	}
	if ( [elementName isEqualToString:@"user"] ) {
		inUser = YES;
	}
	if ( [elementName isEqualToString:@"text"] ) {
		inText = YES;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if ( inUser ) {
		[msgUser appendString:string];
	}
	if ( inText ) {
		[msgText appendString:string];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ( [elementName isEqualToString:@"message"] ) {
		[messages addObject:[NSDictionary dictionaryWithObjectsAndKeys:msgAdded,@"added",msgUser,@"user",msgText,@"text",nil]];

		lastId = msgId;

	}
	if ( [elementName isEqualToString:@"user"] ) {
		inUser = NO;
	}
	if ( [elementName isEqualToString:@"text"] ) {
		inText = NO;
	}
}

// Driving The Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)myTableView numberOfRowsInSection:(NSInteger)section {
	return ( messages == nil ) ? 0 : [messages count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 75;
}

- (UITableViewCell *)tableView:(UITableView *)myTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = (UITableViewCell *)[self.messageList dequeueReusableCellWithIdentifier:@"ChatListItem"];
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChatListItem" owner:self options:nil];
		cell = (UITableViewCell *)[nib objectAtIndex:0];
	}

	NSDictionary *itemAtIndex = (NSDictionary *)[messages objectAtIndex:indexPath.row];
	UILabel *textLabel = (UILabel *)[cell viewWithTag:1];
	textLabel.text = [itemAtIndex objectForKey:@"text"];
	UILabel *userLabel = (UILabel *)[cell viewWithTag:2];
	userLabel.text = [itemAtIndex objectForKey:@"user"];

	return cell;
}

// Sending the message to the server

- (IBAction)sendClicked:(id)sender {
	[messageText resignFirstResponder];
	if ( [messageText.text length] > 0 ) {

		NSString *url = [NSString stringWithFormat:@"http://web.amothic.com/chat/add.php"];

		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
		[request setURL:[NSURL URLWithString:url]];
		[request setHTTPMethod:@"POST"];

		NSMutableData *body = [NSMutableData data];
		[body appendData:[[NSString stringWithFormat:@"user=%@&message=%@",
						   [UIDevice currentDevice].uniqueIdentifier,
						   messageText.text] dataUsingEncoding:NSUTF8StringEncoding]];
		[request setHTTPBody:body];

		NSHTTPURLResponse *response = nil;
		NSError *error = [[NSError alloc] init];
		[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

		[self getNewMessages];
	}

	messageText.text = @"";
}

// The inital loader

- (void)viewDidLoad {
    [super viewDidLoad];

	messageList.dataSource = self;
	messageList.delegate = self;

	[self getNewMessages];
}

@end