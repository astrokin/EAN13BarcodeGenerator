# EAN13BarcodeGenerator

[![CI Status](https://img.shields.io/travis/astrokin/EAN13BarcodeGenerator.svg?style=flat)](https://travis-ci.org/astrokin/EAN13BarcodeGenerator)
[![Version](https://img.shields.io/cocoapods/v/EAN13BarcodeGenerator.svg?style=flat)](https://cocoapods.org/pods/EAN13BarcodeGenerator)
[![License](https://img.shields.io/cocoapods/l/EAN13BarcodeGenerator.svg?style=flat)](https://cocoapods.org/pods/EAN13BarcodeGenerator)
[![Platform](https://img.shields.io/cocoapods/p/EAN13BarcodeGenerator.svg?style=flat)](https://cocoapods.org/pods/EAN13BarcodeGenerator)

Simple and performance solution to generate EAN13 barcode for iOS applications

![alt tag](Screen.png)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```Objective-C
#import "BarCodeView.h"
#import "BarCodeEAN13.h"

BarCodeView *barCodeView = [[BarCodeView alloc] initWithFrame:kBarCodeFrame];
[self.view addSubview:barCodeView];
[barCodeView setBarCode:GetNewRandomEAN13BarCode()];

```

If you need any additional functionality please contact me.

If you have any questions don't hesitate to contact me.

Have a nice day! =)


## Requirements

iOS 8+

## Installation

EAN13BarcodeGenerator is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'EAN13BarcodeGenerator'
```

## Author

Alexey Strokin, alex.strok@gmail.com

## License

EAN13BarcodeGenerator is available under the MIT license. See the LICENSE file for more info.
