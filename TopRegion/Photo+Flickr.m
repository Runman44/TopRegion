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
#import "Place+PhotoTaken.h"
#import "Region+Create.h"

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
        NSString *placeid = [photoDictionary valueForKey:FLICKR_PLACE_ID];
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.photoid = photoId;
        photo.title = [photoDictionary valueForKeyPath:FLICKR_PHOTO_TITLE];
        photo.subtitle = [photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.imageURL = [[FlickrFetcher URLforPhoto:photoDictionary format:FlickrPhotoFormatLarge] absoluteString];
        photo.placeid = [photoDictionary valueForKeyPath:FLICKR_PLACE_ID];
        NSString *photographerName = [photoDictionary valueForKeyPath:FLICKR_PHOTO_OWNER];

        photo.wasTaken = [Place placeWithId:placeid inManagedObjectContext:context];
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
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.predicate = [NSPredicate predicateWithFormat:@"whichRegion = nil"];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || error) {
        // handle error
    } else{
        dispatch_queue_t fetchQ = dispatch_queue_create("Flickr fetcher", NULL);
        // put a block to do the fetch onto that queue
        dispatch_async(fetchQ, ^{
            for (Place *place in matches){
                // NSLog(@"Fetching Region Info");
                // fetch the JSON data from Flickr
                NSURL *url = [FlickrFetcher URLforInformationAboutPlace:place.placeid];
                NSData *jsonResults = [NSData dataWithContentsOfURL:url];
                // convert it to a Property List (NSArray and NSDictionary)
                NSDictionary *placeInformation = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                                 options:0
                                                                                   error:NULL];
                NSString *regionname = [FlickrFetcher extractRegionNameFromPlaceInformation:placeInformation];
                dispatch_async(dispatch_get_main_queue(),^(){
                    [context performBlock:^{
                        place.whichRegion = [Region regionWithName:regionname inManagedObjectContext:context];
                        for (Photo *photo in place.photos) {
                            photo.whichRegion = place.whichRegion;
                            if (![photo.whoTook.whichRegions containsObject:photo.whichRegion]) {
                                int value = [photo.whichRegion.numofPhotographer intValue];
                                photo.whichRegion.numofPhotographer=[NSNumber numberWithInt:value + 1];
                                [photo.whoTook addWhichRegionsObject:photo.whichRegion];
                            }
                        }
                    }];
                });
            }
        });
    }
    
}


@end
