# FitAnalytics WebWidget Integration in iOS (Objective-C)

## Overview

The WebWidget SDK allows integrating the FitAnalytics Size Advisor widget into your own rojects. The method of integration currently supported by this SDK is by loading HTML/JS-based widget code in a separate UIWebView instance and establishing a communication between the host app and the embedded web widget.

The SDK exports the **FitAWebWidget** class, which serves as a main widget controller. It creates and initialises the widget in a provided web view instance and exposes several methods that allow controlling the widget.

Additionally, it defines the **FITAWebWidgetHandler** interface, which allows registering various callbacks (by implementing them as interface methods). These callbacks are invoked by the widget controller during various events (e.g. when the user closes the widget, the when widget has received a recommendation etc).

---

## Installation (using Cocoapods)

**Prerequisities:** 

XCode 7 or higher

IOS 8 or higher

**Step 1.** Make sure you already have cocoapods installed in your system. Otherwise you can follow steps in cocoapods documentation to install
https://cocoapods.org/

**Step 2.** To initialize the pod in your project use `pod init` command to create a Podfile with smart defaults.

**Step 3.** Now you can install the dependencies in your project by using `pod install` command.

**Step 4.** Make Sure you always open **Xcode Workspace** instead of Xcode Project. You can do it by
using **open YourApp.xcworkspace** command in terminal.

---

## Integration Procedure

We're presuming the a simple app with a single main ViewController class.

Import the **FitAWebWidget.h** and the **FITAWebWidgetHandler.h** in your **ViewController.m**
 
```objc
#import "FITAWebWidget.h"
#import “FITAWebWidgetHandler.h"
```

The view controller class implements the **FITAWebWidgetHandler** interface, so the widget callback can be implemented directly on it.

```objc
@interface ViewController ()<FITAWebWidgetHandler>
```

Add a property for storing the reference to the widget.

```objc
@property (nonatomic, strong) FITAWebWidget *widget;
```

Add property for the webView reference. This is the UIWebView instance that will contain the load widget container page.

```objc
@property (weak, nonatomic) IBOutlet UIWebView *webView;
```

Initialize the widger controller with the UIWebView instance and assign self as the callback handler.

```objc
self.widget = [[FITAWebWidget alloc] initWithWebView:self.webView handler:self];
```

## Methods

 - **- (BOOL)load**

Begin loading the HTML widget container page.

```objc
[self.widget load];
```

 - **- (BOOL)create:productSerial options:NSDictionary**

Create  and (optionally) initialize it with product serial and other options.

Create a widget instance inside the container page by passing the `productSerial` and `options`. Option can be ‘NIL’ or a dictionary of various options argument. Important supported options are listed [here](#configurable-widget-options).

This method should be called only after the **WebWidgetDidBecomeReady** callback has been called (or inside the callback) and will return a `true` when the widget was successfully created.

```objc
[self.widget create:@"example-123456" options:@{ "sizes": @[ @"S", @"XL" ] }];
```

 - **- (void)open**

Show the actual widget. It may trigger loading additional resources over network, and will show the widget only after all assets have been loaded. When the opening has finished the **WebWidgetDidOpen** callback will be called on the callback handler.

```objc
[self.widget open];
```

 - **- (void)openWithOptions:productSerial options:NSDictionary**

Configure the widget with new productSerial and/or options and show it. See `open` above for more details.

```objc
[self.widget open:@"example-123456" options:@{ "sizes": @[ @"S", @"XL" ] ];
```

 - **- (void) close**

Close the widget and removes the widget markup. Will trigger the **webWidgetDidClose** callback when it has finished.

```objc
[self.widget close];
```

 - **- (void) recommend**

Request a recommendation. The recommended size and additional details will be returned as arguments to the **WebWidgetDidRecommend** callback.

```objc
[self.widget recommend];
```

 - **3.7 - (void) recommendWithOptions:productSerial options:NSDictionary**

Configure the widget with the new productSerial and/or widget options and request a recommendation. See `recommend` above for more details.

```objc
[self.widget recommend:@"example-123456" options:nil];
```

 - **- (void)reconfigure:productSerial options:NSDictionary**

Configure the widget with the new productSerial and/or widget options. If the `productSerial` argument is non-nil and is different from the last provided product serial, this will trigger a request for the product information. After the new product info has been loaded, the **webWidgetDidLoadProduct** will be called. If the product serial is invalid or the product isn't supported by FitAnalytics, the **webWidgetDidFailLoadingProduct** will be called.

```objc
[self.widget reconfigure:@"example-123456" options:nil];

// OR

[self.widget reconfigure:nil options:@{ "sizes": @[ @"XL" ] ];
```

Reconfigure the widget with new product serial and/or widget options object.

## Callbacks

```objc
- (void)webWidgetDidBecomeReady:(FITAWebWidget *)widget;
```

This method will be called when widget container inside the WebView has successfully loaded and is ready to accept commands.


```objc
- (void)webWidgetInitialized:(FITAWebWidget *)widget;
```

This method will be called when widget container inside the WebView has successfully loaded.


```objc
- (void)webWidgetDidFailLoading:(FITAWebWidget *)widget withError:(NSError *)error;
```

This method will be called when widget inside the WebView has failed to load or initialize for some reason.


```objc
- (void)webWidgetDidLoadProduct:(FITAWebWidget *)widget productId:(NSString *)productId details:(NSDictionary *)details;**
```

This method will be called when widget successfully loaded the product info. It means the product is supported and the widget should be able to provide a size recommendation for it.


```objc
- (void)webWidgetDidFailLoadingProduct:(FITAWebWidget *)widget productId:(NSString *)productId details:(NSDictionary *)details;**
```

This method will be called when widget failed to load the product info or the product is not supported.


```objc
- (void)webWidgetDidOpen:(FITAWebWidget *)widget productId:(NSString *)productId;
```

This method will be called when widget has successfully opened after the `open` method call.

## Configurable widget options

`sizes` ..  an array of available sizes for the current product

`manufacturedSizes` .. a dictionary of all manfactured sizes for the current product, including their availability status

`userId` .. the shop's user id, in case the user is logged in

`shopCountry` .. the country of the shop

`language` .. the language mutation of the shop

For the complete list of available widget options and their description, please see http://developers.fitanalytics.com/documentation#list-callbacks-parameters