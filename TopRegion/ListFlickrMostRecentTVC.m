//
//  ListFlickrMostRecentTVC.m
//  TopRegion
//
//  Created by Dennis Anderson on 6/7/14.
//  Copyright (c) 2014 MrAnderson. All rights reserved.
//

#import "ListFlickrMostRecentTVC.h"
#import "PhotoDatabaseAvailability.h"

@interface ListFlickrMostRecentTVC ()

@end

@implementation ListFlickrMostRecentTVC


- (void) viewDidLoad
{
    [self setupFetchedResultsController];
}

#define MAXRESULTS 50

- (void)setupFetchedResultsController
{
    NSManagedObjectContext *context = self.managedObjectContext;
    
    if (context) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.predicate = nil;
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastViewed"
                                                                  ascending:NO
                                                                   selector:@selector(localizedStandardCompare:)]];
        request.fetchLimit = MAXRESULTS;
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:context
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}
@end
