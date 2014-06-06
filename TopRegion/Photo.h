//
//  Photo.h
//  TopRegion
//
//  Created by Dennis Anderson on 6/6/14.
//  Copyright (c) 2014 MrAnderson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photograph, Place, Region;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSDate * lastViewed;
@property (nonatomic, retain) NSString * photoid;
@property (nonatomic, retain) NSString * placeid;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * thumbnailData;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Place *wasTaken;
@property (nonatomic, retain) Photograph *whoTook;
@property (nonatomic, retain) Region *whichRegion;

@end
