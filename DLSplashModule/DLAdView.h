//
//  DLAdView.h
//  DLSplashModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLAdViewDelegate.h"
#import "DLSplashModuleDelegate.h"

@import UIKit;
@import Foundation;

/**
View to display the image of the ad.
 */
@interface DLAdView : UIView <DLSplashModuleDelegate>

/**
 Delegate of the DLAdViewDelegate protocol.
 */
@property (nonatomic, weak) id<DLAdViewDelegate> delegate;

@end
