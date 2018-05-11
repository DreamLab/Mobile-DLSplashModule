//
//  DLSplashScreenWebServiceTests.m
//  DLSplashModule
//
//  Created by Konrad Kierys on 25.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

@import UIKit;
@import Foundation;

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "DLSplashScreenWebService.h"
#import "DLSplashAd.h"
#import "DLTestingHelper.h"
#import "DLSplashConsentParams.h"

#pragma mark - DLSplashScreenWebService category

@interface DLSplashScreenWebService ()
@property (nonatomic, strong) NSURL *url;
- (void)performSessionDownloadTaskForURL:(NSURL *)url;
@end

#pragma mark - Unit Tests

@interface DLSplashScreenWebServiceTests : XCTestCase
@property (nonatomic, strong) id session;
@property (nonatomic, strong) DLSplashScreenWebService *webService;
@end

@implementation DLSplashScreenWebServiceTests

- (void)setUp {
    [super setUp];

    DLSplashConsentParams *consentParams = [[DLSplashConsentParams alloc] initWithPubConsent:@"1" adpConsent:@"2" euConsent:@"3"];

    self.webService = [[DLSplashScreenWebService alloc] initWithSite:@"appsite_example" area:@"area_example" appVersion:@"ver=1.0" slot:@"slot0" consentParams:consentParams];

    self.session = OCMClassMock([NSURLSession class]);
    OCMStub([self.session sharedSession]).andReturn(self.session);
}

- (void)tearDown {
    self.session = nil;
    self.webService = nil;
    [super tearDown];
}

- (void)testInitWithSiteArea_givenProperParameters_instanceShouldNotBeNilAndURLisGeneratedProperly
{
    DLSplashConsentParams *consentParams = [[DLSplashConsentParams alloc] initWithPubConsent:@"1" adpConsent:@"2" euConsent:@"3"];

    DLSplashScreenWebService *webService = [[DLSplashScreenWebService alloc] initWithSite:@"appsite_example" area:@"area_example" appVersion:@"1.0" slot:@"slot_example" consentParams:consentParams];

    XCTAssertNotNil(webService, @"webservice instance should not be nil");

    NSRange range = [webService.url.absoluteString rangeOfString:@"https://csr.onet.pl/_s/csr-006/csr.json?site=appsite_example&area=area_example&slot0=slot_example&ver=1.0&pubconsent=1&adpconsent=2&euconsent=3&kvkwrd=cs006r&DI="];
    XCTAssertTrue(range.length > 0, @"URL should be generated properly");
}

- (void)testInitWithSiteArea_givenNilAsParameters_instanceShouldBeNil
{
    DLSplashConsentParams *consentParams = [[DLSplashConsentParams alloc] initWithPubConsent:@"1" adpConsent:@"2" euConsent:@"3"];

    DLSplashScreenWebService *webService = [[DLSplashScreenWebService alloc] initWithSite:nil area:nil appVersion:nil slot:nil consentParams:consentParams];

    XCTAssertNil(webService, @"webservice instance should be nil");
}

- (void)testInitWithSiteArea_givenEmptyStringAsParameters_instanceShouldBeNil
{
    DLSplashConsentParams *consentParams = [[DLSplashConsentParams alloc] initWithPubConsent:@"1" adpConsent:@"2" euConsent:@"3"];

    DLSplashScreenWebService *webService = [[DLSplashScreenWebService alloc] initWithSite:@"" area:@"" appVersion:@"" slot:@"" consentParams:consentParams];

    XCTAssertNil(webService, @"webservice instance should be nil");
}

- (void)testFetchDataWithCompletion_methodInvocation_nsURLSessionDataTaskWithRequestShouldBeCalled
{
    [self.webService fetchDataWithCompletion:nil];

    OCMVerify([self.session dataTaskWithRequest:[OCMArg any] completionHandler:[OCMArg any]]);
}

- (void)testFetchImageAtURLCompletion_methodInvocation_nsURLSessionDownloadTaskWithRequestShouldBeCalled
{
    [self.webService fetchImageAtURL:nil numberOfRetries:0 completion:nil];

    OCMVerify([self.session downloadTaskWithRequest:[OCMArg any] completionHandler:[OCMArg any]]);
}

- (void)testTrackForSplashAd_givenProperSplashAd_performSessionDataTaskForURLShouldBeCalled
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:[DLTestingHelper dataFromJSONFileNamed:@"std"]];

    id partialMockedWebService = OCMPartialMock(self.webService);
    OCMExpect([partialMockedWebService performSessionDownloadTaskForURL:splashAd.auditURL]);
    OCMExpect([partialMockedWebService performSessionDownloadTaskForURL:splashAd.audit2URL]);

    [partialMockedWebService trackForSplashAd:splashAd];

    OCMVerifyAll(partialMockedWebService);
}

- (void)testTrackForSplashAd_givenNilSplashAd_performSessionDataTaskForURLShouldNotBeCalled
{
    DLSplashAd *splashAd = nil;

    id partialMockedWebService = OCMPartialMock(self.webService);

    [[partialMockedWebService reject] performSessionDownloadTaskForURL:[OCMArg any]];

    [partialMockedWebService trackForSplashAd:splashAd];
}

@end
