//
//  Place.h
//  TopRegion
//
//  Created by Dennis Anderson on 6/6/14.
//  Copyright (c) 2014 MrAnderson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo, Region;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * placeid;
@property (nonatomic, retain) Region *whichRegion;
@property (nonatomic, retain) NSSet *photos;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
