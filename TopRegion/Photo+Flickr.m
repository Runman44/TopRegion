//
//  Photo+Flickr.m
//  TopRegion
//
//  Created by Dennis Anderson on 6/3/14.
//  Copyright (c) 2014 MrAnderson. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "Photograph+Create.h" 

@implementation Photo (Flickr)


+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    
    NSString *photoId = [photoDictionary valueForKeyPath:FLICKR_PHOTO_ID];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"photoid = %@", photoId];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || [matches count] > 1) {
        // handle error
        #warning handle error
    } else if([matches count]){
        photo = [matches firstObject];
    } else {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.photoid = photoId;
        photo.title = [photoDictionary valueForKeyPath:FLICKR_PHOTO_TITLE];
        photo.subtitle = [photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.imageURL = [[FlickrFetcher URLforPhoto:photoDictionary format:FlickrPhotoFormatLarge] absoluteString];
        photo.placeid = [photoDictionary valueForKeyPath:FLICKR_PLACE_ID];
        NSString *photographerName = [photoDictionary valueForKeyPath:FLICKR_PHOTO_OWNER];
        NSLog(@"TEST, %@", [FlickrFetcher URLforInformationAboutPlace:photo.placeid]);

        photo.whoTook = ([Photograph photographerWithName:photographerName inManagedObjectContext:context]);
    }
    
    return photo;
}

+ (void)loadPhotosFromFlickrArray:(NSArray *)photos intoManagedObjectContext:(NSManagedObjectContext *)context
{
    #warning dit kan beter omdat je nu in de method 100x gaat fetching.. 50:20
    for (NSDictionary *photo in photos){
               [self photoWithFlickrInfo:photo inManagedObjectContext:context];
    }
    
}


@end
