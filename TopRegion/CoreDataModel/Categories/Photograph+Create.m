//
//  Photograph+Create.m
//  TopRegion
//
//  Created by Dennis Anderson on 6/3/14.
//  Copyright (c) 2014 MrAnderson. All rights reserved.
//

#import "Photograph+Create.h"

@implementation Photograph (Create)

+ (Photograph *)photographerWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photograph *photograph = nil;
    
    if ([name length]) {
        // fetch a photograph by a certain name
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photograph"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];

        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        // if fetch doesn't match or is greater then one or an error occurred
        if (!matches || error || [matches count] > 1) {
            NSLog(@"No photograph fetch, %@", error);
        } else if(![matches count]){
            // if there isn't a match, create a photograph
             photograph = [NSEntityDescription insertNewObjectForEntityForName:@"Photograph" inManagedObjectContext:context];
             photograph.name = name;
            
        } else {
            // if there is a match, take that one as the photograph
            photograph = [matches lastObject];
        }
    }
    return photograph;
}

@end
