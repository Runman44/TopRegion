//
//  RegionCDTVC.m
//  TopRegion
//
//  Created by Dennis Anderson on 6/4/14.
//  Copyright (c) 2014 MrAnderson. All rights reserved.
//

#import "RegionCDTVC.h"
#import "PhotoDatabaseAvailability.h"
#import "Region.h"
#import "ListFlickrPhotosTVC.h"

@interface RegionCDTVC ()

@end

@implementation RegionCDTVC

#define MAX_REGIONS 50

- (void) awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserverForName:PhotoDatabaseAvailabilityNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.managedObjectContext = note.userInfo[PhotoDatabaseAvailabilityContext];
    }];
}

-(void) setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"numofPhotographer"
                                                              ascending:NO],
                                [NSSortDescriptor sortDescriptorWithKey:@"regionname"
                                                              ascending:NO
                                                               selector:@selector(localizedStandardCompare:)]];
    [request setFetchLimit:MAX_REGIONS];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Region Cell"];
    
    Region *region = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (region.regionname){
    cell.textLabel.text = region.regionname;
    } else {
    cell.textLabel.text = @"Unknown";
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ photograph",region.numofPhotographer];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareViewController:(id)vc forSegue:(NSString *)segueIdentifer fromIndexPath:(NSIndexPath *)indexPath
{
    Region *region = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([vc isKindOfClass:[ListFlickrPhotosTVC class]]) {
        ListFlickrPhotosTVC *lfptvc = (ListFlickrPhotosTVC *)vc;
        lfptvc.region = region;
    }
}

// boilerplate
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    [self prepareViewController:segue.destinationViewController
                       forSegue:segue.identifier
                  fromIndexPath:indexPath];
}

@end
