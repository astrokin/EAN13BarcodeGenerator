//
//  BarCodeView.h
//  BarcodeEAN13GenDemo
//
//  Created by Strokin Alexey on 8/27/13.
//  Copyright (c) 2013 Strokin Alexey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarCodeView : UIView

@property (nonatomic, strong) NSString * barCodeNumber;

@property (nonatomic, strong) UIColor * drawableColor; //default black
@property (nonatomic, strong) UIColor *bgColor; // default white

@property (nonatomic, assign) BOOL shouldShowNumbers; //default YES

@end
