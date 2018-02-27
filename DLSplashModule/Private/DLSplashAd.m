//
//  DLSplashAd.m
//  DLSplashModule
//
//  Created by Konrad Kierys on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLSplashAd.h"
#import "UIColor+Hex.h"

NSString * const kSplashScreenPersisteStoreKey = @"com.dreamlab.splash_screen.persiste_store";

@implementation DLSplashAd

- (instancetype)initWithJSONData:(NSData *)data
{
    NSDictionary *parsedJSON = [DLSplashAd parseJSONData:data];

    return [self initWithJSONDictionary:parsedJSON];
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)json
{
    // Check which response type we have
    NSString *type = [DLSplashAd splashTypeFromJSON:json];
    if (!type) {
        return nil;
    }

    if ([type isEqualToString:@"tpl"]) {
        return [self initWithTPLJSONDictionary:json];
    }

    if ([type isEqualToString:@"std"]) {
        return [self initWithSTDJSONDictionary:json];
    }

    if ([type isEqualToString:@"empty"]) {
        return [self initWithEmptyJSONDictionary:json];
    }

    return nil;
}

- (instancetype)initWithTPLJSONDictionary:(NSDictionary *)json
{
    self = [super init];
    if (!self || json == nil) {
        return nil;
    }

    NSDictionary *firstElement = [((NSArray *)json[@"ads"]) firstObject];
    if (!firstElement) {
        return nil;
    }

    _imageURL = [NSURL URLWithString:firstElement[@"data"][@"fields"][@"image"]];
    _imageWidth = [firstElement[@"data"][@"meta"][@"width"] doubleValue];
    _imageHeight = [firstElement[@"data"][@"meta"][@"height"] doubleValue];
    _auditURL = [NSURL URLWithString:firstElement[@"data"][@"fields"][@"audit"]];
    _audit2URL = [NSURL URLWithString:firstElement[@"data"][@"fields"][@"audit2"]];

    NSString *clickUrlString = [NSString stringWithFormat:@"%@%@",
                                firstElement[@"data"][@"meta"][@"adclick"],
                                firstElement[@"data"][@"fields"][@"click"]];
    _clickURL = [NSURL URLWithString:clickUrlString];
    _actionCountURL = [NSURL URLWithString:firstElement[@"data"][@"meta"][@"actioncount"]];

    _version = firstElement[@"data"][@"meta"][@"ver"];
    _text = firstElement[@"data"][@"fields"][@"txt"];
    _time = [firstElement[@"data"][@"fields"][@"time"] integerValue];

    NSString *textColor = firstElement[@"data"][@"fields"][@"font_color"];
    _textColor = [UIColor colorFromHexString:textColor];

    if (_imageURL && _imageWidth && _imageHeight && _auditURL && _audit2URL && _clickURL && _version && _text && _time) {
        _empty = false;
    } else {
        _empty = true;
    }

    _json = json;

    return self;
}

- (instancetype)initWithSTDJSONDictionary:(NSDictionary *)json
{
    self = [super init];
    if (!self || json == nil) {
        return nil;
    }

    NSDictionary *firstElement = [((NSArray *)json[@"ads"]) firstObject];
    NSString *html = firstElement[@"html"];
    if (!firstElement || !html) {
        return nil;
    }

    NSData *htmlData = [html dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *htmlDictionary = [DLSplashAd parseJSONData:htmlData];
    if (!htmlDictionary) {
        return nil;
    }

    _imageURL = [NSURL URLWithString:htmlDictionary[@"image"]];
    _imageWidth = [htmlDictionary[@"width"] doubleValue];
    _imageHeight = [htmlDictionary[@"height"] doubleValue];
    _auditURL = [NSURL URLWithString:htmlDictionary[@"audit"]];
    _audit2URL = [NSURL URLWithString:htmlDictionary[@"audit2"]];
    _clickURL = [NSURL URLWithString:htmlDictionary[@"click"]];
    _text = htmlDictionary[@"txt"];
    _time = [htmlDictionary[@"time"] doubleValue];
    _textColor = nil;
    _version = [NSString stringWithFormat:@"%@", htmlDictionary[@"ver"]];

    if (_imageURL && _imageWidth && _imageHeight && _auditURL && _audit2URL && _clickURL && _version && _text && _time) {
        _empty = false;
    } else {
        _empty = true;
    }

    _json = json;

    return self;
}

- (instancetype)initWithEmptyJSONDictionary:(NSDictionary *)json
{
    self = [super init];
    if (!self || json == nil) {
        return nil;
    }

    _empty = true;
    _json = json;

    return self;
}

#pragma mark - private methods

+ (NSDictionary *)parseJSONData:(NSData *)data
{
    if (!data) {
        return nil;
    }

    NSError *parsingError = nil;
    NSDictionary *bodyDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:kNilOptions
                                                                     error:&parsingError];

    if (parsingError) {
        NSLog(@"Parsing error occurred: %@", parsingError.description);
        return nil;
    }

    return bodyDictionary;
}

+ (NSString *)splashTypeFromJSON:(NSDictionary *)json {
    NSDictionary *firstElement = [((NSArray *)json[@"ads"]) firstObject];

    return firstElement[@"type"];
}

@end
