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
                                                                                   cacheName:nil];}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Region Cell"];
    
    Region *region = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = region.regionname;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ photograph",region.numofPhotographer];
    
    return cell;
}

@end
