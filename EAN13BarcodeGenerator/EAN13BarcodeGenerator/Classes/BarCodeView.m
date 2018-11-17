//
//  BarCodeView.m
//  BarcodeEAN13GenDemo
//
//  Created by Strokin Alexey on 8/27/13.
//  Copyright (c) 2013 Strokin Alexey. All rights reserved.
//

#import "BarCodeView.h"
#import "BarCodeEAN13.h"

static const NSInteger kTotlaBarCodeLength = 113; //never change this

@interface BarCodeView () {
    BOOL binaryCode[kTotlaBarCodeLength];
    BOOL validBarCode;
}

-(NSString*)firstDigitOfBarCode;
-(NSString*)manufactureCode;
-(NSString*)productCode;
-(NSString *)checkSum;

@end

@implementation BarCodeView

-(id)initWithFrame:(CGRect)frame
{
    NSAssert(frame.size.width >= kTotlaBarCodeLength, @"Incorrect BarCodeView frame.size.width!");
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        [self commonInit];
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    NSAssert(self.frame.size.width >= kTotlaBarCodeLength, @"Incorrect BarCodeView frame.size.width!");
    [self commonInit];
}
-(void)commonInit
{
    self.bgColor = [UIColor whiteColor];
    self.drawableColor = [UIColor blackColor];
    self.font = [UIFont systemFontOfSize:15];
    self.shouldShowNumbers = YES;
    self.lettersSpacing = 1;
}
-(void)setBarCode:(NSString *)newbarCode
{
    if (newbarCode != _barCode)
    {
        _barCode = newbarCode;
        validBarCode = isValidBarCode(_barCode);
        if (validBarCode)
        {
            CalculateBarCodeEAN13(_barCode, binaryCode);
            [self setNeedsDisplay];
        }
    }
    if (!validBarCode)
    {
        memset(binaryCode, 0, sizeof(binaryCode));
        [self setNeedsDisplay];
    }
}
-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    CGContextSetAllowsAntialiasing(context, NO);
    if (!validBarCode)
    {
//    draw error
        [self.bgColor set];
        CGContextFillRect(context, rect);
        
        UIFont* font = [UIFont systemFontOfSize:15];
        UIColor* textColor = [UIColor redColor];
        
        NSDictionary* stringAttrs = @{ NSFontAttributeName : font,
                                       NSForegroundColorAttributeName : textColor };
        NSAttributedString* attrStr = [[NSAttributedString alloc]
                                       initWithString:@"Invalid barcode!" attributes:stringAttrs];
        
        [attrStr drawAtPoint:CGPointMake(3.f, rect.size.height/2-20)];
        return;
    }
    
//   draw barcode
    CGContextBeginPath(context);
    CGFloat lineWidth = rect.size.width / kTotlaBarCodeLength;
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, lineWidth);
    for (NSInteger i = 0; i < kTotlaBarCodeLength; i++)
    {
        [binaryCode[i] ? self.drawableColor : self.bgColor set];
        CGFloat point = i * lineWidth;
        
        CGContextMoveToPoint(context, point, 0.0f);
        CGContextAddLineToPoint(context, point, rect.size.height);
        CGContextStrokePath(context);
        
//        for pixel perfect UI we need to stroke another line no avoid "noise"
        if (!binaryCode[i]) {
            CGFloat point = i * lineWidth + 0.5f;
            CGContextMoveToPoint(context, point, 0.0f);
            CGContextAddLineToPoint(context, point, rect.size.height);
            CGContextStrokePath(context);
        }
    }
//   stroke the last line
    [self.bgColor set];
    CGContextMoveToPoint(context, rect.size.width, 0.0f);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);
    
//   stroke numbers if needed
    if (self.shouldShowNumbers) {
        NSDictionary *stringAttrs = @{
                                      NSFontAttributeName : self.font,
                                      NSForegroundColorAttributeName : self.drawableColor,
                                      NSBackgroundColorAttributeName : self.bgColor
                                      };
        NSMutableDictionary *centerAligned = [stringAttrs mutableCopy];
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        centerAligned[NSParagraphStyleAttributeName] = paragraphStyle;
//        magic number needed to have perfect strings drawing
        self.lettersSpacing = 2.5;
        centerAligned[NSKernAttributeName] = @(self.lettersSpacing);
        
        NSMutableDictionary *rightAligned = [stringAttrs mutableCopy];
        paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.alignment = NSTextAlignmentRight;
        rightAligned[NSParagraphStyleAttributeName] = paragraphStyle;
        
        CGFloat height = self.font.lineHeight;
        CGFloat originY = rect.size.height - height;

//      draw first digit
        NSAttributedString *firstDigitOfBarCode = [[NSAttributedString alloc] initWithString:self.firstDigitOfBarCode attributes:rightAligned];
        CGRect firstDigitRect = CGRectMake(0, originY, lineWidth * 8, height);
        [self drawFilledBackgroundRect:firstDigitRect inContext:context];
        [self.drawableColor set];
        [firstDigitOfBarCode drawInRect:firstDigitRect];
//      draw manufacture code
        NSAttributedString *manufactureCode = [[NSAttributedString alloc] initWithString:self.manufactureCode attributes:centerAligned];
        CGRect manufactureRect = CGRectMake(lineWidth * 4, originY, lineWidth * 60, height);
        [self drawFilledBackgroundRect:manufactureRect inContext:context];
        [self.drawableColor set];
        [manufactureCode drawInRect:manufactureRect];
        
//      draw product code with checksum
        NSAttributedString *productCode = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", [self productCode], [self checkSum]] attributes:centerAligned];
        CGRect productCodeRect = CGRectMake(lineWidth * 55, originY, lineWidth * 45, height);
        [self drawFilledBackgroundRect:productCodeRect inContext:context];
        [self.drawableColor set];
        [productCode drawInRect:productCodeRect];
    }
}
-(void)drawFilledBackgroundRect:(CGRect)rect inContext:(CGContextRef)context {
    const CGFloat *colors = CGColorGetComponents(self.bgColor.CGColor);
    CGContextSetRGBFillColor(context, colors[0], colors[1], colors[2], colors[3]);
    CGContextSetRGBStrokeColor(context, colors[0], colors[1], colors[2], colors[3]);
    CGContextFillRect(context, rect);
}
-(NSString*)firstDigitOfBarCode
{
    return [self.barCode substringToIndex:1];
}
-(NSString*)manufactureCode
{
    return [self.barCode substringWithRange:NSMakeRange(1, 6)];
}
-(NSString*)productCode
{
    return [self.barCode substringWithRange:NSMakeRange(7, 5)];
}
- (NSString *)checkSum
{
    return [self.barCode substringWithRange:NSMakeRange(12, 1)];
}
-(void)setShouldShowNumbers:(BOOL)shouldShowNumbers
{
    _shouldShowNumbers = shouldShowNumbers;
    [self setNeedsDisplay];
}
-(void)setFont:(UIFont *)font {
    _font = font;
    [self setNeedsDisplay];
}
@end
