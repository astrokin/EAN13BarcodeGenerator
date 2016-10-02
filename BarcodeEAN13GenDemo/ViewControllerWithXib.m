//
//  ViewControllerWithXib.m
//  BarcodeEAN13GenDemo
//
//  Created by Alexey Strokin on 11/3/14.
//  Copyright (c) 2014 Strokin Alexey. All rights reserved.
//

#import "ViewControllerWithXib.h"
#import "BarCodeView.h"
#import "BarCodeEAN13.h"

@interface ViewControllerWithXib ()

@property (strong, nonatomic) IBOutlet BarCodeView *barcodeView;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UISlider *sliderForScale;


@end

@implementation ViewControllerWithXib
- (IBAction)applyScale:(UISlider *)sender {
    _barcodeView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f/sender.value, 1.0f/sender.value);
}

- (IBAction)generateAction:(id)sender {
    if (_textField.text.length == 13)
    {
        [self setNumber:_textField.text];
        return;
    }
    else if (_textField.text.length > 0)
    {
        lockAnimationForView(_textField);
        return;
    }
    [self setNumber:GetNewRandomEAN13BarCode()];
}
- (void)setNumber:(NSString*)newNum
{
    [_barcodeView setBarCode:newNum];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self generateAction:nil];
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
