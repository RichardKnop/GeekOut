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
@synthesize isCaptureStarted;
@synthesize isRecording;
@synthesize selectedFilter;
@synthesize recordingDestination;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    isCaptureStarted = NO;
    isRecording = NO;
    selectedFilter = @"None";
    
    UIBarButtonItem *filtersButton = [[UIBarButtonItem alloc] initWithTitle:@"Filters" style:UIBarButtonItemStyleBordered target:self action:@selector(filtersClicked)];
    self.navigationItem.rightBarButtonItem = filtersButton;
    
    UIBarButtonItem *libraryButton = [[UIBarButtonItem alloc] initWithTitle:@"Library" style:UIBarButtonItemStyleBordered target:self action:@selector(libraryClicked)];
    self.navigationItem.leftBarButtonItem = libraryButton;
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];

    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *playButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(startCapture)];
    UIBarButtonItem *pauseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pauseCapture)];
    UIBarButtonItem *startRecordingButton = [[UIBarButtonItem alloc] initWithTitle:@"Record" style:UIBarButtonItemStyleBordered target:self action:@selector(startRecording)];
    [startRecordingButton setTag:99];
    UIBarButtonItem *stopRecordingButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveRecorded)];
    NSArray* toolbarItems = [NSArray arrayWithObjects:playButton, pauseButton, startRecordingButton, stopRecordingButton, nil];
    self.toolbarItems = [NSArray arrayWithObjects:flexibleSpace, playButton, flexibleSpace, pauseButton, flexibleSpace, startRecordingButton, flexibleSpace, stopRecordingButton, flexibleSpace, nil];
    self.navigationController.toolbarHidden = NO;
    [self.navigationController.toolbar setBarStyle:UIBarStyleBlackOpaque];
    
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    videoCamera.horizontallyMirrorFrontFacingCamera = NO;
    videoCamera.horizontallyMirrorRearFacingCamera = NO;
    
    [self changeVideoFilter:selectedFilter];
    
    recordingDestination = [self generateRecordingDestination];
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

- (void)libraryClicked
{
    [self performSegueWithIdentifier:@"GoToLibrarySegue" sender:self];
}

- (void)startCapture
{
    if (isCaptureStarted == NO) {
        isCaptureStarted = YES;
        [videoCamera startCameraCapture];
    }
}

- (void)pauseCapture
{
    if (isCaptureStarted == YES) {
        isCaptureStarted = NO;
        [videoCamera stopCameraCapture];
        if (isRecording == YES) {
            [self saveRecorded];
        }
    }
}

- (void)startRecording
{
    if (isRecording == NO && isCaptureStarted == YES) {
        NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:recordingDestination];
        unlink([pathToMovie UTF8String]);
        NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    
        movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(1280.0, 720.0)];
        [videoCameraFilter addTarget:movieWriter];
    
        movieWriter.shouldPassthroughAudio = YES;
        movieFile.audioEncodingTarget = movieWriter;
        [movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];
    
        [movieWriter startRecording];
        [movieFile startProcessing];
    
        [movieWriter setCompletionBlock:^{
            [videoCameraFilter removeTarget:movieWriter];
            [movieWriter finishRecording];
        }];
        
        for (UIBarButtonItem *toolbarItem in self.toolbarItems) {
            if (99 == toolbarItem.tag) {
                toolbarItem.title = @"Recording";
            }
        }
        
        isRecording = YES;
    }
}

- (void)saveRecorded
{
    if (isRecording == YES) {
        [movieWriter completionBlock];
        for (UIBarButtonItem *toolbarItem in self.toolbarItems) {
            if (99 == toolbarItem.tag) {
                toolbarItem.title = @"Record";
            }
        }
        recordingDestination = [self generateRecordingDestination];
        isRecording = NO;
    }
}

- (NSString *)generateRecordingDestination
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd-HH-mm-SS"];
    NSString *destinationFolder = @"Documents";
    NSString *extension = @"m4v";
    return [NSString stringWithFormat: @"%@/%@.%@", destinationFolder, [dateFormat stringFromDate:date], extension];
}

- (NSArray *)listFileAtPath:(NSString *)path
{
    //-----> LIST ALL FILES <-----//
    NSLog(@"LISTING ALL FILES FOUND");
    
    int count;
    
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    for (count = 0; count < (int)[directoryContent count]; count++)
    {
        NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
    }
    return directoryContent;
}

@end
