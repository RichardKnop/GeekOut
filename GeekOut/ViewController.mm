//
//  ViewController.m
//  GeekOut
//
//  Created by Richard Knop on 06/04/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import "ViewController.h"
#import "FilterCollectionController.h"
#import "Filter.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize videoCamera;
@synthesize isStarted;
@synthesize videoFilter;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    isStarted = NO;
    videoFilter = -1;
    
    UIBarButtonItem *filtersButton = [[UIBarButtonItem alloc] initWithTitle:@"Filters" style:UIBarButtonItemStyleBordered target:self action:@selector(filtersClicked)];
    self.navigationItem.rightBarButtonItem = filtersButton;
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationController.toolbar setBarStyle:UIBarStyleDefault];
    
    videoCamera = [[CvVideoCamera alloc] initWithParentView:self.imageView];
    videoCamera.delegate = self;
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    videoCamera.defaultFPS = 30;
    videoCamera.grayscaleMode = NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"GoToFiltersSegue"])
    {
        FilterCollectionController *filterCollectionController = segue.destinationViewController;
        filterCollectionController.changeVideoFilterDelegate = self;
        filterCollectionController.selectedFilter = videoFilter;
    }
}

- (void)changeVideoFilter:(NSInteger)filter
{
    videoFilter = filter;
}

- (void)viewWillAppear:(BOOL)animated
{
    // TODO
}

- (void)viewWillDisappear:(BOOL)animated
{
    // TODO
}

#pragma mark - Protocol CvVideoCameraDelegate

#ifdef __cplusplus
- (void)processImage:(Mat&)image;
{
    Filter *filter = [[Filter alloc] init];
    [filter applyFilter:image filter:self.videoFilter];
}
#endif

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Actions

- (void)filtersClicked
{
    [self performSegueWithIdentifier:@"GoToFiltersSegue" sender:self];
}

- (IBAction)toggleVideoAction:(id)sender;
{
    if (isStarted == NO) {
        [videoCamera start];
        isStarted = YES;
        self.startButton.title = @"Stop";
    } else {
        [videoCamera stop];
        isStarted = NO;
        self.startButton.title = @"Start";
    }
    
}

- (IBAction)switchCameraAction:(id)sender {
    if ([self.switchCameraButton.title isEqualToString:@"Front Camera"]) {
        self.switchCameraButton.title = @"Back Camera";
    } else if ([self.switchCameraButton.title isEqualToString:@"Back Camera"]) {
        self.switchCameraButton.title = @"Front Camera";
    }
    [videoCamera switchCameras];
}

@end
