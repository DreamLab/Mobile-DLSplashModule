//
//  DLSplashScreenWebService.h
//  DLSplashModule
//
//  Created by Konrad Kierys on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DLSplashAd;
@class DLSplashConsentParams;

/**
 *  Class to fetch data from server
 */
@interface DLSplashScreenWebService : NSObject

/**
 *  Designated initializer.
 *
 *  @param site             Site URL parameter.
 *  @param area             Area URL parameter.
 *  @param appVersion       Application version.
 *  @param slot             Slot URL parameter.
 *  @param consentParams    DLSplashConsentParams object.
 *
 *  @return Instance of DLSplashScreenWebService with URL to webservice.
 */
- (instancetype)initWithSite:(NSString *)site
                        area:(NSString *)area
                  appVersion:(NSString *)appVersion
                        slot:(NSString *)slot
               consentParams:(DLSplashConsentParams * _Nonnull)consentParams;

/**
 *  Fetch data from server.
 *
 *  @param completion Block with DLSplashAd and NSError as result of fetching data
 */
- (void)fetchDataWithCompletion:(void(^)(DLSplashAd *splashAd, NSError *error))completion;

/**
 *  Fetch image from server.
 *
 *  @param url             URL to the image.
 *  @param numberOfRetries Number of retries to fetch image.
 *  @param completion      Completion block containing downloaded image and path to its temporary location on disk and error if occurred.
 */
- (void)fetchImageAtURL:(NSURL *)url numberOfRetries:(NSUInteger)numberOfRetries completion:(void (^)(UIImage *image, NSURL *imageLocation, NSError *error))completion;

/**
 *  Send tracking requests.
 *
 *  @param splashAd SplashAd to track.
 */
- (void)trackForSplashAd:(DLSplashAd *)splashAd;

@end
