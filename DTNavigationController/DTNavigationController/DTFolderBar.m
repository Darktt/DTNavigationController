//
//  DTFolderBar.m
//
// Copyright (c) 2013 Darktt
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "DTFolderBar.h"

#define kBackgroundViewTag 2
#define kScrollViewTag 3
#define kFolderItemViewTag 4

// Animation Duration
#define kAddFolderDuration 0.2f
#define kDeleteFolderDuration 0.2f

typedef void (^DTAnimationsBlock) (void);
typedef void (^DTCompletionBlock) (BOOL finshed);

@interface DTFolderBar ()
{
    DTFolderBarStyle _style;
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

+ (id)folderBarWithFrame:(CGRect)frame style:(DTFolderBarStyle)style
{
    DTFolderBar *folderBar = [[[DTFolderBar alloc] initWithFrame:frame] autorelease];
    
    return folderBar;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame style:DTFolderBarStyleNormal];
}

- (id)initWithFrame:(CGRect)frame style:(DTFolderBarStyle)style
{
    self = [super initWithFrame:frame];
    if (self == nil) return nil;
    
    [self setClipsToBounds:YES];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _style = style;
    _folderItems = [NSMutableArray new];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    [backgroundView setTag:kBackgroundViewTag];
    [backgroundView setContentMode:UIViewContentModeScaleToFill];
    [backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [scrollView setTag:kScrollViewTag];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setContentOffset:CGPointMake(0, 0)];
    [scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    UIView *folderItemView = [[UIView alloc] initWithFrame:self.bounds];
    [folderItemView setBackgroundColor:[UIColor clearColor]];
    [folderItemView setClipsToBounds:YES];
    [folderItemView setTag:kFolderItemViewTag];
    
    [self addSubview:backgroundView];
    [self addSubview:scrollView];
    
    [scrollView addSubview:folderItemView];
    
    [backgroundView release];
    [scrollView release];
    [folderItemView release];
    
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
    if (folderItems.count > _folderItems.count) {
        [self removeFolderItemsFromSuperview];
        
        [_folderItems removeAllObjects];
        [_folderItems addObjectsFromArray:folderItems];
        
        nextItemPosition = 0.0f;
        
        for (DTFolderItem *folderItem in _folderItems) {
            [self addFolderItem:folderItem animated:animated];
            nextItemPosition += (folderItem.frame.size.width - 22);
        }
    } else {
        NSMutableArray *removedItems = [NSMutableArray arrayWithArray:_folderItems];
        [removedItems removeObjectsInArray:folderItems];
        [removedItems enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(DTFolderItem *folderItem, NSUInteger idx, BOOL *stop){
            [self deleteFolderItem:folderItem animated:YES];
        }];
        
        [_folderItems removeAllObjects];
        [_folderItems addObjectsFromArray:folderItems];
    }
}

- (NSArray *)folderItems
{
    return _folderItems;
}

- (void)removeFolderItemsFromSuperview
{
//    UIScrollView *scrolView = (UIScrollView *)[self viewWithTag:kScrollViewTag];
    UIView *folderItemView = (UIView *)[self viewWithTag:kFolderItemViewTag];
    
    for (DTFolderItem *folderItem in folderItemView.subviews) {
        if ([folderItem isKindOfClass:[DTFolderItem class]]) {
            [folderItem removeFromSuperview];
        }
    }
}

- (void)addFolderItem:(DTFolderItem *)folderItem animated:(BOOL)animated
{
    BOOL scrollAnimated = animated;
    NSTimeInterval duration = animated ? kAddFolderDuration : 0.0f;
    
    UIView *folderItemView = (UIView *)[self viewWithTag:kFolderItemViewTag];
    CGRect folderItemViewFrame = folderItemView.frame;
    
    if (folderItem != [_folderItems lastObject]) {
        scrollAnimated = NO;
    }
    
    CGRect folderItemFrame = folderItem.frame;
    folderItemFrame.origin.x = nextItemPosition;
    
    [folderItem setFrame:folderItemFrame];
    
    CGFloat folderItemViewWidth = nextItemPosition + folderItemFrame.size.width;
    folderItemViewFrame.size.width = folderItemViewWidth;
    
    DTAnimationsBlock animations = ^{
        [folderItemView insertSubview:folderItem atIndex:0];
        [folderItemView setFrame:folderItemViewFrame];
    };
    
    [UIView animateWithDuration:duration animations:animations];
    
    UIScrollView *scrollView = (UIScrollView *)[self viewWithTag:kScrollViewTag];
    [scrollView setContentSize:CGSizeMake((folderItemViewWidth + 44), 0)];
    
    if (folderItemViewWidth > scrollView.frame.size.width) {
        CGPoint offset = scrollView.contentOffset;
        offset.x = folderItemViewWidth - scrollView.frame.size.width + 44;
        
        [scrollView setContentOffset:offset animated:scrollAnimated];
    }
}

- (void)deleteFolderItem:(DTFolderItem *)folderItem animated:(BOOL)animated
{
    NSTimeInterval duration = animated ? kDeleteFolderDuration : 0.0f;
    
    UIView *folderItemView = (UIView *)[self viewWithTag:kFolderItemViewTag];
    CGRect folderItemViewFrame = folderItemView.frame;
    folderItemViewFrame.size.width -= ( folderItem.frame.size.width - 22 );
    
    UIScrollView *scrollView = (UIScrollView *)[self viewWithTag:kScrollViewTag];
    
    CGSize contenSize = scrollView.contentSize;
    contenSize.width = folderItemViewFrame.size.width + 44;
    
    DTAnimationsBlock animations = ^{
        [folderItemView setFrame:folderItemViewFrame];
        [scrollView setContentSize:contenSize];
    };
    
    DTCompletionBlock completion = ^(BOOL finsh){
        [folderItem removeFromSuperview];
    };
    
    [UIView animateWithDuration:duration animations:animations completion:completion];
}

#pragma mark - Overwrite methods
#pragma mark Background image methods

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
