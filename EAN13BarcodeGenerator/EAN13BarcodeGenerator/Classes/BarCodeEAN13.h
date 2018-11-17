//
//  BarCodeEAN13.h
//
//  Created by Alexey Strokin on 11/3/14.
//  Copyright (c) 2014 Strokin Alexey. All rights reserved.
//

#import <Foundation/Foundation.h>

extern void CalculateBarCodeEAN13(NSString *barCodeString, BOOL *buffer);
extern NSString *GetNewRandomEAN13BarCode(void);
extern BOOL isValidBarCode(NSString* barCode);
