//
//  ViewController.m
//  GeekOut
//
//  Created by Richard Knop on 06/04/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import "ViewController.h"
#import "FilterCollectionController.h"

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
    
    videoCamera = [[CvVideoCamera alloc] initWithParentView:self.imageView];
    videoCamera.delegate = self;
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
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
    // Do some OpenCV stuff with the image
    Mat image_copy;
    cvtColor(image, image_copy, CV_BGRA2BGR);
    
    if (0 == videoFilter) {
        int erosion_size = 2;
        cv::Mat element = cv::getStructuringElement(cv::MORPH_ELLIPSE,
                                                    cv::Size(2 * erosion_size + 1, 2 * erosion_size + 1),
                                                    cv::Point(erosion_size, erosion_size) );
        cv::erode(image_copy, image, element);
    } else if (1 == videoFilter) {
        int erosion_size = 2;
        cv::Mat element = cv::getStructuringElement(cv::MORPH_ELLIPSE,
                                                    cv::Size(2 * erosion_size + 1, 2 * erosion_size + 1),
                                                    cv::Point(erosion_size, erosion_size) );
        cv::dilate(image_copy, image, element);
    } else if (2 == videoFilter) {
        Mat kern = (Mat_<float>(3,3) <<  0, -1,  0,
                    -1,  5, -1,
                    0, -1,  0);
        filter2D(image_copy, image, image_copy.depth(), kern );
    } else if (3 == videoFilter) {
        Mat kern = (Mat_<float>(3,3) <<  0, -1,  0,
                    -1,  5, -1,
                    0, -1,  0);
        filter2D(image_copy, image, image_copy.depth(), kern );
    } else if (4 == videoFilter) {
        Mat kern = (Mat_<float>(4,4) <<  2, 0, 0, 0,
                    0, 2, 0, 0,
                    0, 0, 2, 0,
                    0, 0, 0, 2);
        cv::transform(image_copy, image, kern);
        image += cv::Scalar(2, 2, 2, 0);
    } else if (5 == videoFilter) {
        Mat kern = (Mat_<float>(4,4) <<  0.272, 0.534, 0.131, 0,
                    0.349, 0.686, 0.168, 0,
                    0.393, 0.769, 0.189, 0,
                    0, 0, 0, 1);
        cv::transform(image_copy, image, kern);
    } else if (6 == videoFilter) {
        bitwise_not(image_copy, image_copy);
        cvtColor(image_copy, image, CV_BGR2BGRA);
    } else if (7 == videoFilter) {
        cvtColor(image_copy, image, CV_BGR2GRAY);
    } else if (8 == videoFilter) {
        cvtColor(image_copy, image, CV_BGR2Luv);
    }
    
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
    [videoCamera switchCameras];
}

@end
