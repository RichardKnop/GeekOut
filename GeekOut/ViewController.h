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
    BOOL isCaptureStarted;
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

@property (nonatomic, assign) BOOL isCaptureStarted;
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, retain) NSString *selectedFilter;
@property (nonatomic, retain) NSString *recordingDestination;

- (void)changeVideoFilter:(NSString *)filter;
- (NSString *)generateRecordingDestination;
- (NSArray *)listFileAtPath:(NSString *)path;

@end
