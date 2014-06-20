//
//  Place+PhotoTaken.h
//  TopRegion
//
//  Created by Dennis Anderson on 6/4/14.
//  Copyright (c) 2014 MrAnderson. All rights reserved.
//

#import "Place.h"

@interface Place (PhotoTaken)

+ (Place*)placeWithId:(NSString *)placeId
inManagedObjectContext:(NSManagedObjectContext *)context;
@end
