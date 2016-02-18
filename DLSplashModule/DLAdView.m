//
//  DLAdView.m
//  DLSplashModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLAdView.h"
#import "DLSplashModule.h"

/// Max size of ImageView
static int kMaxSizeOfImageView = 150;

@interface DLAdView()
@property (nonatomic, weak) DLSplashModule* splashModule;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@end

@implementation DLAdView

#pragma mark Initializers

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark Private Initializers

- (void)initialize
{
    UIImage *image = self.splashModule.image;
    CGSize imageSize = self.splashModule.imageSize;

    self.imageView = [[UIImageView alloc] initWithImage: image];

    // if image is smaller than view, then center it, otherwise aspect fit.
    if (imageSize.width < kMaxSizeOfImageView && imageSize.height < kMaxSizeOfImageView) {
        self.imageView.contentMode = UIViewContentModeCenter;
    } else {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }

    [self addSubview:self.imageView];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;

    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kMaxSizeOfImageView];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kMaxSizeOfImageView];

    [self addConstraints: @[centerX, centerY, width, height]];

    [self initializeGestureRecognizer];
}

- (void)initializeGestureRecognizer
{
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [self.imageView addGestureRecognizer:self.tapGestureRecognizer];
}

#pragma mark Private Methods

- (void)imageTapped:(id)sender
{
        // [JZ] TODO: pass url from the DLSplashAd -- waiting for merge!
//        [self.delegate adViewDidTapImageWithUrl: ];
}

@end