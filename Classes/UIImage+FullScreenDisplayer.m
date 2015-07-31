//
//  UIImage+FullScreenDisplayer.m
//  Dealabs
//
//  Created by Raphaël Pinto on 27/07/2015.
//  Copyright (c) 2015 HUME Network. All rights reserved.
//



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
