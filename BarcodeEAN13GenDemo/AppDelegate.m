//
//  AppDelegate.m
//  BarcodeEAN13GenDemo
//
//  Created by Strokin Alexey on 8/27/13.
//  Copyright (c) 2013 Strokin Alexey. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "ViewControllerWithXib.h"

#define USE_XIB 0

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
#if defined USE_XIB
    self.viewController = [[ViewControllerWithXib alloc] initWithNibName:NSStringFromClass([ViewControllerWithXib class]) bundle:[NSBundle mainBundle]];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
#else
    self.viewController = [ViewController new];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
#endif
    return YES;
}

@end
