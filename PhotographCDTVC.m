//
//  PhotographCDTVC.m
//  TopRegion
//
//  Created by Dennis Anderson on 6/3/14.
//  Copyright (c) 2014 MrAnderson. All rights reserved.
//

#import "PhotographCDTVC.h"
#import "PhotoDatabaseAvailability.h"
#import "Photograph.h"


@interface PhotographCDTVC ()

@end

@implementation PhotographCDTVC

- (void) awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserverForName:PhotoDatabaseAvailabilityNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.managedObjectContext = note.userInfo[PhotoDatabaseAvailabilityContext];
    }];
}

-(void) setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photograph"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Photograph Cell"];
    
    Photograph *photograph = [self.fetchedResultsController objectAtIndexPath:indexPath];

    cell.textLabel.text = photograph.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos",[photograph.photos count]];
    
    return cell;
}

@end
