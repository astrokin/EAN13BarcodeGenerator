//
//  ViewController.m
//  BarcodeEAN13GenDemo
//
//  Created by Strokin Alexey on 8/27/13.
//  Copyright (c) 2013 Strokin Alexey. All rights reserved.
//

#import "ViewController.h"
#import "BarCodeView.h"
#import <QuartzCore/QuartzCore.h>

static inline NSString *GetNewRandomEAN13BarCode()
{
   NSString *result = @"";
   int sum = 0;
   for (int i = 12; i >= 1; i--)
   {
      int m = (i % 2) == 1 ? 3 : 1;
      int value = arc4random() % 10;
      sum += (m*value);
      result = [result stringByAppendingFormat:@"%i", value];
   }
   int cs = 10 - (sum % 10);
   result = [result stringByAppendingFormat:@"%i", cs == 10 ? 0 : cs];
   NSLog(@"Generated barcode: %@", result);
   return result;
}

static const CGRect kLabelFrame = {{0.0, 20.0},{320.0, 30.0}};
static const CGRect kBarCodeFrame = {{103.0, 55.0},{113.0, 100.0}};
static const CGRect kButtonFrame = {{85.0, 220.0},{150.0, 30.0}};
static const CGRect kTextFieldFrame = {{60.0, 170.0},{200.0, 30.0}};

@interface ViewController () <UITextFieldDelegate>
{
   BarCodeView *barCodeView;
   UIButton *button;
   UITextField *textField;
}
@end

@implementation ViewController

-(void)loadView
{
   CGFloat h =  [UIApplication sharedApplication].statusBarHidden ? 0 :
      [UIApplication sharedApplication].statusBarFrame.size.height;
   UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, h,
      [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - h)];
   view.backgroundColor = [UIColor lightGrayColor];
   
   barCodeView = [[BarCodeView alloc] initWithFrame:kBarCodeFrame];
   [view addSubview:barCodeView];

   button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
   button.frame = kButtonFrame;
   [button addTarget:self action:@selector(generate)
      forControlEvents:UIControlEventTouchUpInside];
   [button setTitle:@"Generate" forState:UIControlStateNormal];
   [view addSubview:button];
   
   textField = [[UITextField alloc] initWithFrame:kTextFieldFrame];
   textField.keyboardType = UIKeyboardTypeDecimalPad;
   textField.clearButtonMode = UITextFieldViewModeWhileEditing;
   textField.borderStyle = UITextBorderStyleRoundedRect;
   textField.delegate = self;
   [view addSubview:textField];
   
   UILabel *label = [[UILabel alloc] initWithFrame:kLabelFrame];
   label.backgroundColor = [UIColor clearColor];
   label.textColor = [UIColor blackColor];
   label.textAlignment = NSTextAlignmentCenter;
   label.font = [UIFont systemFontOfSize:20.0f];
   label.text = @"EAN-13";
   [view addSubview:label];
   
   self.view = view;
}

- (void)viewDidLoad
{
   [super viewDidLoad];
   [self generate];
}

- (void)setNumber:(NSString*)newNum
{
   [barCodeView setBarCodeNumber:newNum];
}

- (void)didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];
}

- (void)generate
{
   if (textField.text.length == 13)
   {
      [self setNumber:textField.text];
      return;
   }
   else if (textField.text.length > 0)
   {
      [self lockAnimationForView:textField];
      return;
   }
   [self setNumber:GetNewRandomEAN13BarCode()];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)aTextField shouldChangeCharactersInRange:(NSRange)range
   replacementString:(NSString *)string
{
   if ([string isEqualToString:@"."]) return NO;
   NSString *result = [aTextField.text stringByAppendingString:string];
   return result.length <= 13;
}

-(void)lockAnimationForView:(UIView*)view
{
   CALayer *lbl = [view layer];
   CGPoint posLbl = [lbl position];
   CGPoint y = CGPointMake(posLbl.x-10, posLbl.y);
   CGPoint x = CGPointMake(posLbl.x+10, posLbl.y);
   CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
   [animation setTimingFunction:[CAMediaTimingFunction
      functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
   [animation setFromValue:[NSValue valueWithCGPoint:x]];
   [animation setToValue:[NSValue valueWithCGPoint:y]];
   [animation setAutoreverses:YES];
   [animation setDuration:0.08];
   [animation setRepeatCount:3];
   [lbl addAnimation:animation forKey:nil];
}
@end
