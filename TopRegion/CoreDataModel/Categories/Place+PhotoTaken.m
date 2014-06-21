//
//  Place+PhotoTaken.m
//  TopRegion
//
//  Created by Dennis Anderson on 6/4/14.
//  Copyright (c) 2014 MrAnderson. All rights reserved.
//

#import "Place+PhotoTaken.h"
#import "FlickrFetcher.h"
#import "Region+Create.h"

@implementation Place (PhotoTaken)


+ (Place*)placeWithId:(NSString *)placeId
inManagedObjectContext:(NSManagedObjectContext *)context
{
    Place *place = nil;
    
    if ([placeId length]) {
        // fetch place by a certain id
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
        request.predicate = [NSPredicate predicateWithFormat:@"placeid = %@", placeId];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        // if fetch doesn't match or match is greater then one or an error occurred
        if (!matches || error || [matches count] > 1) {
            NSLog(@"No region fetch, %@", error);
        } else {
            if (![matches count]) {
                // if no places exists by that id, create a place
                place = [NSEntityDescription insertNewObjectForEntityForName:@"Place"
                                                      inManagedObjectContext:context];
                place.placeid = placeId;
                
            } else {
                // if there is a match, take that place
                place = [matches lastObject];
            }
            
        }
    }
    return place;
}

@end
