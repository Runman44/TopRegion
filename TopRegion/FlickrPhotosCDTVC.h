//
//  FlickrPhotosCDTVC.h
//  TopRegion
//
//  Created by Dennis Anderson on 6/6/14.
//  Copyright (c) 2014 MrAnderson. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface FlickrPhotosCDTVC : CoreDataTableViewController

- (void)prepareViewController:(id)vc
                     forSegue:(NSString *)segueIdentifer
                fromIndexPath:(NSIndexPath *)indexPath;

@end
