//
//  Photo.h
//  TopRegion
//
//  Created by Dennis Anderson on 6/21/14.
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
@property (nonatomic, retain) NSData * thumbnailData;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) Place *wasTaken;
@property (nonatomic, retain) Region *whichRegion;
@property (nonatomic, retain) Photograph *whoTook;

@end
