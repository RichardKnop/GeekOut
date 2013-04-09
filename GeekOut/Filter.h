//
//  Filter.h
//  GeekOut
//
//  Created by Richard Knop on 09/04/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#endif

#import <Foundation/Foundation.h>
#import <opencv2/highgui/highgui.hpp>
#include "opencv2/imgproc/imgproc.hpp"
using namespace cv;

@interface Filter : NSObject

- (Mat)cvMatFromUIImage:(UIImage *)image;

- (UIImage *)UIImageFromCVMat:(Mat)cvMat;

- (void)applyFilter:(Mat&)image filter:(int)filter;

@end
