//
//  ViewController.h
//  GeekOut
//
//  Created by Richard Knop on 06/04/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GPUImage.h"
#import "FilterCollectionController.h"

@interface ViewController : UIViewController <ChangeVideoFilterDelegate>
{
    GPUImageVideoCamera *videoCamera;
    GPUImageOutput<GPUImageInput> *videoCameraFilter;
    GPUImageView *filteredVideoView;
    GPUImageMovieWriter *movieWriter;
    GPUImageMovie *movieFile;
    BOOL isStarted;
    BOOL isRecording;
    NSString *selectedFilter;
    NSString *recordingDestination;
}

- (void)filtersClicked;

@property (nonatomic, retain) GPUImageVideoCamera *videoCamera;
@property (nonatomic, retain) GPUImageView *filteredVideoView;
@property (nonatomic, retain) GPUImageOutput<GPUImageInput> *videoCameraFilter;
@property (nonatomic, retain) GPUImageMovieWriter *movieWriter;
@property (nonatomic, retain) GPUImageMovie *movieFile;

@property (nonatomic, assign) BOOL isStarted;
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, retain) NSString *selectedFilter;
@property (nonatomic, retain) NSString *recordingDestination;

- (void)changeVideoFilter:(NSString *)filter;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *startButton;
- (IBAction)toggleVideoAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *recordButton;
- (IBAction)toggleRecordAction:(id)sender;

- (NSArray *)listFileAtPath:(NSString *)path;

@end
