//
//  DLSplashModule.m
//  DLSplashModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLSplashModule.h"
#import "DLSplashModuleConfiguration.h"
#import "DLSplashModule+Internal.h"
#import "DLSplashModuleDelegate.h"
#import "DLSplashScreenWebService.h"
#import "DLStore.h"
#import "DLSplashConsentParams.h"

static const NSTimeInterval kMaxNumberOfFetchingImageRetries = 3;

@interface DLSplashModule ()
@property (nonatomic, strong) DLSplashModuleConfiguration *configuration;
@property (nonatomic, strong) NSMutableSet *delegates;
@property (nonatomic, strong) NSTimer *displayTimer;
@property (nonatomic, strong) NSTimer *waitingTimer;
@property (nonatomic, weak) DLAdView *displayedAdView;
@property (nonatomic, strong) DLSplashAd *splashAd;
@property (nonatomic, strong) DLAdView *generatedAdView;
@property (nonatomic, strong) DLSplashScreenWebService *webService;
@property (nonatomic, strong) DLSplashConsentParams *consentParams;

@end

@implementation DLSplashModule

static dispatch_once_t once;
static DLSplashModule* sharedInstance;

+ (instancetype)initializeWithConfiguration:(DLSplashModuleConfiguration *)configuration
                              consentParams:(DLSplashConsentParams * _Nonnull)consentParams
{
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });

    sharedInstance.configuration = configuration;
    sharedInstance.consentParams = consentParams;
    [sharedInstance initializeSplashAd];

    return sharedInstance;
}

+ (instancetype)initializeWithSite:(NSString *)site
                        appVersion:(NSString *)appVersion
                     consentParams:(DLSplashConsentParams * _Nonnull)consentParams
{
    return [DLSplashModule initializeWithSite:site
                                         area:kSplashScreenDefaultArea
                                   appVersion:appVersion
                                         slot:kSplashScreenDefaultSlot
                                consentParams:consentParams];
}

+ (instancetype)initializeWithSite:(NSString *)site
                              area:(NSString *)area
                        appVersion:(NSString *)appVersion
                     consentParams:(DLSplashConsentParams * _Nonnull)consentParams
{
    return [DLSplashModule initializeWithSite:site
                                         area:area
                                   appVersion:appVersion
                                         slot:kSplashScreenDefaultSlot
                                consentParams:consentParams];
}

+ (instancetype)initializeWithSite:(NSString *)site
                              area:(NSString *)area
                              appVersion:(NSString *)appVersion
                              slot:(NSString *)slot
                     consentParams:(DLSplashConsentParams * _Nonnull)consentParams
{
    DLSplashModuleConfiguration *configuration = [[DLSplashModuleConfiguration alloc] init];
    configuration.site = site;
    configuration.area = area;
    configuration.appVersion = appVersion;
    configuration.slot = slot;

    return [DLSplashModule initializeWithConfiguration:configuration consentParams:consentParams];
}

+ (instancetype)sharedInstance
{
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _delegates = [[NSMutableSet alloc] init];
    return self;
}

- (void)initializeSplashAd
{
    DLStore *store = [[DLStore alloc] init];

    self.webService = [[DLSplashScreenWebService alloc] initWithSite:self.configuration.site
                                                                area:self.configuration.area
                                                          appVersion:self.configuration.appVersion
                                                                slot:self.configuration.slot
                                                       consentParams:self.consentParams];

    [self fetchSplashAdWithWebService:self.webService store:store];
}

-(void)fetchSplashAdWithWebService:(DLSplashScreenWebService *)webService store:(DLStore *)store
{
    DLSplashAd *cachedSplashAd = [store cachedSplashAd];
    self.splashAd = cachedSplashAd.image ? cachedSplashAd : nil;

    [webService fetchDataWithCompletion:^(DLSplashAd *splashAd, NSError *error) {
        if (error) {
            NSLog(@"Error occured: %@", error);
            return;
        }

        // if we get empty json
        if (splashAd.empty) {
            self.splashAd = nil;
            [store clearCache];
            [self waitingForDataFinished];
            return;
        }

        if (splashAd.version != self.splashAd.version || !self.splashAd.image) {
            [webService fetchImageAtURL:splashAd.imageURL numberOfRetries:kMaxNumberOfFetchingImageRetries completion:^(UIImage *image, NSURL *imageLocation, NSError *error) {
                if (error) {
                    NSLog(@"Error occured: %@", error);
                    [self waitingForDataFinished];
                    return;
                }
                if (!image) {
                    NSLog(@"Downloaded image is corrupted.");
                    [self waitingForDataFinished];
                    return;
                }
                splashAd.image = image;
                self.splashAd = splashAd;
                [store clearCache];
                [store saveAdImageFromTemporaryLocation:imageLocation ofSplashAd:splashAd];
                [store cacheSplashAd:splashAd];
                [self waitingForDataFinished];
            }];
        } else {
            splashAd.image = self.splashAd.image;
            splashAd.imageFileName = self.splashAd.imageFileName;
            self.splashAd = splashAd;
            [self waitingForDataFinished];
        }

        NSLog(@"Fetched splash ad: %@", splashAd);
    }];
}

- (DLAdView *)adView
{
    if (!_generatedAdView) {
        _generatedAdView = [[DLAdView alloc] init];
    }
    return _generatedAdView;
}

#pragma mark - Delegate
- (void)addDelegate:(id<DLSplashModuleDelegate>)delegate
{
    [self.delegates addObject:delegate];
}

- (void)removeDelegate:(id<DLSplashModuleDelegate>)delegate
{
    [self.delegates removeObject:delegate];
}

- (void)removeAllDelegates
{
    [self.delegates removeAllObjects];
}

- (void)notifyDelegatesSplashScreenShouldDisplayAd
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *delegates = self.delegates.allObjects;
        for (id<DLSplashModuleDelegate> delegate in delegates) {
            [delegate splashScreenShouldDisplayAd];
        }
    });
}

- (void)notifyDelegatesSplashScreenShouldBeClosed
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *delegates = self.delegates.allObjects;
        for (id<DLSplashModuleDelegate> delegate in delegates) {
            [delegate splashScreenShouldBeClosed];
        }
    });
}

#pragma mark - Timers
- (void)waitingForDataStarted
{
    self.waitingTimer = [NSTimer scheduledTimerWithTimeInterval:self.configuration.maximumWaitingTimeForContent
                                                         target:self
                                                       selector:@selector(waitingForDataFinished)
                                                       userInfo:nil
                                                        repeats:NO];
}

- (void)waitingForDataFinished
{
    if (self.waitingTimer) {
        [self.waitingTimer invalidate];
        self.waitingTimer = nil;
        if (self.splashAd) {
            [self notifyDelegatesSplashScreenShouldDisplayAd];
        } else {
            [self notifyDelegatesSplashScreenShouldBeClosed];
        }
    }
}

- (void)displayingTimeStarted
{
    NSInteger waitingTime = self.splashAd.time;
    self.displayTimer = [NSTimer scheduledTimerWithTimeInterval:waitingTime
                                                         target:self
                                                       selector:@selector(displayingTimePassed)
                                                       userInfo:nil
                                                        repeats:NO];
}

- (void)displayingTimePassed
{
    self.displayTimer = nil;
    [self notifyDelegatesSplashScreenShouldBeClosed];
}

#pragma mark - Communication with ad view

- (void)adViewDidShow:(DLAdView *)adView
{
    [self waitingForDataStarted];
}

- (void)adViewDidDisplayImage:(DLAdView *)adView
{
    [self displayingTimeStarted];
    [self.webService trackForSplashAd:self.splashAd];
}

@end
