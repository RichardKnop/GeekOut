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
@synthesize filteredVideoView;
@synthesize movieWriter;
@synthesize movieFile;
@synthesize isStarted;
@synthesize isRecording;
@synthesize selectedFilter;
@synthesize recordingDestination;
@synthesize toolbar;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    isStarted = NO;
    selectedFilter = @"None";
    
    UIBarButtonItem *filtersButton = [[UIBarButtonItem alloc] initWithTitle:@"Filters" style:UIBarButtonItemStyleBordered target:self action:@selector(filtersClicked)];
    self.navigationItem.rightBarButtonItem = filtersButton;
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    [toolbar setBarStyle:UIBarStyleBlackOpaque];
    
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    videoCamera.horizontallyMirrorFrontFacingCamera = NO;
    videoCamera.horizontallyMirrorRearFacingCamera = NO;
    
    [self changeVideoFilter:selectedFilter];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"Documents/yyyy_MM_dd_HH_mm_ss.m4v"];
    recordingDestination = [dateFormat stringFromDate:date];
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

- (void)changeVideoFilter:(NSString *)filter
{
    selectedFilter = filter;
    [videoCamera removeAllTargets];
    [videoCameraFilter removeAllTargets];
    videoCameraFilter = [[[Filter alloc] init] getFilter:selectedFilter];
    [videoCamera addTarget:videoCameraFilter];
    
    filteredVideoView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 372)];
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
        self.startButton.image = [UIImage imageNamed:@"button-pause.png"];
        [videoCamera startCameraCapture];
    } else {
        isStarted = NO;
        self.startButton.image = [UIImage imageNamed:@"button-play.png"];
        [videoCamera stopCameraCapture];
    }
}

- (IBAction)toggleRecordAction:(id)sender {
    if (isRecording == NO) {
        isRecording = YES;
        self.recordButton.image = [UIImage imageNamed:@"button-stop.png"];
        
        NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:recordingDestination];
        unlink([pathToMovie UTF8String]);
        NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
        
        movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(1280.0, 720.0)];
        [videoCameraFilter addTarget:movieWriter];
        
        movieWriter.shouldPassthroughAudio = YES;
        movieFile.audioEncodingTarget = movieWriter;
        [movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];
        
//        [movieWriter startRecording];
//        [movieFile startProcessing];
//        
//        [movieWriter setCompletionBlock:^{
//            [videoCameraFilter removeTarget:movieWriter];
//            [movieWriter finishRecording];
//        }];
    } else {
        isRecording = NO;
        self.recordButton.image = [UIImage imageNamed:@"button-record.png"];
        [videoCameraFilter removeTarget:movieWriter];
        [movieWriter finishRecording];
    }
}

@end
