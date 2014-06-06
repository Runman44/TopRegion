//
//  Region.h
//  TopRegion
//
//  Created by Dennis Anderson on 6/6/14.
//  Copyright (c) 2014 MrAnderson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo, Photograph, Place;

@interface Region : NSManagedObject

@property (nonatomic, retain) NSString * regionname;
@property (nonatomic, retain) NSNumber * numofPhotographer;
@property (nonatomic, retain) NSSet *places;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) NSSet *photographs;
@end

@interface Region (CoreDataGeneratedAccessors)

- (void)addPlacesObject:(Place *)value;
- (void)removePlacesObject:(Place *)value;
- (void)addPlaces:(NSSet *)values;
- (void)removePlaces:(NSSet *)values;

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

- (void)addPhotographsObject:(Photograph *)value;
- (void)removePhotographsObject:(Photograph *)value;
- (void)addPhotographs:(NSSet *)values;
- (void)removePhotographs:(NSSet *)values;

@end
