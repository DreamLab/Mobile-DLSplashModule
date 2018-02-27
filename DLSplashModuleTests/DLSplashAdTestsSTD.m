//
//  DLSplashAdTestsSTD.m
//  DLSplashModule
//
//  Created by Konrad Kierys on 15.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DLTestingHelper.h"
#import "DLSplashAd.h"

@interface DLSplashAdTestsSTD : XCTestCase

@property (nonatomic, strong) NSData *correctJSONData;
@property (nonatomic, strong) NSData *wrongJSONData;
@property (nonatomic, strong) NSData *emptyJSONData;

@end

@implementation DLSplashAdTestsSTD

- (void)setUp
{
    [super setUp];

    self.correctJSONData = [DLTestingHelper dataFromJSONFileNamed:@"std"];
    self.wrongJSONData = [DLTestingHelper dataFromJSONFileNamed:@"std_wrong"];
    self.emptyJSONData = [DLTestingHelper dataFromJSONFileNamed:@"empty"];
}

- (void)tearDown
{
    self.correctJSONData = nil;
    self.wrongJSONData = nil;
    self.emptyJSONData = nil;

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
    NSURL *testURL = [NSURL URLWithString:@"https://ocdn.eu/lps/tmp/20180125_153733_jmanijak_6/300x150_splash_aplikacji.jpg"];
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

    XCTAssertEqual(splashAd.time, 3, @"SplashAd time should be correct");
}

- (void)testInitWithJSONData_givenCorrectJSONData_auditUrlIsNotNilAndCorrect
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.correctJSONData];

    XCTAssertNotNil(splashAd.auditURL, @"SplashAd auditURL should not be nil");
    NSURL *testURL = [NSURL URLWithString:@"https://csr.onet.pl/eclk/fa4,146337,448633/IP=2018022711490731808379381/IV=2018022711490731808379381/view?1519728547"];
    XCTAssertEqualObjects(splashAd.auditURL, testURL, @"SplashAd auditURL should be correct");
}

- (void)testInitWithJSONData_givenCorrectJSONData_audit2UrlIsNotNilAndCorrect
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.correctJSONData];

    XCTAssertNotNil(splashAd.audit2URL, @"SplashAd audit2URL should not be nil");
    NSURL *testURL = [NSURL URLWithString:@"https://csr.onet.pl/eclk/clk,5450,16749/screeny/?1519728547"];
    XCTAssertEqualObjects(splashAd.audit2URL, testURL, @"SplashAd audit2URL should be correct");
}

- (void)testInitWithJSONData_givenCorrectJSONData_clickUrlIsNotNilAndCorrect
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.correctJSONData];

    XCTAssertNotNil(splashAd.clickURL, @"SplashAd clickURL should not be nil");
    NSURL *testURL = [NSURL URLWithString:@"http://csr.onet.pl/adclick/CID=146337/CCID=448633/IP=2018022711490731808379381/IV=2018022711490731808379381/CS=fa4/NID=1746213/S=APP_TV_IOS_TEST/A=SPLASH/SID=splash/AT=1519728547/UUID=7f4a32d053913b2fa60da6dca6136515/URL=http://www.piwniczanka.pl"];
    XCTAssertEqualObjects(splashAd.clickURL, testURL, @"SplashAd clickURL should be correct");
}

- (void)testInitWithJSONData_givenCorrectJSONData_versionIsCorrect
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.correctJSONData];
    BOOL isVersionCorrect = [splashAd.version isEqualToString:@"20180222131120"];

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

@end
