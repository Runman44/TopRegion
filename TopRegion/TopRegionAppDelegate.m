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
#import "Place+PhotoTaken.h"
#import "PhotoDatabaseAvailability.h"
#import "PrivateAppDelegate.h"
#import "TopRegionAppDelegate+Database.h"

@interface TopRegionAppDelegate() <NSURLSessionDownloadDelegate>

@property (copy, nonatomic) void (^flickrDownloadBackgroundSessionCompletionHandler)();
@property (nonatomic) NSURLSession *flickrDownloadSession;


@end

#define FLICKR_FETCH @"Flickr Photos Retrieve"
#define TIME_INTERVAL_FLICKR_FETCH 20*60

@implementation TopRegionAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self openManagedDocument];
    return YES;
}

- (void)setPhotoDatabaseContext:(NSManagedObjectContext *)photoDatabaseContext
{
    _photoDatabaseContext = photoDatabaseContext;
    if (self.photoDatabaseContext)
    {
        [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL_FLICKR_FETCH
                                         target:self
                                       selector:@selector(startFlickrFetch:)
                                       userInfo:nil
                                        repeats:YES];
        
        NSDictionary *userInfo = self.photoDatabaseContext ? @{PhotoDatabaseAvailabilityContext: self.photoDatabaseContext } : nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:PhotoDatabaseAvailabilityNotification object:self userInfo:userInfo];
        [self startFlickrFetch];
    } else {
        NSLog(@"No databaseContext set.");
    }
}

- (void)startFlickrFetch:(NSTimer *) timer
{
    [self startFlickrFetch];
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


- (void) application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // in lecture, we relied on our background flickrDownloadSession to do the fetch by calling [self startFlickrFetch]
    // that was easy to code up, but pretty weak in terms of how much it will actually fetch (maybe almost never)
    // that's because there's no guarantee that we'll be allowed to start that discretionary fetcher when we're in the background
    // so let's simply make a non-discretionary, non-background-session fetch here
    // we don't want it to take too long because the system will start to lose faith in us as a background fetcher and stop calling this as much
    // so we'll limit the fetch to BACKGROUND_FETCH_TIMEOUT seconds (also we won't use valuable cellular data)
    
}






@end
