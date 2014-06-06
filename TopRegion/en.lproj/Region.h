//
//  Region.h
//  TopRegion
//
//  Created by Dennis Anderson on 6/4/14.
//  Copyright (c) 2014 MrAnderson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Place;

@interface Region : NSManagedObject

@property (nonatomic, retain) NSString * regionid;
@property (nonatomic, retain) NSString * regionname;
@property (nonatomic, retain) NSString * countryname;
@property (nonatomic, retain) NSSet *whichSpots;
@end

@interface Region (CoreDataGeneratedAccessors)

- (void)addWhichSpotsObject:(Place *)value;
- (void)removeWhichSpotsObject:(Place *)value;
- (void)addWhichSpots:(NSSet *)values;
- (void)removeWhichSpots:(NSSet *)values;

@end
