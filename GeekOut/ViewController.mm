//
//  ViewController.m
//  GeekOut
//
//  Created by Richard Knop on 06/04/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import "ViewController.h"
#import "FiltersController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize videoCamera;
@synthesize isStarted;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.imageView.backgroundColor = [UIColor darkGrayColor];
    self.isStarted = NO;
    
    UIBarButtonItem *filtersButton = [[UIBarButtonItem alloc] initWithTitle:@"Filters" style:UIBarButtonItemStyleBordered target:self action:@selector(filtersClicked)];
    self.navigationItem.rightBarButtonItem = filtersButton;
    
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:self.imageView];
    self.videoCamera.delegate = self;
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = 30;
    self.videoCamera.grayscaleMode = NO;
}

- (void)filtersClicked
{
    [self performSegueWithIdentifier:@"GoToFiltersSegue" sender:self];
}

#pragma mark - Protocol CvVideoCameraDelegate

#ifdef __cplusplus
- (void)processImage:(Mat&)image;
{
    // Do some OpenCV stuff with the image
    Mat image_copy;
    cvtColor(image, image_copy, CV_BGRA2BGR);
    
    // invert image
    //bitwise_not(image_copy, image_copy);
    //cvtColor(image_copy, image, CV_BGR2BGRA);
    
    // grey image
    //cvtColor(image_copy, image, CV_BGR2GRAY);
    
    // binary image
    //threshold(image_copy, image_copy, 20, 255, THRESH_BINARY);
    //cvtColor(image_copy, image, CV_BGR2GRAY);
    
    // hsv image
    //cvtColor(image_copy, image, CV_BGR2HSV);
    
    // luv image
    //cvtColor(image_copy, image, CV_BGR2Luv);
    
    // hls image
    //cvtColor(image_copy, image, CV_BGR2HLS);
    
    // lab image
    //cvtColor(image_copy, image, CV_BGR2Lab);
}
#endif

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Actions

- (IBAction)toggleVideoAction:(id)sender;
{
    if (self.isStarted == NO) {
        [self.videoCamera start];
        self.isStarted = YES;
        self.startButton.title = @"Stop";
    } else {
        [self.videoCamera stop];
        self.isStarted = NO;
        self.startButton.title = @"Start";
    }
    
}

- (IBAction)switchCameraAction:(id)sender {
    [self.videoCamera switchCameras];
}

@end
