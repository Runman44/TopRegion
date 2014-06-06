//
//  Region+Create.h
//  TopRegion
//
//  Created by Dennis Anderson on 6/4/14.
//  Copyright (c) 2014 MrAnderson. All rights reserved.
//

#import "Region.h"

@interface Region (Create)


+ (Region *)regionWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;


@end
