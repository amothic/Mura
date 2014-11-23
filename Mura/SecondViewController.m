//
//  SecondViewController.m
//  Mura
//
//  Created by Daichi TOMA on 11/27/11.
//  Copyright (c) 2011 Daichi TOMA. All rights reserved.
//

#import "SecondViewController.h"

@implementation SecondViewController

@synthesize userName;

- (IBAction)nameEditingEnd:(id)sender
{
    [userName resignFirstResponder];

    if ( [userName.text length] > 0 ) {

        NSString *url = [NSString stringWithFormat:@"http://web.amothic.com/chat/settings.php"];

		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
		[request setURL:[NSURL URLWithString:url]];
		[request setHTTPMethod:@"POST"];

		NSMutableData *body = [NSMutableData data];
		[body appendData:[[NSString stringWithFormat:@"user=%@&name=%@",
						   [UIDevice currentDevice].uniqueIdentifier,
						   userName.text] dataUsingEncoding:NSUTF8StringEncoding]];
		[request setHTTPBody:body];

		NSHTTPURLResponse *response = nil;
		NSError *error = [[NSError alloc] init];
		[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
