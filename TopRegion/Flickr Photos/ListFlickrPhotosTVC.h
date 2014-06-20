//
//  TopPhotoOfPlacesViewController.h
//  TopPlaces
//
//  Created by Dennis Anderson on 5/4/14.
//  Copyright (c) 2014 MrAnderson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Region.h"
#import "FlickrPhotosCDTVC.h"

@interface ListFlickrPhotosTVC : FlickrPhotosCDTVC

@property (nonatomic, strong)Region *region;

@end
