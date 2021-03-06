//
//  FlickrPhotosCDTVC.m
//  TopRegion
//
//  Created by Dennis Anderson on 6/6/14.
//  Copyright (c) 2014 MrAnderson. All rights reserved.
//

#import "FlickrPhotosCDTVC.h"
#import "Photo.h"
#import "ImageViewController.h"

@interface FlickrPhotosCDTVC ()

@end

@implementation FlickrPhotosCDTVC

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Flickr Photo Cell"];
    // styling the tableviewstyle for the photos
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *title = photo.title;
    NSString *description = photo.subtitle;
    if ([title length]) {
        cell.textLabel.text = title;
        cell.detailTextLabel.text = description;
    }
    else if (![title length] && [description length]) {
        cell.textLabel.text = description;
        cell.detailTextLabel.text = @"";
    }
    else {
        cell.textLabel.text = @"Unknown";
        cell.detailTextLabel.text = @"";
    }
    cell.imageView.image = [UIImage imageWithData:photo.thumbnailData];
    // if the tumbnail data hasn't been fetch yet start a new thread and fetch it
    if (!cell.imageView.image) {
        dispatch_queue_t q = dispatch_queue_create("Thumbnail Flickr Photo", 0);
        dispatch_async(q, ^{
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:photo.thumbnailURL]];
            [photo.managedObjectContext performBlock:^{
                // set the tumbnaildata, autosave into the database
                photo.thumbnailData = imageData;
                dispatch_async(dispatch_get_main_queue(), ^{
                    // regenerate the table so the tumbnail is visible
                    [cell setNeedsLayout];
                });
            }];
        });
    }
    return cell;
}

#pragma mark - Navigation

// prepares the given ImageViewController to show the given photo
// used either when segueing to an ImageViewController
//   or when our UISplitViewController's Detail view controller is an ImageViewController
- (void)prepareViewController:(id)vc
                     forSegue:(NSString *)segueIdentifer
                fromIndexPath:(NSIndexPath *)indexPath
{
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // set lastViewed when the user clicked on the photo
    photo.lastViewed = [NSDate date];
    NSError *error;
    [photo.managedObjectContext save:&error];
    if ([vc isKindOfClass:[ImageViewController class]]) {
        ImageViewController *ivc = (ImageViewController *)vc;
        ivc.imageData = [NSURL URLWithString:photo.imageURL];
        ivc.title = photo.title;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    [self prepareViewController:segue.destinationViewController
                       forSegue:segue.identifier
                  fromIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id detail = self.splitViewController.viewControllers[1];
    if ([detail isKindOfClass:[UINavigationController class]]) {
        detail = [((UINavigationController *)detail).viewControllers firstObject];
    }
    if ([detail isKindOfClass:[ImageViewController class]]) {
        [self prepareViewController:detail forSegue:nil fromIndexPath:indexPath];
    }
}

@end
