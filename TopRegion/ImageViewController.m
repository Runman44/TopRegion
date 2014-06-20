//
//  ImageViewController.m
//  TopPlaces
//
//  Created by Dennis Anderson on 5/5/14.
//  Copyright (c) 2014 MrAnderson. All rights reserved.
//

#import "ImageViewController.h"
#import "FlickrFetcher.h"

@interface ImageViewController () <UIScrollViewDelegate, UISplitViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;

@end

@implementation ImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
}

# pragma Properties


// 4. when the scrollview is set the contentsize will be as big as the imageview in it.
- (void) setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    _scrollView.minimumZoomScale=0.2;
    _scrollView.maximumZoomScale=3.0;
    _scrollView.delegate = self;
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}

// 3. here the size of the imageview will be the same as the image in it. The zoomscale will be reset.
- (void)setImage:(UIImage *)image
{
    self.scrollView.zoomScale = 1.0;
    self.imageView.image = image;
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
    [self setZoomScale];
    [self.spinner stopAnimating];
}

// returns imageView
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

// returns image
- (UIImage *)image
{
    return self.imageView.image;
}

- (void) setZoomScale
{
    double yScale = self.scrollView.bounds.size.height / self.image.size.height;
    double xScale = self.scrollView.bounds.size.width / self.image.size.width;
    double hScale;
    if(yScale > xScale){
         hScale = yScale;
    } else {
         hScale = xScale;
    }
    self.scrollView.zoomScale = hScale;
}

// 1. when the imageData is set, the download for the image can begin
- (void) setImageData:(NSURL *)imageData
{
    _imageData = imageData;
    [self fetch];
}

# pragma fetching results

// 2. downloading the image and setting the UIImage to be that image
-(void)fetch{
    [self.spinner startAnimating];
    dispatch_queue_t fetchPhoto = dispatch_queue_create("picture of photo", NULL);
    dispatch_async(fetchPhoto, ^(void){
        NSData *imageData = [NSData dataWithContentsOfURL:self.imageData];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.image = [UIImage imageWithData:imageData];;
        });
    });
}

#pragma imageViewController - Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma SplitViewController - Delegate

- (void) awakeFromNib
{
    self.splitViewController.delegate = self;
}

- (BOOL) splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

- (void) splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.image = [UIImage imageNamed:@"HamburgerIcon.png"];
    barButtonItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void) splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationItem.leftBarButtonItem = nil;
}

@end
