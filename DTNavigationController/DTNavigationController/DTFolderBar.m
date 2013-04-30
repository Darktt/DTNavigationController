//
//  DTFolderBar.m
//  DTNavigationController
//
//  Created by Darktt on 13/4/26.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import "DTFolderBar.h"

#define kBackgroundViewTag 2
#define kScrolViewTag 3

@interface DTFolderBar () <UIScrollViewDelegate>
{
    NSMutableArray *_folderItems; // Saved folderItem array
    CGFloat nextItemPosition;
}

@end

@implementation DTFolderBar

+ (id)folderBarWithFrame:(CGRect)frame
{
    DTFolderBar *folderBar = [[[DTFolderBar alloc] initWithFrame:frame] autorelease];
    
    return folderBar;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil) return nil;
    
    [self setClipsToBounds:YES];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _folderItems = [NSMutableArray new];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    [backgroundView setTag:kBackgroundViewTag];
    [backgroundView setContentMode:UIViewContentModeScaleToFill];
    [backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [scrollView setTag:kScrolViewTag];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setContentOffset:CGPointMake(0, 0)];
    [scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    [scrollView setDelegate:self];
    
    [self addSubview:backgroundView];
    [self addSubview:scrollView];
    
    [backgroundView release];
    [scrollView release];
    
    return self;
}

- (void)dealloc
{
    [_folderItems release];
    
    [super dealloc];
}

#pragma mark - Add folder item methods

- (void)setFolderItems:(NSArray *)folderItems
{
    [self setFolderItems:folderItems animated:NO];
}

- (void)setFolderItems:(NSArray *)folderItems animated:(BOOL)animated
{
    [self removeFolderItemsFromSuperview];
    
    [_folderItems removeAllObjects];
    [_folderItems addObjectsFromArray:folderItems];
    
    nextItemPosition = 0.0f;
    
    for (DTFolderItem *folderItem in _folderItems) {
        [self addFolderItem:folderItem animated:animated];
        nextItemPosition += (folderItem.frame.size.width - 22);
    }
}

- (NSArray *)folderItems
{
    return _folderItems;
}

- (void)removeFolderItemsFromSuperview
{
    UIScrollView *scrolView = (UIScrollView *)[self viewWithTag:kScrolViewTag];
    
    for (DTFolderItem *folderItem in scrolView.subviews) {
        if ([folderItem isKindOfClass:[DTFolderItem class]]) {
            [folderItem removeFromSuperview];
        }
    }
}

- (void)addFolderItem:(DTFolderItem *)folderItem animated:(BOOL)animated
{
    CGRect folderItemFrame = folderItem.frame;
    folderItemFrame.origin.x = nextItemPosition;
    
    [folderItem setFrame:folderItemFrame];
    
    UIScrollView *scrollView = (UIScrollView *)[self viewWithTag:kScrolViewTag];
    [scrollView setContentSize:CGSizeMake((nextItemPosition + folderItemFrame.size.width + 44), 0)];
    [scrollView insertSubview:folderItem atIndex:0];
    
    BOOL scrollAnimated = animated;
    
    if (folderItem != [_folderItems lastObject]) {
        scrollAnimated = NO;
    }
    
    CGFloat offsetX = nextItemPosition + folderItemFrame.size.width;
    
    if (offsetX > scrollView.frame.size.width) {
        CGPoint offset = scrollView.contentOffset;
        offset.x = offsetX - scrollView.frame.size.width;
        
        [scrollView setContentOffset:offset animated:scrollAnimated];
    }
    
    /*
    if (animated) {
        void (^animations) (void) = ^(void){ NSLog(@"Animation"); };
        
        void (^completion) (BOOL finished) = ^(BOOL finished){ NSLog(@"Completion"); };
        
        [UIView animateWithDuration:kAddFolderItemAnimateDuration animations:animations completion:completion];
        return;
    } */
}

#pragma mark - Overwrite methods

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    UIImageView *backgroundView = (UIImageView *)[self viewWithTag:kBackgroundViewTag];
    [backgroundView setImage:backgroundImage];
}

- (UIImage *)backgroundImage
{
    UIImageView *backgroundView = (UIImageView *)[self viewWithTag:kBackgroundViewTag];
    return backgroundView.image;
}

@end
