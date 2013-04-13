//
//  Filter.m
//  GeekOut
//
//  Created by Richard Knop on 09/04/2013.
//  Copyright (c) 2013 Richard Knop. All rights reserved.
//

#import "Filter.h"

@implementation Filter

- (GPUImageOutput<GPUImageInput> *)getFilter:(NSString *)filterName
{
    if ([filterName isEqualToString:@"Sepia"]) {
        return [[GPUImageSepiaFilter alloc] init];
    }
    
    if ([filterName isEqualToString:@"Steel Blue"]) {
        GPUImageMonochromeFilter *f = [[GPUImageMonochromeFilter alloc] init];
        [f setColor:(GPUVector4){0.7f, 1.3f, 1.8f, 1.0f}];
        [f setIntensity:0.4];
        return f;
    }
    
    if ([filterName isEqualToString:@"Terra Cotta"]) {
        GPUImageMonochromeFilter *f = [[GPUImageMonochromeFilter alloc] init];
        [f setColor:(GPUVector4){2.26f, 1.14f, 0.91f, 1.0f}];
        [f setIntensity:0.4];
        return f;
    }
    
    if ([filterName isEqualToString:@"Olive"]) {
        GPUImageMonochromeFilter *f = [[GPUImageMonochromeFilter alloc] init];
        [f setColor:(GPUVector4){1.28f, 1.28f, 0.0f, 1.0f}];
        [f setIntensity:0.4];
        return f;
    }
    
    if ([filterName isEqualToString:@"Byzantium"]) {
        GPUImageMonochromeFilter *f = [[GPUImageMonochromeFilter alloc] init];
        [f setColor:(GPUVector4){1.12f, 0.41f, 0.99f, 1.0f}];
        [f setIntensity:0.4];
        return f;
    }
    
    if ([filterName isEqualToString:@"Amatorka"]) {
        return [[GPUImageAmatorkaFilter alloc] init];
    }
    
    if ([filterName isEqualToString:@"Miss Etikate"]) {
        return [[GPUImageMissEtikateFilter alloc] init];
    }
    
    if ([filterName isEqualToString:@"Soft Elegance"]) {
        return [[GPUImageSoftEleganceFilter alloc] init];
    }
    
    if ([filterName isEqualToString:@"Sketch"]) {
        return [[GPUImageSketchFilter alloc] init];
    }
    
    if ([filterName isEqualToString:@"Sketch 2"]) {
        return [[GPUImageThresholdSketchFilter alloc] init];
    }
    
    if ([filterName isEqualToString:@"Toon"]) {
        return [[GPUImageToonFilter alloc] init];
    }
    
    if ([filterName isEqualToString:@"Smooth Toon"]) {
        return [[GPUImageSmoothToonFilter alloc] init];
    }
    
    if ([filterName isEqualToString:@"Emboss"]) {
        return [[GPUImageEmbossFilter alloc] init];
    }
    
    if ([filterName isEqualToString:@"Posterize"]) {
        return [[GPUImagePosterizeFilter alloc] init];    }
    
    if ([filterName isEqualToString:@"Vignette"]) {
        return [[GPUImageVignetteFilter alloc] init];
    }
    
    if ([filterName isEqualToString:@"Tilt Shift"]) {
        return [[GPUImageTiltShiftFilter alloc] init];
    }
    
    if ([filterName isEqualToString:@"Sobel Edge"]) {
        return [[GPUImageSobelEdgeDetectionFilter alloc] init];
    }
    
    if ([filterName isEqualToString:@"Canny Edge"]) {
        return [[GPUImageCannyEdgeDetectionFilter alloc] init];
    }
    
    return [[GPUImageGammaFilter alloc] init];
}

@end
