//
//  AppDelegate.h
//  BarcodeEAN13GenDemo
//
//  Created by Strokin Alexey on 8/27/13.
//  Copyright (c) 2013 Strokin Alexey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


static inline UIColor *GetRandomUIColor()
{
   CGFloat r = arc4random() % 255;
   CGFloat g = arc4random() % 255;
   CGFloat b = arc4random() % 255;
   UIColor * color = [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:1.0f];
   return color;
}

static inline void DebugViewBorder(UIView *view)
{
#if defined DEBUG
   view.layer.borderWidth = 1.0f;
   view.layer.cornerRadius = 0.0f;
   view.layer.borderColor = GetRandomUIColor().CGColor;
#endif
}

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
