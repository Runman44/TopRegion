//
//  TopRegionAppDelegate.m
//  TopRegion
//
//  Created by Dennis Anderson on 5/20/14.
//  Copyright (c) 2014 MrAnderson. All rights reserved.
//

#import "TopRegionAppDelegate.h"
#import "FlickrFetcher.h"
#import "Photo+Flickr.h"
#import "PhotoDatabaseAvailability.h"

@interface TopRegionAppDelegate() <NSURLSessionDownloadDelegate>

@property (copy, nonatomic) void (^flickrDownloadBackgroundSessionCompletionHandler)();
@property (nonatomic) NSURLSession *flickrDownloadSession;
@property (nonatomic) NSManagedObjectContext *photoDatabaseContext;

@end

#define FLICKR_FETCH @"Flickr Photos Retrieve"

@implementation TopRegionAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    # warning create UIManagedDocument !!
    
    // Maak een url path aan naar het document in het apparaat
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]firstObject];
    NSString *documentName = @"MyTestData";
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
    
    // Maakt een managedDocument aan
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    // Kijk of het bestand al bestaat
    // BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[url path]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]){
        // opent bestaande document
        [document openWithCompletionHandler:^(BOOL success) {
            NSLog(@"Its Done !");
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
              NSLog(@"Its Done ! and created it !");
              if(success) {
                  self.photoDatabaseContext = document.managedObjectContext;
              } else if (!success){
                  NSLog(@"Failed with url %@", document);
              }
          }];
    }

    [self startFlickrFetch];
    return YES;
}

- (void)setPhotoDatabaseContext:(NSManagedObjectContext *)photoDatabaseContext
{
    _photoDatabaseContext = photoDatabaseContext;
    
    NSDictionary *userInfo = self.photoDatabaseContext ? @{PhotoDatabaseAvailabilityContext: self.photoDatabaseContext } : nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoDatabaseAvailabilityNotification object:self userInfo:userInfo];
}

- (void)startFlickrFetch
{
    [self.flickrDownloadSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        if (![downloadTasks count]) {
            NSURLSessionDownloadTask *task = [self.flickrDownloadSession downloadTaskWithURL:[FlickrFetcher URLforRecentGeoreferencedPhotos]];
            task.taskDescription = FLICKR_FETCH;
            [task resume];
        } else {
            for (NSURLSessionDownloadTask *task in downloadTasks) {
                [task resume];
            }
        }
    }];
}

- (NSURLSession *)flickrDownloadSession
{
    if(!_flickrDownloadSession) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSURLSessionConfiguration *urlSessionConfig = [NSURLSessionConfiguration backgroundSessionConfiguration:FLICKR_FETCH];
            urlSessionConfig.allowsCellularAccess = NO;
            _flickrDownloadSession = [NSURLSession sessionWithConfiguration:urlSessionConfig delegate:self delegateQueue:nil];
        });
    }
    
    return _flickrDownloadSession;
}

- (NSArray *)flickrPhotosAtURL:(NSURL *)url
{
    NSData *flickrJSONData = [NSData dataWithContentsOfURL:url];
    NSDictionary *flickrPropertyList = [NSJSONSerialization JSONObjectWithData:flickrJSONData options:0 error:NULL];
    return [flickrPropertyList valueForKeyPath:FLICKR_RESULTS_PHOTOS];
}

#pragma Delegate

// completion handler
- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)localFile
{
    if ([downloadTask.taskDescription isEqualToString:FLICKR_FETCH]) {
        NSManagedObjectContext *context = self.photoDatabaseContext;
        if (context) {
            NSArray *photos = [self flickrPhotosAtURL:localFile];
            [context performBlock:^{
                [Photo loadPhotosFromFlickrArray:photos intoManagedObjectContext:context];
                #warning save context
            }];
        } else {
            [self flickrDownloadTaskMightBeComplete];
        }
    }
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}

- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
}

- (void) flickrDownloadTaskMightBeComplete
{
    
}

















@end
