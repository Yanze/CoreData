//
//  DetailViewController.m
//  CoreData
//
//  Created by yanze on 8/15/16.
//  Copyright © 2016 yanzeliu. All rights reserved.
//

#import "DetailViewController.h"
#import <CoreData/CoreData.h>

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)cancel:(id)sender {
    NSLog(@"cancel");
    [self.navigationController popViewControllerAnimated:YES];
}

    // every object core data stores is inherited from NSManagedObject.
- (IBAction)save:(id)sender {
    NSLog(@"save");
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // create a new managed object
    NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Device" inManagedObjectContext:context];
    [newDevice setValue: self.nameField.text forKey: @"name"];
    [newDevice setValue: self.versionField.text forKey: @"version"];
    [newDevice setValue: self.companyField.text forKey: @"company"];
    
    NSError *error = nil;
    // save the object to persistent store
    if(![context save:&error]){
        NSLog(@"Can't save %@ %@", error, [error localizedDescription]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

// selecting core data when create a new project, xcode will automatically define a managed object context in AppDelegate.
// this method allows us to retrieve the managed object context from the AppDelegate
// later we will use the context to save the device data
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication]delegate];
    if([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


@end
