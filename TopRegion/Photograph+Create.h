//
//  Photograph+Create.h
//  TopRegion
//
//  Created by Dennis Anderson on 6/3/14.
//  Copyright (c) 2014 MrAnderson. All rights reserved.
//

#import "Photograph.h"

@interface Photograph (Create)

+ (Photograph *)photographerWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;

@end
