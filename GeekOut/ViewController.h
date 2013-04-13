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
    BOOL isStarted;
    NSString *selectedFilter;
}

- (void)filtersClicked;

@property (nonatomic, retain) GPUImageVideoCamera *videoCamera;
@property (nonatomic, retain) GPUImageOutput<GPUImageInput> *videoCameraFilter;

@property (nonatomic, assign) BOOL isStarted;
@property (nonatomic, retain) NSString *selectedFilter;
- (void)changeVideoFilter:(NSString *)filter;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *startButton;
- (IBAction)toggleVideoAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *switchCameraButton;
- (IBAction)switchCameraAction:(id)sender;

@end
