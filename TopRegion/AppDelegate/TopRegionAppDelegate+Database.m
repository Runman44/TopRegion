//
//  TopRegionAppDelegate+Database.m
//  TopRegion
//
//  Created by Dennis Anderson on 6/8/14.
//  Copyright (c) 2014 MrAnderson. All rights reserved.
//

#import "TopRegionAppDelegate+Database.h"
#import "PrivateAppDelegate.h"

@implementation TopRegionAppDelegate (Database)

- (void) openManagedDocument
{
    // Maak een url path aan naar het document in het apparaat
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]firstObject];
    NSString *documentName = @"TopRegionData";
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
    
    // Maakt een managedDocument aan
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    // Kijk of het bestand al bestaat
    // BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[url path]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]){
        // opent bestaande document
        [document openWithCompletionHandler:^(BOOL success) {
            if(success) {
                self.photoDatabaseContext = document.managedObjectContext;
            } else if (!success){
                NSLog(@"Failed");
            }
        }];
    } else {
        // maakt nieuwe document aan
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
            if(success) {
                  self.photoDatabaseContext = document.managedObjectContext;
              } else if (!success){
                  NSLog(@"Failed with url %@", document);
              }
          }];
    }
}

@end
