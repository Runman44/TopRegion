//
//  Region+Create.m
//  TopRegion
//
//  Created by Dennis Anderson on 6/4/14.
//  Copyright (c) 2014 MrAnderson. All rights reserved.
//

#import "Region+Create.h"

@implementation Region (Create)

+ (Region *)regionWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    Region *region = nil;
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
    request.predicate = [NSPredicate predicateWithFormat:@"regionname = %@", name];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    // if fetch doesn't match or match is greater then one or an error occurred
    if (!matches || error || [matches count] > 1) {
        NSLog(@"No region fetch, %@", error);
    } else if([matches count]){
        region = [matches firstObject];
    } else {
        region = [NSEntityDescription insertNewObjectForEntityForName:@"Region" inManagedObjectContext:context];
        region.regionname = name;
    }
    return region;
}


@end
