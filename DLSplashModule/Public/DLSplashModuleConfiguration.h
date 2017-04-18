//
//  DLSplashModuleConfiguration.h
//  DLSplashModule
//
//  Created by Konrad Falkowski on 21/09/16.
//  Copyright © 2016 DreamLab. All rights reserved.
//

@import Foundation;

extern NSString * const kSplashScreenSlotDefaultParameter;

/**
 *  Configuration object form DLSplashModule
 */
@interface DLSplashModuleConfiguration : NSObject

/**
 *  The site URL parameter
 */
@property (nonatomic, strong) NSString * site;

/**
 *  The area URL parameter
 */
@property (nonatomic, strong) NSString * area;

/**
 *  The slot parameter
 */
@property (nonatomic, strong) NSString * slot;

/**
 *  The app version parameter
 */
@property (nonatomic, strong) NSString * appVersion;

/**
 *  Maximum time of waiting for content
 */
@property (nonatomic, assign) NSUInteger maximumWaitingTimeForContent;

/**
 *  Default configuration with default waiting time and slot
 *
 *  @return DLSplashModuleConfiguration
 */
+ (instancetype)defaultConfiguration;

@end
