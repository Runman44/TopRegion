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
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
        request.predicate = [NSPredicate predicateWithFormat:@"placeid = %@", placeId];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1)) {
            // handle error
        } else {
            if (![matches count]) {
                place = [NSEntityDescription insertNewObjectForEntityForName:@"Place"
                                                      inManagedObjectContext:context];
                place.placeid = placeId;
                
            } else {
                place = [matches lastObject];
            }
            
        }
    }
    return place;
}

@end
