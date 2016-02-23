//
//  DLSplashScreenWebService.m
//  DLSplashModule
//
//  Created by Konrad Kierys on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

@import UIKit;
@import Foundation;

#import "DLSplashScreenWebService.h"
#import "DLSplashAd.h"
#import "DLStore.h"

NSString * const kSplashScreenBaseURL = @"https://csr.onet.pl/_s/csr-005/%@/exclusive:app_area/slots=splash/csr.json";

@interface DLSplashScreenWebService ()

@property (nonatomic, strong) NSURL *url;

@end

@implementation DLSplashScreenWebService

- (instancetype)initWithAppSite:(NSString *)appSite {
    self = [super init];
    if (!self) {
        return nil;
    }

    if (appSite == nil) {
        return nil;
    }
    
    _url = [NSURL URLWithString:[NSString stringWithFormat:kSplashScreenBaseURL, appSite]];

    return self;
}

- (void)fetchDataWithCompletion:(void (^)(DLSplashAd *, NSError *))completion
{
    NSURLSession *session = [NSURLSession sharedSession];

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.url];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                    if (error) {
                                                        if (completion) {
                                                            completion(nil, error);
                                                        }
                                                        return;
                                                    }

                                                    if (completion) {
                                                        DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:data];
                                                        completion(splashAd, error);
                                                    }
    }];

    [dataTask resume];
}

- (void)fetchImageAtURL:(NSURL *)url completion:(void (^)(UIImage *image, NSURL *imageLocation, NSError *error))completion
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:urlRequest
                                                            completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                if (error) {
                                                                    if (completion) {
                                                                        completion(nil, nil, error);
                                                                    }
                                                                    return;
                                                                }

                                                                if (completion) {
                                                                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                                                                    completion(image, location, error);
                                                                }
    }];

    [downloadTask resume];
}

- (void)trackForSplashAd:(DLSplashAd *)splashAd
{
    [self performSessionDataTaskForURL:splashAd.auditURL];
    [self performSessionDataTaskForURL:splashAd.audit2URL];

    DLStore *store = [[DLStore alloc] init];

    if ([store areAnyTrackingLinksQueued]) {
        [[store queuedTrackingLinks] enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self performSessionDataTaskForURL:obj];
        }];
    }
}

#pragma mark - Private methods

- (void)performSessionDataTaskForURL:(NSURL *)url
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

    DLStore *store = [[DLStore alloc] init];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [store queueTrackingLink:url];
            NSLog(@"Error occurred: %@ while sending request to url: %@", error.description, url);
        } else {
            [store removeTrackingLink:url];
        }
    }];

    [dataTask resume];

}

@end
