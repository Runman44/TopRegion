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
    // Making a URL Path to the physical document on the mobile device
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]firstObject];
    NSString *documentName = @"TopRegionData";
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];

    // Making a managedDocument
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    // Check if the document already exists
    // BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[url path]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]){
        // opens the document and sets the managedObjectContext
        [document openWithCompletionHandler:^(BOOL success) {
            if(success) {
                self.photoDatabaseContext = document.managedObjectContext;
            } else if (!success){
                NSLog(@"Failed");
            }
        }];
    } else {
        // creates the document and sets the managedObjectContext
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
