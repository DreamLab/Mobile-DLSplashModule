//
//  DLAdViewDelegate.h
//  DLSplashModule
//
//  Created by Jacek Zapart on 15.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

@import UIKit;
@import Foundation;
@class DLAdView;

/**
 Protocol of the DLAdViewDelegate.
 */
@protocol DLAdViewDelegate

/**
 Method is called when user taps on the DLAdView.

 @param adView DLAdView that generated event
 @param url NSURL to be displayed in webview
 */
- (void)adView:(DLAdView * _Nonnull)adView didTapImageWithUrl:(NSURL * _Nonnull)url;

/**
 Method is called when DLAdView fulfill the content of the ad.

 @param adView DLAdView that generated this event.
 @param associatedText NSString that should be displayed next to the Ad.
 @param textColor Optional associated text color which should be set for it
 */
- (void)adView:(DLAdView * _Nonnull)adView didDisplayAdWithAssociatedText:(NSString * _Nonnull)associatedText andColor:(UIColor * _Nullable)textColor;

/**
 Notifies that splash screen should be closed - time of displaying it passed.
 */
- (void)splashScreenShouldBeClosed;

@end
