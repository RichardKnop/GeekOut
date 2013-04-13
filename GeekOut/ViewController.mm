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
@synthesize videoCameraFilter;
@synthesize isStarted;
@synthesize selectedFilter;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    isStarted = NO;
    selectedFilter = -1;
    
    UIBarButtonItem *filtersButton = [[UIBarButtonItem alloc] initWithTitle:@"Filters" style:UIBarButtonItemStyleBordered target:self action:@selector(filtersClicked)];
    self.navigationItem.rightBarButtonItem = filtersButton;
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationController.toolbar setBarStyle:UIBarStyleDefault];
    
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    videoCamera.horizontallyMirrorFrontFacingCamera = NO;
    videoCamera.horizontallyMirrorRearFacingCamera = NO;
    
    [self changeVideoFilter:selectedFilter];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"GoToFiltersSegue"])
    {
        FilterCollectionController *filterCollectionController = segue.destinationViewController;
        filterCollectionController.changeVideoFilterDelegate = self;
        filterCollectionController.selectedFilter = selectedFilter;
    }
}

- (void)changeVideoFilter:(NSInteger)filter
{
    selectedFilter = filter;
    [videoCamera removeAllTargets];
    [videoCameraFilter removeAllTargets];
    videoCameraFilter = [[[Filter alloc] init] getFilter:selectedFilter];
    [videoCamera addTarget:videoCameraFilter];
    
    GPUImageView *filteredVideoView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 372)];
    [self.view addSubview:filteredVideoView];
    
    [videoCameraFilter addTarget:filteredVideoView];
    filteredVideoView.fillMode = kGPUImageFillModeStretch;
    [videoCameraFilter prepareForImageCapture];
}

- (void)viewWillAppear:(BOOL)animated
{
    // TODO
}

- (void)viewWillDisappear:(BOOL)animated
{
    // TODO
}

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
        isStarted = YES;
        self.startButton.title = @"Stop";
        [videoCamera startCameraCapture];
    } else {
        isStarted = NO;
        self.startButton.title = @"Start";
        [videoCamera stopCameraCapture];
    }
    
}

- (IBAction)switchCameraAction:(id)sender {
    if ([self.switchCameraButton.title isEqualToString:@"Front Camera"]) {
        self.switchCameraButton.title = @"Back Camera";
    } else if ([self.switchCameraButton.title isEqualToString:@"Back Camera"]) {
        self.switchCameraButton.title = @"Front Camera";
    }
    [videoCamera rotateCamera];
}

@end
