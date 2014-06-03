//
//  Photograph+Create.m
//  TopRegion
//
//  Created by Dennis Anderson on 6/3/14.
//  Copyright (c) 2014 MrAnderson. All rights reserved.
//

#import "Photograph+Create.h"

@implementation Photograph (Create)

+ (Photograph *)photographerWithName:(NSString *)name inManagedObjectCOntext:(NSManagedObjectContext *)context
{
    Photograph *photograph = nil;
    
    if ([name length]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photograph"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];

        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || error || [matches count] > 1) {
            // handle error
            #warning handle error
        } else if([matches count]){
            photograph = [matches lastObject];
        } else {
            photograph = [NSEntityDescription insertNewObjectForEntityForName:@"Photographer" inManagedObjectContext:context];
        }
    }
  
    return photograph;
}

@end
