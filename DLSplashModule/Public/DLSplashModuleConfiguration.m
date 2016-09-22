//
//  DLSplashModuleConfiguration.m
//  DLSplashModule
//
//  Created by Konrad Falkowski on 21/09/16.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLSplashModuleConfiguration.h"

NSTimeInterval const kMaxTimeOfWaitingForContent = 3;
NSString * const kSplashScreenSlotDefaultParameter = @"slots=splash";

@implementation DLSplashModuleConfiguration

+ (instancetype)defaultConfiguration
{
    DLSplashModuleConfiguration *configuration = [[DLSplashModuleConfiguration alloc] init];
    configuration.slot = kSplashScreenSlotDefaultParameter;
    configuration.maximumWaitingTimeForContent = kMaxTimeOfWaitingForContent;

    return configuration;
}
@end
