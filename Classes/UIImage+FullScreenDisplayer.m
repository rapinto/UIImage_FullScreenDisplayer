//
//  UIImage+FullScreenDisplayer.m
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



#import "UIImage+FullScreenDisplayer.h"
#import "FullScreenImageDisplayerViewController.h"
#import <AppUtils/AppUtils.h>



#pragma mark -
#pragma mark Gesture Recognizer .m
#pragma mark -



@implementation FullScreenImageDisplayerTapGestureRecognizer



@synthesize imageURL;
@synthesize openingBlock;
@synthesize closingBlock;



- (void)dealloc
{
}



@end






#pragma mark -
#pragma mark UIImage + FullScreenDisplayer .m
#pragma mark -




@implementation UIImageView (FullScreenImageDisplayer)



#pragma mark -
#pragma mark Object Life Cycle Methods



- (void)addFullScreenDisplayerWithImageURL:(NSURL*)url
{
    [self addFullScreenDisplayerWithImageURL:url
                                      onOpen:nil
                                     onClose:nil];
}


- (void)addFullScreenDisplayerWithImageURL:(NSURL*)url
                                    onOpen:(FullScreenImageDisplayOpeningBlock)open
                                   onClose:(FullScreenImageDisplayClosingBlock)close
{
    self.userInteractionEnabled = YES;
    
    
    FullScreenImageDisplayerTapGestureRecognizer* lTapGesture = [[FullScreenImageDisplayerTapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    lTapGesture.imageURL = url;
    lTapGesture.openingBlock = open;
    lTapGesture.closingBlock = close;
    [self addGestureRecognizer:lTapGesture];
}


- (void)removeFullScreenDisplayer
{
    for (UIGestureRecognizer * aGesture in self.gestureRecognizers)
    {
        if ([aGesture isKindOfClass:[FullScreenImageDisplayerTapGestureRecognizer class]])
        {
            [self removeGestureRecognizer:aGesture];
        }
    }
}



#pragma mark -
#pragma mark User Interaction Methods



- (void) didTap:(FullScreenImageDisplayerTapGestureRecognizer*)gestureRecognizer
{
    if (gestureRecognizer.openingBlock)
    {
        gestureRecognizer.openingBlock();
    }
    
    FullScreenImageDisplayerViewController* lFullScreenDisplayer = [[FullScreenImageDisplayerViewController alloc] initWithNibName:@"FullScreenImageDisplayerViewController"
                                                                                                                            bundle:nil
                                                                                                                          imageURL:gestureRecognizer.imageURL
                                                                                                                           onClose:gestureRecognizer.closingBlock
                                                                                                                  defaultImageView:self];
    
    float iOSVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (iOSVersion >= 8.0f)
    {
        [lFullScreenDisplayer setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }
    else
    {
        [lFullScreenDisplayer setModalPresentationStyle:UIModalPresentationCustom];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    
    [[AppUtils getFirstResponderViewController] presentViewController:lFullScreenDisplayer
                                                             animated:NO
                                                           completion:nil];
}


@end
