//
//  ListFlickrMostRecentTVC.m
//  TopRegion
//
//  Created by Dennis Anderson on 6/7/14.
//  Copyright (c) 2014 MrAnderson. All rights reserved.
//

#import "ListFlickrMostRecentTVC.h"
#import "PhotoDatabaseAvailability.h"
#import "Photo+Flickr.h"
#import "ImageViewController.h"

@interface ListFlickrMostRecentTVC ()

@end

@implementation ListFlickrMostRecentTVC

- (void) awakeFromNib
{
    // listen to the radiotower that has been broadcast in the appdelegate
    [[NSNotificationCenter defaultCenter] addObserverForName:PhotoDatabaseAvailabilityNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.managedObjectContext = note.userInfo[PhotoDatabaseAvailabilityContext];
    }];
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    [self setupFetchedResultsController];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self setupFetchedResultsController];
}

#define MAXRESULTS 20

- (void)setupFetchedResultsController
{
    NSManagedObjectContext *context = self.managedObjectContext;
    
    if (context) {
        // fetch photos were lastViewed has been set
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.predicate = [NSPredicate predicateWithFormat:@"lastViewed != nil"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastViewed" ascending:NO]];
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
