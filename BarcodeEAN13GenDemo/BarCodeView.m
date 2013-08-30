//
//  BarCodeView.m
//  BarcodeEAN13GenDemo
//
//  Created by Strokin Alexey on 8/27/13.
//  Copyright (c) 2013 Strokin Alexey. All rights reserved.
//

static NSString *kInvalidText = @"Invalid barcode!";

static const CGFloat kDigitLabelHeight = 15.0f;
static const NSInteger kTotlaBarCodeLength = 113; //never change this

#import "BarCodeView.h"
#import "AppDelegate.h"


@interface BarCodeView ()
{
   CGFloat horizontalOffest;

	BOOL binaryCode[kTotlaBarCodeLength];
	BOOL validBarCode;
   
   UILabel *firstDigitLabel;
   UILabel *manufactureCodeLabel;
   UILabel *productCodeLabel;
   UILabel *checkSumLabel; // separate label because of sometime UI need it
}

-(BOOL)isValidBarCode:(NSString*)barCode;

-(void)createNumberLabels;

-(UILabel*)labelWithWidth:(CGFloat)aWidth andOffset:(CGFloat)offset
   andValue:(NSString*)aValue;

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
      _bgColor = [UIColor whiteColor];
      _drawableColor = [UIColor blackColor];
      horizontalOffest = (frame.size.width-kTotlaBarCodeLength)/2;
      [self createNumberLabels];
   }
   return self;
}
-(void)setBarCodeNumber:(NSString *)newBarCodeNumber
{
   if (newBarCodeNumber != _barCodeNumber)
   {
      _barCodeNumber = newBarCodeNumber;
		validBarCode = [self isValidBarCode:_barCodeNumber];
      if (validBarCode)
      {
			CalculateBarCodeEAN13(_barCodeNumber, binaryCode);
         [self updateLables];
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
   CGContextRef c = UIGraphicsGetCurrentContext();
   CGContextClearRect(c, rect);
   if (!validBarCode)
   {
//    draw error
      [_bgColor set];
      CGContextFillRect(c, rect);

      UIFont* font = [UIFont systemFontOfSize:20];
      UIColor* textColor = [UIColor redColor];
   
      NSDictionary* stringAttrs = @{ NSFontAttributeName : font,
         NSForegroundColorAttributeName : textColor };
      NSAttributedString* attrStr = [[NSAttributedString alloc]
         initWithString:kInvalidText attributes:stringAttrs];

      [attrStr drawAtPoint:CGPointMake(5.f, rect.size.height/2-20)];
      return;
   }
//   draw barcode
	CGContextBeginPath(c);
	for (int i = 0; i < kTotlaBarCodeLength; i++)
	{
   
      [binaryCode[i] ? _drawableColor : _bgColor set];
		CGContextMoveToPoint(c, i+horizontalOffest, 0.0f);
		CGContextAddLineToPoint(c, i+horizontalOffest, self.bounds.size.height);
		CGContextStrokePath(c);
	}
}
#warning add checksum controll logic
-(BOOL)isValidBarCode:(NSString*)barCode
{
   BOOL valid = NO;
   NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
   NSCharacterSet *inStringSet = [NSCharacterSet
		characterSetWithCharactersInString:barCode];
   if ([alphaNums isSupersetOfSet:inStringSet] && barCode.length == 13)
   {
      valid = YES;
   }
   return valid;
}

-(void)updateLables
{
   firstDigitLabel.text = [self firstDigitOfBarCode];
   manufactureCodeLabel.text = [self manufactureCode];
   productCodeLabel.text = [self productCode];
   checkSumLabel.text = [self checkSum];
}

-(void)createNumberLabels
{
// smoke UI label for better visability
   CGFloat smokeHeight = 6.0f;
   UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(horizontalOffest, self.bounds.size.height-smokeHeight, kTotlaBarCodeLength-1, smokeHeight)];
   l.backgroundColor = _bgColor;
   [self addSubview:l];
//   
   CGFloat offset = horizontalOffest;
   CGFloat labelWidth = 7.0f;
   firstDigitLabel = [self labelWithWidth:labelWidth andOffset:offset andValue:[self firstDigitOfBarCode]];
   [self addSubview:firstDigitLabel];
   offset += 12;
   manufactureCodeLabel = [self labelWithWidth:labelWidth*6 andOffset:offset andValue:[self manufactureCode]];
   [self addSubview:manufactureCodeLabel];
   offset += 46;
   productCodeLabel = [self labelWithWidth:labelWidth*5 andOffset:offset andValue:[self productCode]];
   productCodeLabel.textAlignment = NSTextAlignmentRight;
   [self addSubview:productCodeLabel];
   offset += 35;
   checkSumLabel = [self labelWithWidth:labelWidth andOffset:offset andValue:[self checkSum]];
   [self addSubview:checkSumLabel];
}
-(UILabel*)labelWithWidth:(CGFloat)aWidth andOffset:(CGFloat)offset
   andValue:(NSString*)aValue
{
   UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(offset,
      self.bounds.size.height - kDigitLabelHeight, aWidth, kDigitLabelHeight)];
   label.backgroundColor = _bgColor;
   label.textColor = _drawableColor;
   label.textAlignment = NSTextAlignmentCenter;
   label.font = [UIFont boldSystemFontOfSize:kDigitLabelHeight-4];
   label.text = aValue;
   return label;
}
-(NSString*)firstDigitOfBarCode
{
   return [self.barCodeNumber substringToIndex:1];
}
-(NSString*)manufactureCode
{
   return [self.barCodeNumber substringWithRange:NSMakeRange(1, 6)];
}
-(NSString*)productCode
{
   return [self.barCodeNumber substringWithRange:NSMakeRange(7, 5)];
}
- (NSString *)checkSum
{
   return [_barCodeNumber substringWithRange:NSMakeRange(12, 1)];
}
-(void)setShouldShowNumbers:(BOOL)shouldShowNumbers
{
   for (UILabel *label in self.subviews)
   {
      if ([label isKindOfClass:[UILabel class]]) label.hidden = !shouldShowNumbers;
   }
}
@end
