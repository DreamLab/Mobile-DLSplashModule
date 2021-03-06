//
//  DLSplashConsentParams.h
//  DLSplashModule
//
//  Created by Kordal Paweł on 11.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Parameters required for passing User Consents over to DAS Server
 */
@interface DLSplashConsentParams : NSObject

/**
 PUB Consent
 */
@property (nonatomic, strong, readonly) NSString *pubConsent;

/**
 ADP Consent
 */
@property (nonatomic, strong, readonly) NSString *adpConsent;

/**
 EU Consent
 */
@property (nonatomic, strong, readonly) NSString *euConsent;

/**
 Parameters for privacy consents. To be retrieved from DLPrivacy module.

 @param pubConsent String
 @param adpConsent String
 @param euConsent String
 @return DLSponsorigConsentParams
 */
- (instancetype _Nonnull)initWithPubConsent:(NSString* _Nonnull)pubConsent
                                 adpConsent:(NSString* _Nonnull)adpConsent
                                  euConsent:(NSString* _Nonnull)euConsent;

@end
