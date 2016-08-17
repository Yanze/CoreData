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
    
    if(self.device) {
        [self.nameField setText:[self.device valueForKey:@"name"]];
        [self.versionField setText:[self.device valueForKey:@"version"]];
        [self.companyField setText:[self.device valueForKey:@"company"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

    // every object core data stores is inherited from NSManagedObject.
- (IBAction)save:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if(self.device) {
        // updating existing device
        [self.device setValue: self.nameField.text forKey: @"name"];
        [self.device setValue: self.versionField.text forKey: @"version"];
        [self.device setValue: self.companyField.text forKey: @"company"];
    }
    else {
        // creating a new device
        // create a new managed object
        // a managed object is associated with an entity descrption that provides matadata about the object (including the name of the entity that the object represents and the names of its attributes and relations) and with a managed context that tracks changes to the object graph.
        NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Device" inManagedObjectContext:context];
        [newDevice setValue: self.nameField.text forKey: @"name"];
        [newDevice setValue: self.versionField.text forKey: @"version"];
        [newDevice setValue: self.companyField.text forKey: @"company"];
    }
    
    NSError *error = nil;
    // save the object to persistent store
    if(![context save:&error]){
        NSLog(@"Can't save %@ %@", error, [error localizedDescription]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

// we selected core data option when creating a new project, xcode will automatically define a managed object context in AppDelegate.
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
