//
//  BarcodeEAN13.m
//  BarcodeEAN13GenDemo
//
//  Created by Strokin Alexey on 8/27/13. Assist Eugene Hermann
//  Copyright (c) 2013 Strokin Alexey. All rights reserved.
//

#import "BarCodeEAN13.h"

////////////////////////////////////////////////////////////////////////////////

enum 
{
   Odd = 0,
   Even = 1
}
typedef Parity;


#define ShiftCopyBoolArray(dst, src, size) \
do\
{\
	memcpy(dst, src, size);\
	dst += size;\
} while (0)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wduplicate-decl-specifier"


static const int kBarCodeLength = 12;

static const BOOL const bQuiteZone[] = {0,0,0,0,0,0,0,0,0};

static const BOOL const bLeadTrailer[] = {1,0,1};

static const BOOL const bSeporator[] = {0,1,0,1,0};

static const BOOL const bOddLeft[10][7] = {
	{0,0,0,1,1,0,1}, {0,0,1,1,0,0,1}, {0,0,1,0,0,1,1}, {0,1,1,1,1,0,1}, 
	{0,1,0,0,0,1,1}, {0,1,1,0,0,0,1}, {0,1,0,1,1,1,1}, {0,1,1,1,0,1,1}, 
	{0,1,1,0,1,1,1}, {0,0,0,1,0,1,1}
};

static const BOOL const  bEvenLeft[10][7] = {
	{0,1,0,0,1,1,1}, {0,1,1,0,0,1,1}, {0,0,1,1,0,1,1}, {0,1,0,0,0,0,1}, 
	{0,0,1,1,1,0,1}, {0,1,1,1,0,0,1}, {0,0,0,0,1,0,1}, {0,0,1,0,0,0,1}, 
	{0,0,0,1,0,0,1}, {0,0,1,0,1,1,1}
};

static const BOOL const  bRight[10][7] = {
	{1,1,1,0,0,1,0}, {1,1,0,0,1,1,0}, {1,1,0,1,1,0,0}, {1,0,0,0,0,1,0}, 
	{1,0,1,1,1,0,0}, {1,0,0,1,1,1,0}, {1,0,1,0,0,0,0}, {1,0,0,0,1,0,0}, 
	{1,0,0,1,0,0,0}, {1,1,1,0,1,0,0}
};

static const BOOL const bParity[10][5] = {
	{0,0,0,0,0}, {0,1,0,1,1}, {0,1,1,0,1}, {0,1,1,1,0}, {1,0,0,1,1}, 
	{1,1,0,0,1}, {1,1,1,0,0}, {1,0,1,0,1}, {1,0,1,1,0}, {1,1,0,1,0}
};

#pragma clang diagnostic pop


////////////////////////////////////////////////////////////////////////////////


static BOOL* FillManufactureCode(BOOL *dst, int *code)
{
//	DLog(@"");
	const int manufacturePos = 2;
	const int manufactureLen = 5;
	int firstDigit = code[0];
	int pos = manufacturePos;
	for (int i = 0; i < manufactureLen; i++, pos++)
	{
		int num = code[pos];
		Parity parity = (bParity[firstDigit][i] == 0) ? Odd : Even;
		BOOL *bin;
		if (parity == Odd)
		{
			bin = (BOOL *)bOddLeft[num];
		}
		else
		{
			bin = (BOOL *)bEvenLeft[num];
		}
		ShiftCopyBoolArray(dst, bin, 7);
	}
	return dst;
}

static BOOL *FillProductCode(BOOL *dst, int *barCode)
{
	const int productPos = 7;
	const int productLen = 5;
	int codePos = productPos;
	for (int i = 0; i < productLen; i++, codePos++)
	{
		int num = barCode[codePos];
		BOOL *bin = (BOOL *)bRight[num];
		ShiftCopyBoolArray(dst, bin, 7);
	}
	return dst;
}

static BOOL *FillCheckSumm(BOOL *dst, int *barCode)
{
	int sum = 0;
	for (int pos = 0; pos < 12; pos ++)
	{
		int num = barCode[pos];
		int factor = ((pos % 2 == 0) ? 1 : 3);
		sum += num * factor;
	}
	int ost = sum % 10;
	int result = (10 - ost) % 10;
	BOOL *bin = (BOOL *)bRight[result];
	ShiftCopyBoolArray(dst, bin, 7);
	return dst;
}

static int* InitializeBarCode(NSString *barCodeString)
{
	int *barCode = calloc(kBarCodeLength, sizeof(int));
	size_t barLength = barCodeString.length;
	barLength = MIN(barLength, 12);
	unichar *stringBuf = calloc(barLength, sizeof(unichar));
	NSRange range = {0, barLength};
	[barCodeString getCharacters:stringBuf range:range];
	for (int i = 0; i < barLength; i++)
	{
		barCode[i] = stringBuf[i] - 0x30;
		if (barCode[i] < 0 || barCode[i] > 9)
		{
			barCode[i] = 0;
		}
	}
	free(stringBuf);
	return barCode;
}


//////////////////////////////////////////////////////////////////////////////////

void CalculateBarCodeEAN13(NSString *barCodeString, BOOL *buffer)
{
	int *barCode = InitializeBarCode(barCodeString);
   BOOL *bp = buffer;
	ShiftCopyBoolArray(bp, bQuiteZone, 9);
	ShiftCopyBoolArray(bp, bLeadTrailer, 3);
	int countryCode = barCode[1];
	ShiftCopyBoolArray(bp, bOddLeft[countryCode], 7);
	bp = FillManufactureCode(bp, barCode);
	ShiftCopyBoolArray(bp, bSeporator, 5);
	bp = FillProductCode(bp, barCode);
   bp = FillCheckSumm(bp, barCode);
	ShiftCopyBoolArray(bp, bLeadTrailer, 3);
	ShiftCopyBoolArray(bp, bQuiteZone, 9);
	
	free(barCode);
}

NSString *GetNewRandomEAN13BarCode()
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

