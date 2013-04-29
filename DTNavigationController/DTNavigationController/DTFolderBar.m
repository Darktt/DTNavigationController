//
//  DTFolderBar.m
//  DTNavigationController
//
//  Created by Darktt on 13/4/26.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import "DTFolderBar.h"

#define kBackgroundViewTag 2
#define kAddFolderItemAnimateDuration 3

@interface DTFolderBar ()
{
    NSMutableArray *_folderItems; // Saved folderItem array
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
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _folderItems = [NSMutableArray new];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:frame];
    [backgroundView setTag:kBackgroundViewTag];
    [backgroundView setContentMode:UIViewContentModeScaleAspectFit];
    
    [self addSubview:backgroundView];
    
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
    
    for (DTFolderItem *folderItem in _folderItems) {
        [self addFolderItem:folderItem animated:animated];
    }
}

- (NSArray *)folderItems
{
    return _folderItems;
}

- (void)removeFolderItemsFromSuperview
{
    for (DTFolderItem *folderItem in self.subviews) {
        if ([folderItem isKindOfClass:[DTFolderItem class]]) {
            [folderItem removeFromSuperview];
        }
    }
}

- (void)addFolderItem:(DTFolderItem *)folderItem animated:(BOOL)animated
{
//    CGRect folderItemFrame = folderItem.frame;
//    CGPoint folderItemPosition = CGPointZero;
    
    [self insertSubview:folderItem atIndex:0];
    
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
