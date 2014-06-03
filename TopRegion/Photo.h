//
//  Photo.h
//  TopRegion
//
//  Created by Dennis Anderson on 6/3/14.
//  Copyright (c) 2014 MrAnderson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photograph;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * thumbnailData;
@property (nonatomic, retain) NSString * photoid;
@property (nonatomic, retain) NSDate * lastViewed;
@property (nonatomic, retain) Photograph *whoTook;

@end
