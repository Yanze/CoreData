//
//  DeviceViewController.m
//  CoreData
//
//  Created by yanze on 8/15/16.
//  Copyright © 2016 yanzeliu. All rights reserved.
//

#import "DeviceViewController.h"
#import <CoreData/CoreData.h>
#import "DetailViewController.h"

@interface DeviceViewController ()
// save all devices received
@property (nonatomic, strong) NSMutableArray *devices;
@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

// this method will be called automatically everytime a view is displayed.
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Device"];
    self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// grab managed object context
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


// pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.devices count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath:indexPath];
    
    // configure the cell
    NSManagedObject *device = [self.devices objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@ %@",
                             [device valueForKey:@"name"],
                             [device valueForKey:@"version"],
                             [device valueForKey:@"company"]]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // return NO if you don't want a specified item to be editable
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // we first grab context, which provides a deleteObject method that allows us to delete the specified object from db
    NSManagedObjectContext *context = [self managedObjectContext];
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [context deleteObject:[self.devices objectAtIndex:indexPath.row]];
        
         // then invoke the save method to commit the change
        NSError *error = nil;
        if(![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        // remove device from table view
        [self.devices removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                        withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"Update"]) {
        NSManagedObject *selectedDevice = [self.devices objectAtIndex:[[self.tableView indexPathForSelectedRow]row]];
        DetailViewController *detailVC = segue.destinationViewController;
        detailVC.device = selectedDevice;
    }
}



@end
