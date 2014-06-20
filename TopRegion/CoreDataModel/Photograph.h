//
//  Photograph.h
//  TopRegion
//
//  Created by Dennis Anderson on 6/6/14.
//  Copyright (c) 2014 MrAnderson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo, Region;

@interface Photograph : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) NSSet *whichRegions;
@end

@interface Photograph (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

- (void)addWhichRegionsObject:(Region *)value;
- (void)removeWhichRegionsObject:(Region *)value;
- (void)addWhichRegions:(NSSet *)values;
- (void)removeWhichRegions:(NSSet *)values;

@end
