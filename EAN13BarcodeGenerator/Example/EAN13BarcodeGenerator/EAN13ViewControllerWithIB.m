//
//  EAN13ViewControllerWithIB.m
//  EAN13BarcodeGenerator_Example
//
//  Created by Aliaksei Strokin on 10/27/18.
//  Copyright © 2018 Alexey Strokin. All rights reserved.
//

#import "EAN13ViewControllerWithIB.h"
#import "UIView+Animation.h"

@import EAN13BarcodeGenerator;

@interface EAN13ViewControllerWithIB ()

@property (strong, nonatomic) IBOutlet BarCodeView *barcodeView;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UISlider *sliderForScale;


@end

@implementation EAN13ViewControllerWithIB

- (IBAction)applyScale:(UISlider *)sender {
    _barcodeView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f/sender.value, 1.0f/sender.value);
}
- (IBAction)showNumbersValueChanged:(UISwitch *)sender {
    _barcodeView.shouldShowNumbers = sender.isOn;
}

- (IBAction)generateAction:(id)sender {
    if (_textField.text.length == 13)
    {
        [self setNumber:_textField.text];
        return;
    }
    else if (_textField.text.length > 0)
    {
        [_textField lockAnimation];
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
