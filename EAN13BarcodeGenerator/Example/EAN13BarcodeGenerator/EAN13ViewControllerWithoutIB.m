//
//  EAN13ViewControllerWithoutIB.m
//  EAN13BarcodeGenerator_Example
//
//  Created by Aliaksei Strokin on 10/27/18.
//  Copyright © 2018 Alexey Strokin. All rights reserved.
//

#import "EAN13ViewControllerWithoutIB.h"
#import "UIView+Animation.h"

@import EAN13BarcodeGenerator;

static const CGRect kLabelFrame = {{0.0, 120.0},{320.0, 30.0}};
static const CGRect kBarCodeFrame = {{103.0, 155.0},{250.0, 100.0}};
static const CGRect kButtonFrame = {{85.0, 320.0},{150.0, 30.0}};
static const CGRect kTextFieldFrame = {{60.0, 270.0},{200.0, 30.0}};

@interface EAN13ViewControllerWithoutIB () <UITextFieldDelegate>
{
    BarCodeView *barCodeView;
    UIButton *button;
    UITextField *textField;
}
@end

@implementation EAN13ViewControllerWithoutIB

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
    [barCodeView setBarCode:newNum];
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
        [textField lockAnimation];
        return;
    }
    [self setNumber:GetNewRandomEAN13BarCode()];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)aTextField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\u200B"] || [string isEqualToString:@""])
    {
        return YES; // detect backspase/delete
    }
    
    NSCharacterSet *set = [NSCharacterSet decimalDigitCharacterSet];
    if ([string rangeOfCharacterFromSet:set].location == NSNotFound)  return NO; //disallow any other except digits
    
    NSString *result = [aTextField.text stringByAppendingString:string];
    return result.length <= 13;
}

@end
