//
//  SecondViewController.h
//  Mura
//
//  Created by Daichi TOMA on 11/27/11.
//  Copyright (c) 2011 Daichi TOMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController
{
    IBOutlet UITextField *userName;
}
@property (nonatomic,retain) UITextField *userName;

- (IBAction)nameEditingEnd:(id)sender;


@end
