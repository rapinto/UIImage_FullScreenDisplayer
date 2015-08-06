//
//  FullScreenImageDisplayerViewController.m
//
//
//  Created by Raphaël Pinto on 28/07/2015.
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



#import "FullScreenImageDisplayerViewController.h"
#import <AppUtils/AppUtils.h>
#import <UIImage+RPNetworking.h>



@interface FullScreenImageDisplayerViewController ()

@end



@implementation FullScreenImageDisplayerViewController



#pragma mark -
#pragma mark Object Life Cycle Methods



- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
             imageURL:(NSURL*)imageURL
              onClose:(FullScreenImageDisplayClosingBlock)close
     defaultImageView:(UIImageView*)imageView
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        _tapedImageView = imageView;
        _imageURL = imageURL;
        _closingBlock = close;
        _tapedImageSuperView = _tapedImageView.superview;
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.view.layer.anchorPoint = self.view.center;
    
    [self setupView];
    
    _backgroundBlackColor.alpha = 0.00f;
    _scrollView.hidden = YES;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self showViewAnimated];
}


- (void)dealloc
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


-(BOOL)prefersStatusBarHidden
{
    if (_scrollView.hidden || _isLivingView)
    {
        return NO;
    }
    
    return YES;
}



#pragma mark -
#pragma mark View Update Methods



- (void)showViewAnimated
{
    CGRect lImageContainerStartingFrame = [_tapedImageView convertRect:[[UIScreen mainScreen] bounds] toView:nil];
    lImageContainerStartingFrame = CGRectMake(lImageContainerStartingFrame.origin.x,
                                              lImageContainerStartingFrame.origin.y,
                                              _tapedImageView.frame.size.width,
                                              _tapedImageView.frame.size.height);
    
    UIView* lView = [[UIView alloc] initWithFrame:lImageContainerStartingFrame];
    _imageContainer = lView;
    _imageContainer.backgroundColor = [UIColor clearColor];
    _imageContainer.clipsToBounds = YES;
    

    
    CGRect lImageStartingFrame;
    switch (_tapedImageView.contentMode)
    {
        case UIViewContentModeScaleToFill:
            lImageStartingFrame = CGRectMake(0,
                                             0,
                                             lImageContainerStartingFrame.size.width,
                                             lImageContainerStartingFrame.size.height);
            break;
        case UIViewContentModeScaleAspectFit:
        {
            if (_tapedImageView.image.size.width >= _tapedImageView.image.size.height)
            {
                float lAlpha = lImageContainerStartingFrame.size.width / _tapedImageView.image.size.width;
                float lNewHeight = lAlpha * lImageContainerStartingFrame.size.height;
                lImageStartingFrame = CGRectMake(0,
                                                 (lImageContainerStartingFrame.size.height - lNewHeight) / 2,
                                                 lImageContainerStartingFrame.size.width,
                                                 lNewHeight);
            }
            else
            {
                float lAlpha = lImageContainerStartingFrame.size.height / _tapedImageView.image.size.height;
                float lNewWidth = lAlpha * lImageContainerStartingFrame.size.width;
                lImageStartingFrame = CGRectMake((lImageContainerStartingFrame.size.width - lNewWidth) / 2,
                                                 0,
                                                 lNewWidth,
                                                 lImageContainerStartingFrame.size.height);
            }
        }
            break;
        case UIViewContentModeScaleAspectFill:
        {
            if (_tapedImageView.image.size.width >= _tapedImageView.image.size.height)
            {
                float lAlpha = lImageContainerStartingFrame.size.height / _tapedImageView.image.size.height;
                float lNewWidth = lAlpha * _tapedImageView.image.size.width;
                lImageStartingFrame = CGRectMake((lImageContainerStartingFrame.size.width - lNewWidth) / 2,
                                                 0,
                                                 lNewWidth,
                                                 lImageContainerStartingFrame.size.height);
                
                if (lImageStartingFrame.size.width < lImageContainerStartingFrame.size.width)
                {
                    float lAlpha = lImageContainerStartingFrame.size.width / _tapedImageView.image.size.width;
                    float lNewHeight = lAlpha * _tapedImageView.image.size.height;
                    lImageStartingFrame = CGRectMake(0,
                                                     (lImageContainerStartingFrame.size.height - lNewHeight) / 2,
                                                     lImageContainerStartingFrame.size.width,
                                                     lNewHeight);
                }
            }
            else
            {
                float lAlpha = lImageContainerStartingFrame.size.width / _tapedImageView.image.size.width;
                float lNewHeight = lAlpha * _tapedImageView.image.size.height;
                lImageStartingFrame = CGRectMake(0,
                                                 (lImageContainerStartingFrame.size.height - lNewHeight) / 2,
                                                 lImageContainerStartingFrame.size.width,
                                                 lNewHeight);
                
                if (lImageStartingFrame.size.height < lImageContainerStartingFrame.size.height)
                {
                    float lAlpha = lImageContainerStartingFrame.size.width / _tapedImageView.image.size.width;
                    float lNewHeight = lAlpha * _tapedImageView.image.size.height;
                    lImageStartingFrame = CGRectMake(0,
                                                     (lImageContainerStartingFrame.size.height - lNewHeight) / 2,
                                                     lImageContainerStartingFrame.size.width,
                                                     lNewHeight);
                }
            }
        }
            break;
        case UIViewContentModeRedraw:
            lImageStartingFrame = CGRectZero;
            break;
        case UIViewContentModeCenter:
        {
            lImageStartingFrame = CGRectMake((lImageContainerStartingFrame.size.width - _tapedImageView.image.size.width) / 2,
                                             (lImageContainerStartingFrame.size.height - _tapedImageView.image.size.height) / 2,
                                             _tapedImageView.image.size.width,
                                             _tapedImageView.image.size.height);
        }
            break;
        case UIViewContentModeTop:
        {
            lImageStartingFrame = CGRectMake((lImageContainerStartingFrame.size.width - _tapedImageView.image.size.width) / 2,
                                             0,
                                             _tapedImageView.image.size.width,
                                             _tapedImageView.image.size.height);
        }
            break;
        case UIViewContentModeBottom:
        {
            lImageStartingFrame = CGRectMake((lImageContainerStartingFrame.size.width - _tapedImageView.image.size.width) / 2,
                                             lImageContainerStartingFrame.size.height - _tapedImageView.image.size.height,
                                             _tapedImageView.image.size.width,
                                             _tapedImageView.image.size.height);
        }
            break;
        case UIViewContentModeLeft:
        {
            lImageStartingFrame = CGRectMake(0,
                                             (lImageContainerStartingFrame.size.height - _tapedImageView.image.size.height) / 2,
                                             _tapedImageView.image.size.width,
                                             _tapedImageView.image.size.height);
        }
            break;
        case UIViewContentModeRight:
        {
            lImageStartingFrame = CGRectMake(lImageContainerStartingFrame.size.width - _tapedImageView.image.size.width,
                                             (lImageContainerStartingFrame.size.height - _tapedImageView.image.size.height) / 2,
                                             _tapedImageView.image.size.width,
                                             _tapedImageView.image.size.height);
        }
            break;
        case UIViewContentModeTopLeft:
        {
            lImageStartingFrame = CGRectMake(0,
                                             0,
                                             _tapedImageView.image.size.width,
                                             _tapedImageView.image.size.height);
        }
            break;
        case UIViewContentModeTopRight:
        {
            lImageStartingFrame = CGRectMake(lImageContainerStartingFrame.size.width - _tapedImageView.image.size.width,
                                             0,
                                             _tapedImageView.image.size.width,
                                             _tapedImageView.image.size.height);
        }
            break;
        case UIViewContentModeBottomLeft:
        {
            lImageStartingFrame = CGRectMake(0,
                                             lImageContainerStartingFrame.size.height - _tapedImageView.image.size.height,
                                             _tapedImageView.image.size.width,
                                             _tapedImageView.image.size.height);
        }
            break;
        case UIViewContentModeBottomRight:
        {
            lImageStartingFrame = CGRectMake(lImageContainerStartingFrame.size.width - _tapedImageView.image.size.width,
                                             lImageContainerStartingFrame.size.height - _tapedImageView.image.size.height,
                                             _tapedImageView.image.size.width,
                                             _tapedImageView.image.size.height);
        }
            break;
        default:
            break;
    }
    
    
    
    UIImageView* lImage = [[UIImageView alloc] initWithFrame:lImageStartingFrame];
    _tapedImageViewCopy = lImage;
    _tapedImageViewCopy.backgroundColor = [UIColor clearColor];
    _tapedImageViewCopy.image = _tapedImageView.image;
    _tapedImageViewCopy.contentMode = UIViewContentModeScaleAspectFit;
    
    
    [_imageContainer addSubview:_tapedImageViewCopy];
    [self.view addSubview:_imageContainer];
    _tapedImageView.hidden = YES;
    
    
    
    
    // Determine the final frame for image container and image view
    CGRect lFinalImageContainerFrame = CGRectMake(0, 0, [AppUtils orientationDependentScreenSize].width, [AppUtils orientationDependentScreenSize].height);
    CGRect lFinalImageFrame = CGRectMake(0,
                                         0,
                                         lFinalImageContainerFrame.size.width,
                                         lFinalImageContainerFrame.size.height);
    
    
    // Animate to their final frame the image container and image
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         _imageContainer.frame = lFinalImageContainerFrame;
         _tapedImageViewCopy.frame = lFinalImageFrame;
         
         
         _backgroundBlackColor.alpha = 1.0f;
     }
                     completion:^(BOOL finished)
     {
         if (finished)
         {
             _imageContainer.hidden = YES;
             _scrollView.zoomScale = 1.0f;
             _scrollView.hidden = NO;
             [self setNeedsStatusBarAppearanceUpdate];
         }
     }];
}


- (void)setupView
{
    __weak __typeof(UIScrollView*)weakScrollView = _scrollView;
    __weak __typeof(UIImageView*)weakImageView = _imageView;
    
    [_imageView setImageWithURL:_imageURL
               imageContentMode:UIViewContentModeScaleAspectFit
               placeholderImage:_tapedImageView.image
         placeholderContentMode:UIViewContentModeScaleAspectFit
                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
     {
         weakImageView.contentMode = UIViewContentModeScaleAspectFit;
         weakImageView.image = image;
         weakScrollView.zoomScale = 1.00f;
     }
                        failure:nil];
    
    _isInterfaceDisplayed = YES;
    [self updateInterface];
    
    float iOSVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (iOSVersion < 8.0f)
    {
        self.view.backgroundColor = [UIColor blackColor];
    }
    
    _backgroundBlackColor.frame = CGRectMake(- self.view.frame.size.width / 2,
                                             - self.view.frame.size.height / 2,
                                             self.view.frame.size.width * 2,
                                             self.view.frame.size.height * 2);
}


- (void)updateInterface
{
    if (_isInterfaceDisplayed)
    {
        _closeButton.alpha = 0.0f;
        _closeButton.hidden = NO;
        
        
        [UIView animateWithDuration:0.33
                         animations:^
         {
             _closeButton.alpha = 1.0f;
         }];
    }
    else
    {
        [UIView animateWithDuration:0.33
                         animations:^
         {
             _closeButton.alpha = 0.0f;
         }
                         completion:^(BOOL finished)
         {
             _closeButton.hidden = YES;
         }];
    }
}


- (void)updateViewFrameWithNewSize:(CGSize)_ViewSize
{
    
}

 

#pragma mark -
#pragma mark Scroll View Delegate Methods



- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    _isInterfaceDisplayed = NO;
    [self updateInterface];
}


- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView.zoomScale < 1.05 && !scrollView.isZooming)
    {
        _isInterfaceDisplayed = YES;
        [self updateInterface];
    }
    else if (scrollView.isZooming && scrollView.zoomScale < 0.7)
    {
        self.scrollView.userInteractionEnabled = NO;
        self.scrollView.delegate = nil;
        [self onCloseFullScreenButtonPressed:nil];
    }
    
    
    if (scrollView.zoomScale > 0.7 && !_isLivingView && scrollView.userInteractionEnabled)
    {
        _backgroundBlackColor.alpha = _scrollView.zoomScale;
    }
    else if (!_isLivingView && scrollView.userInteractionEnabled)
    {
        _backgroundBlackColor.alpha = 1.0;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scrollView.zoomScale < 1.05 && _scrollView.zoomScale > 0.7 && !scrollView.isZooming && !_isLivingView && [scrollView isDragging])
    {
        CGFloat y = _scrollView.contentOffset.y + _imageView.frame.origin.y;
        
        CGFloat yDiff = fabs((y + _imageView.frame.size.height/2) - self.view.frame.size.height/2);
        
        _backgroundBlackColor.alpha = MAX(1 - yDiff/(self.view.frame.size.height/2),0.3);
    }
    else if (!_isLivingView && _scrollView.scrollEnabled && !_scrollView.isZooming)
    {
        _backgroundBlackColor.alpha = 1.0f;
    }
    
    
    if (scrollView.zoomScale < 1.05 &&
        [scrollView isDragging] &&
        (scrollView.contentOffset.x > 100 ||
         scrollView.contentOffset.x < -100 ||
         scrollView.contentOffset.y > 100 ||
         scrollView.contentOffset.y < -100))
    {
        CGPoint lOffset = _scrollView.contentOffset;
        _scrollView.scrollEnabled = NO;
        _scrollView.contentOffset = lOffset;
        
        [self onCloseFullScreenButtonPressed:nil];
    }
}



#pragma mark -
#pragma mark User Interaction Methods



- (IBAction)onScrollViewTap:(id)sender
{
    _isInterfaceDisplayed =! _isInterfaceDisplayed;
    
    [self updateInterface];
}


- (IBAction)onScrollViewDoubleTap:(id)sender
{
    if ([sender isKindOfClass:[UITapGestureRecognizer class]])
    {
        CGPoint _Position = [sender locationInView:_scrollView];
        
        if (_scrollView.zoomScale > 1.05)
        {
            [_scrollView setZoomScale:1.0f animated:YES];
        }
        else
        {
            float newZoomScale = MIN(2, _scrollView.maximumZoomScale);
            
            CGSize scrollViewSize = _scrollView.bounds.size;
            
            CGFloat w = scrollViewSize.width / newZoomScale;
            CGFloat h = scrollViewSize.height / newZoomScale;
            CGFloat x = _Position.x - (w / 2.0f);
            CGFloat y = _Position.y - (h / 2.0f);
            
            CGRect rectToZoomTo = CGRectMake(x, y, w, h);
            
            [_scrollView zoomToRect:rectToZoomTo animated:YES];
        }
    }
}


- (IBAction)onCloseFullScreenButtonPressed:(id)sender
{
    if (_isLivingView)
    {
        return;
    }
    _isLivingView = YES;
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    float iOSVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (iOSVersion < 8.0f)
    {
        [_tapedImageViewCopy removeFromSuperview];
        _tapedImageView.hidden = NO;
        
        
        if (_closingBlock)
        {
            _closingBlock();
        }
        
        [self dismissViewControllerAnimated:YES
                                 completion:^{}];
        return;
    }
    
    _imageContainer.frame = CGRectMake(- _scrollView.contentOffset.x,
                                       - _scrollView.contentOffset.y,
                                       _imageView.frame.size.width,
                                       _imageView.frame.size.height);
    _tapedImageViewCopy.frame = CGRectMake(0,
                                  0,
                                  _imageView.frame.size.width,
                                  _imageView.frame.size.height);
    _tapedImageViewCopy.hidden = NO;
    _imageContainer.hidden = NO;
    
    
    CGRect lFinalImageFrame;
    CGRect lTapedImageViewScreenFrame = [_tapedImageView convertRect:[[UIScreen mainScreen] bounds] toView:nil];
    CGRect lFinalImageContainerFrame = CGRectMake(lTapedImageViewScreenFrame.origin.x,
                                                  lTapedImageViewScreenFrame.origin.y,
                                                  _tapedImageView.frame.size.width,
                                                  _tapedImageView.frame.size.height);
    
    switch (_tapedImageView.contentMode)
    {
        case UIViewContentModeScaleToFill:
            lFinalImageFrame = CGRectMake(0,
                                          0,
                                          lFinalImageContainerFrame.size.width,
                                          lFinalImageContainerFrame.size.height);
            break;
        case UIViewContentModeScaleAspectFit:
        {
            if (_tapedImageView.image.size.width >= _tapedImageView.image.size.height)
            {
                float lAlpha = lFinalImageContainerFrame.size.width / _tapedImageView.image.size.width;
                float lNewHeight = lAlpha * lFinalImageContainerFrame.size.height;
                lFinalImageFrame = CGRectMake(0,
                                              (lFinalImageContainerFrame.size.height - lNewHeight) / 2,
                                              lFinalImageContainerFrame.size.width,
                                              lNewHeight);
            }
            else
            {
                float lAlpha = lFinalImageContainerFrame.size.height / _tapedImageView.image.size.height;
                float lNewWidth = lAlpha * lFinalImageContainerFrame.size.width;
                lFinalImageFrame = CGRectMake((lFinalImageContainerFrame.size.width - lNewWidth) / 2,
                                              0,
                                              lNewWidth,
                                              lFinalImageContainerFrame.size.height);
            }
        }
            break;
        case UIViewContentModeScaleAspectFill:
        {
            if (_tapedImageView.image.size.width >= _tapedImageView.image.size.height)
            {
                float lAlpha = lFinalImageContainerFrame.size.height / _tapedImageView.image.size.height;
                float lNewWidth = lAlpha * _tapedImageView.image.size.width;
                lFinalImageFrame = CGRectMake((lFinalImageContainerFrame.size.width - lNewWidth) / 2,
                                              0,
                                              lNewWidth,
                                              lFinalImageContainerFrame.size.height);
                
                if (lFinalImageFrame.size.width < lFinalImageContainerFrame.size.width)
                {
                    float lAlpha = lFinalImageContainerFrame.size.width / _tapedImageView.image.size.width;
                    float lNewHeight = lAlpha * _tapedImageView.image.size.height;
                    lFinalImageFrame = CGRectMake(0,
                                                  (lFinalImageContainerFrame.size.height - lNewHeight) / 2,
                                                  lFinalImageContainerFrame.size.width,
                                                  lNewHeight);
                }
            }
            else
            {
                float lAlpha = lFinalImageContainerFrame.size.width / _tapedImageView.image.size.width;
                float lNewHeight = lAlpha * _tapedImageView.image.size.height;
                lFinalImageFrame = CGRectMake(0,
                                              (lFinalImageContainerFrame.size.height - lNewHeight) / 2,
                                              lFinalImageContainerFrame.size.width,
                                              lNewHeight);
                
                if (lFinalImageFrame.size.height < lFinalImageContainerFrame.size.height)
                {
                    float lAlpha = lFinalImageContainerFrame.size.width / _tapedImageView.image.size.width;
                    float lNewHeight = lAlpha * _tapedImageView.image.size.height;
                    lFinalImageFrame = CGRectMake(0,
                                                  (lFinalImageContainerFrame.size.height - lNewHeight) / 2,
                                                  lFinalImageContainerFrame.size.width,
                                                  lNewHeight);
                }
            }
        }
            break;
        case UIViewContentModeRedraw:
            lFinalImageFrame = CGRectZero;
            break;
        case UIViewContentModeCenter:
        {
            lFinalImageFrame = CGRectMake((lFinalImageContainerFrame.size.width - _tapedImageView.image.size.width) / 2,
                                          (lFinalImageContainerFrame.size.height - _tapedImageView.image.size.height) / 2,
                                          _tapedImageView.image.size.width,
                                          _tapedImageView.image.size.height);
        }
            break;
        case UIViewContentModeTop:
        {
            lFinalImageFrame = CGRectMake((lFinalImageContainerFrame.size.width - _tapedImageView.image.size.width) / 2,
                                          0,
                                          _tapedImageView.image.size.width,
                                          _tapedImageView.image.size.height);
        }
            break;
        case UIViewContentModeBottom:
        {
            lFinalImageFrame = CGRectMake((lFinalImageContainerFrame.size.width - _tapedImageView.image.size.width) / 2,
                                          lFinalImageContainerFrame.size.height - _tapedImageView.image.size.height,
                                          _tapedImageView.image.size.width,
                                          _tapedImageView.image.size.height);
        }
            break;
        case UIViewContentModeLeft:
        {
            lFinalImageFrame = CGRectMake(0,
                                          (lFinalImageContainerFrame.size.height - _tapedImageView.image.size.height) / 2,
                                          _tapedImageView.image.size.width,
                                          _tapedImageView.image.size.height);
        }
            break;
        case UIViewContentModeRight:
        {
            lFinalImageFrame = CGRectMake(lFinalImageContainerFrame.size.width - _tapedImageView.image.size.width,
                                          (lFinalImageContainerFrame.size.height - _tapedImageView.image.size.height) / 2,
                                          _tapedImageView.image.size.width,
                                          _tapedImageView.image.size.height);
        }
            break;
        case UIViewContentModeTopLeft:
        {
            lFinalImageFrame = CGRectMake(0,
                                          0,
                                          _tapedImageView.image.size.width,
                                          _tapedImageView.image.size.height);
        }
            break;
        case UIViewContentModeTopRight:
        {
            lFinalImageFrame = CGRectMake(lFinalImageContainerFrame.size.width - _tapedImageView.image.size.width,
                                          0,
                                          _tapedImageView.image.size.width,
                                          _tapedImageView.image.size.height);
        }
            break;
        case UIViewContentModeBottomLeft:
        {
            lFinalImageFrame = CGRectMake(0,
                                          lFinalImageContainerFrame.size.height - _tapedImageView.image.size.height,
                                          _tapedImageView.image.size.width,
                                          _tapedImageView.image.size.height);
        }
            break;
        case UIViewContentModeBottomRight:
        {
            lFinalImageFrame = CGRectMake(lFinalImageContainerFrame.size.width - _tapedImageView.image.size.width,
                                          lFinalImageContainerFrame.size.height - _tapedImageView.image.size.height,
                                          _tapedImageView.image.size.width,
                                          _tapedImageView.image.size.height);
        }
            break;
        default:
            break;
    }

    
    _scrollView.hidden = YES;
    
    
    [UIView animateWithDuration:0.35
                     animations:^
     {
         _imageContainer.frame = lFinalImageContainerFrame;
         _tapedImageViewCopy.frame = lFinalImageFrame;
         _backgroundBlackColor.alpha = 0.0f;
     }
                     completion:^(BOOL finished)
     {
         if (finished)
         {
             [_tapedImageViewCopy removeFromSuperview];
             _tapedImageView.hidden = NO;
             
             if (_closingBlock)
             {
                 _closingBlock();
             }
             
             [self dismissViewControllerAnimated:NO
                                      completion:nil];
         }
     }];
}


@end
