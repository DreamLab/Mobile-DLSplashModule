//
//  DLSplashModule.h
//  DLSplashModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

@import Foundation;
@import UIKit;
#import "DLAdView.h"
#import "DLSplashModuleDelegate.h"
#import "DLSplashConsentParams.h"

@class DLSplashModuleConfiguration;
@class DLSplashAd;

/**
Module responsible for providing ads for splash screen.
 */
@interface DLSplashModule : NSObject

/**
 Returns initialized object of class DLAdView. Each time it returns the same object.
 */
@property (nonatomic, readonly) DLAdView *adView;

/**
 *  Initialize module with the configuration
 *
 *  @param configuration    DLSplashModule configuration
 *  @param consentParams    DLSplashConsentParams object.
 *
 *  @return Instance of initialized DLSplashModuleConfiguration
 */
+ (instancetype)initializeWithConfiguration:(DLSplashModuleConfiguration *)configuration
                              consentParams:(DLSplashConsentParams * _Nonnull)consentParams;

/**
 Initializes module with the site parameter. It initialize the shared instance. Should be called before first use.

 @param site            the site URL parameter
 @param appVersion      the version number of the app
 @param consentParams   DLSplashConsentParams object.

 @return Instance of initialized DLSplashModule
 */
+ (instancetype)initializeWithSite:(NSString *)site
                        appVersion:(NSString *)appVersion
                     consentParams:(DLSplashConsentParams * _Nonnull)consentParams;

/**
 Initializes module with the site parameter. It initialize the shared instance. Should be called before first use.

 @param site            the site URL parameter
 @param area            the area URL parameter
 @param appVersion      the version number of the app
 @param consentParams   DLSplashConsentParams object.
 
 @return Instance of initialized DLSplashModule
 */
+ (instancetype)initializeWithSite:(NSString *)site
                              area:(NSString *)area
                        appVersion:(NSString *)appVersion
                     consentParams:(DLSplashConsentParams * _Nonnull)consentParams;

/**
 *   Initializes module with the site, area and slots parameter. It initialize the shared instance. Should be called before first use.
 *
 *  @param site             the site URL parameter
 *  @param area             the area URL parameter
 *  @param appVersion       the version number of the app
 *  @param slot             the slot URL parameter
 *  @param consentParams    DLSplashConsentParams object.
 *
 *  @return Instance of initialized DLSplashModule
 */
+ (instancetype)initializeWithSite:(NSString *)site
                              area:(NSString *)area
                        appVersion:(NSString *)appVersion
                              slot:(NSString *)slot
                     consentParams:(DLSplashConsentParams * _Nonnull)consentParams;

/**
 Returns the singleton instance of the DLSplashModule class. 
 Method initializeWithIdentifier: should be called before first use, otherwise sharedInstance will be nil.

 @return Instance of DLSplashModule or nil if not initialized
 */
+ (instancetype)sharedInstance;

/**
 Add delegate to the DLSplashModule.

 @param delegate DLSplashModuleDelegate implementation
 */
- (void)addDelegate:(id<DLSplashModuleDelegate>)delegate;

@end
