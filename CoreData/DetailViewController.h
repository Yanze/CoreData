//
//  DetailViewController.h
//  CoreData
//
//  Created by yanze on 8/15/16.
//  Copyright © 2016 yanzeliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *versionField;
@property (weak, nonatomic) IBOutlet UITextField *companyField;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;


@end
