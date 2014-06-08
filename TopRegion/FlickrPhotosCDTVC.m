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
# warning dit wil niet saven ! 
    photo.lastViewed = [NSDate date];
    if ([vc isKindOfClass:[ImageViewController class]]) {
        ImageViewController *ivc = (ImageViewController *)vc;
        ivc.imageData = [NSURL URLWithString:photo.imageURL];
        ivc.title = photo.title;
    }
}


// In a story board-based application, you will often want to do a little preparation before navigation
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id detailvc = [self.splitViewController.viewControllers lastObject];
    if ([detailvc isKindOfClass:[UINavigationController class]]) {
        detailvc = [((UINavigationController *)detailvc).viewControllers firstObject];
        [self prepareViewController:detailvc
                           forSegue:nil
                      fromIndexPath:indexPath];
    }
}

@end
