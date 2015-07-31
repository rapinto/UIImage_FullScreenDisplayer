//
//  UIImage+FullScreenDisplayer.h
//  Dealabs
//
//  Created by Raphaël Pinto on 27/07/2015.
//  Copyright (c) 2015 HUME Network. All rights reserved.
//


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