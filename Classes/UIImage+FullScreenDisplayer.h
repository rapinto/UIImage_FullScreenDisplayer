//
//  UIImage+FullScreenDisplayer.h
//
//
//  Created by Raphaël Pinto on 27/07/2015.
//
// The MIT License (MIT)
// Copyright (c) 2015 Raphael Pinto.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.



#import <UIKit/UIKit.h>



typedef void (^FullScreenImageDisplayOpeningBlock)(void);
typedef void (^FullScreenImageDisplayClosingBlock)(void);



#pragma mark -
#pragma mark Gesture Recognizer .h
#pragma mark -



@interface FullScreenImageDisplayerTapGestureRecognizer : UITapGestureRecognizer

@property(nonatomic,strong) NSURL* imageURL;
@property(nonatomic,strong) FullScreenImageDisplayOpeningBlock openingBlock;
@property(nonatomic,strong) FullScreenImageDisplayClosingBlock closingBlock;

@end





#pragma mark -
#pragma mark UIImage + FullScreenDisplayer .h
#pragma mark -



@interface UIImageView (UIImage_FullScreenDisplayer)

- (void)addFullScreenDisplayerWithImageURL:(NSURL*)url;
- (void)addFullScreenDisplayerWithImageURL:(NSURL*)url
                                    onOpen:(FullScreenImageDisplayOpeningBlock)open
                                   onClose:(FullScreenImageDisplayClosingBlock)close;
- (void)removeFullScreenDisplayer;
- (void) didTap:(FullScreenImageDisplayerTapGestureRecognizer*)gestureRecognizer;


@end