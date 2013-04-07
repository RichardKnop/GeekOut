//
//  ViewController.h
//  GeekOut
//
//  Created by Richard Knop on 06/04/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <opencv2/highgui/cap_ios.h>
#include "opencv2/imgproc/imgproc.hpp"
using namespace cv;
#import "FilterCollectionController.h"

@interface ViewController : UIViewController <CvVideoCameraDelegate, ChangeVideoFilterDelegate>
{
    CvVideoCamera *videoCamera;
    BOOL isStarted;
    NSInteger videoFilter;
}

- (void)filtersClicked;

@property (nonatomic, retain) CvVideoCamera *videoCamera;
@property (nonatomic, assign) BOOL isStarted;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *startButton;
- (IBAction)toggleVideoAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *switchCameraButton;
- (IBAction)switchCameraAction:(id)sender;

@property (nonatomic, assign) NSInteger videoFilter;
- (void)changeVideoFilter:(NSInteger)filter;

@end
