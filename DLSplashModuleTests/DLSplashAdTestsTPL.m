//
//  DLSplashAdTestsTPL.m
//  DLSplashModuleTests
//
//  Created by Szeremeta Adam on 27.02.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DLTestingHelper.h"
#import "DLSplashAd.h"

@interface DLSplashAdTestsTPL : XCTestCase

@property (nonatomic, strong) NSData *correctJSONData;
@property (nonatomic, strong) NSData *wrongJSONData;
@property (nonatomic, strong) NSData *emptyJSONData;
@property (nonatomic, strong) NSData *nullLinksJSONData;

@end

@implementation DLSplashAdTestsTPL

- (void)setUp
{
    [super setUp];

    self.correctJSONData = [DLTestingHelper dataFromJSONFileNamed:@"tpl"];
    self.wrongJSONData = [DLTestingHelper dataFromJSONFileNamed:@"tpl_wrong"];
    self.emptyJSONData = [DLTestingHelper dataFromJSONFileNamed:@"empty"];
    self.nullLinksJSONData = [DLTestingHelper dataFromJSONFileNamed:@"tpl_null_links"];
}

- (void)tearDown
{
    self.correctJSONData = nil;
    self.wrongJSONData = nil;
    self.emptyJSONData = nil;
    self.nullLinksJSONData = nil;

    [super tearDown];
}

- (void)testInitWithJSONData_givenCorrectJSONData_splashAdShouldNotBeNil
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.correctJSONData];

    XCTAssertNotNil(splashAd, @"Splash Ad should not be nil");
}

- (void)testInitWithJSONData_givenCorrectJSONData_imageUrlIsNotNilAndCorrect
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.correctJSONData];

    XCTAssertNotNil(splashAd.imageURL, @"SplashAd ImageURL should not be nil");
    NSURL *testURL = [NSURL URLWithString:@"https://ocdn.eu/lps/1746213/creative/000/000043/000043181/300x150_splash_aplikacji.jpg"];
    XCTAssertEqualObjects(splashAd.imageURL, testURL, @"SplashAd ImageURL should be correct");
}

- (void)testInitWithJSONData_givenCorrectJSONData_imageWidthIsCorrect
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.correctJSONData];

    XCTAssertEqual(splashAd.imageWidth, 150, @"SplashAd imageWidth should be correct");
}

- (void)testInitWithJSONData_givenCorrectJSONData_imageHeightIsCorrect
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.correctJSONData];

    XCTAssertEqual(splashAd.imageHeight, 95, @"SplashAd imageHeight should be correct");
}

- (void)testInitWithJSONData_givenCorrectJSONData_adTextIsNotNilAndCorrect
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.correctJSONData];

    XCTAssertNotNil(splashAd.text, @"SplashAd text should not be nil");
    XCTAssertEqualObjects(splashAd.text, @"Partner aplikacji", @"SplashAd text should be correct");
}

- (void)testInitWithJSONData_givenCorrectJSONData_timeIsCorrect
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.correctJSONData];

    XCTAssertEqual(splashAd.time, 4, @"SplashAd time should be correct");
}

- (void)testInitWithJSONData_givenCorrectJSONData_auditUrlIsNotNilAndCorrect
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.correctJSONData];

    XCTAssertNotNil(splashAd.auditURL, @"SplashAd auditURL should not be nil");
    NSURL *testURL = [NSURL URLWithString:@"https://csr.onet.pl/eclk/clk,5450,16749/iOS_PTV_splash_1/?1519732062"];
    XCTAssertEqualObjects(splashAd.auditURL, testURL, @"SplashAd auditURL should be correct");
}

- (void)testInitWithJSONData_givenCorrectJSONData_audit2UrlIsNotNilAndCorrect
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.correctJSONData];

    XCTAssertNotNil(splashAd.audit2URL, @"SplashAd audit2URL should not be nil");
    NSURL *testURL = [NSURL URLWithString:@"https://csr.onet.pl/eclk/clk,5450,16749/iOS_PTV_splash_2/?1519732062"];
    XCTAssertEqualObjects(splashAd.audit2URL, testURL, @"SplashAd audit2URL should be correct");
}

- (void)testInitWithJSONData_givenCorrectJSONData_clickUrlIsNotNilAndCorrect
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.correctJSONData];

    XCTAssertNotNil(splashAd.clickURL, @"SplashAd clickURL should not be nil");
    NSURL *testURL = [NSURL URLWithString:@"http://csr.onet.pl/adclick/CID=18121/CCID=43181/DID=10261/IP=2018022712474201633392831/IV=2018022712474201633392831/CS=das/NID=1746213/S=APP_TV_IOS_TEST/A=SPLASH/SID=splash/AT=1519732062/UUID=a51b943ea5c73104a9a250617b44c8fd/URL=http://www.piwniczanka.pl"];
    XCTAssertEqualObjects(splashAd.clickURL, testURL, @"SplashAd clickURL should be correct");
}

- (void)testInitWithJSONData_givenCorrectJSONData_versionIsCorrect
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.correctJSONData];
    BOOL isVersionCorrect = [splashAd.version isEqualToString:@"20180227120249"];

    XCTAssertTrue(isVersionCorrect, @"SplashAd version should be correct");
}

- (void)testInitWithJSONData_givenCorruptedJSONData_splashAdShouldBeNil
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.wrongJSONData];

    XCTAssertTrue(splashAd.empty, @"Splash Ad should be empty");
}

- (void)testInitWithJSONData_givenEmptyJSONData_splashAdEmptyPropertyIsTrue
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.emptyJSONData];

    XCTAssertTrue(splashAd.empty, @"Splash Ad should be nil");
}

- (void)testInitWithJSONData_givenNilAsJSONData_splashAdShouldBeNil
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:nil];

    XCTAssertNil(splashAd, @"Splash Ad should be nil");
}

- (void)testInitWithJSONData_givenCorrectJSONDataWithNullLinks_splashAdShouldNotBeNil
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.nullLinksJSONData];

    XCTAssertNotNil(splashAd, @"Splash Ad should not be nil");
}

@end
