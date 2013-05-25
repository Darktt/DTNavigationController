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
#import "DTFolderItem.h"

// Config file
#import "DTFolderConfig.h"

// View Tag
#define kBackgroundViewTag 2
#define kScrollViewTag 3
#define kFolderItemViewTag 4

// Button Type
//#define kButtonType UIButtonTypeRoundedRect
#define kButtonType UIButtonTypeCustom

typedef void (^DTAnimationsBlock) (void);
typedef void (^DTCompletionBlock) (BOOL finshed);

@interface DTFolderBar ()
{
    DTFolderBarStyle _style;
    NSMutableArray *_folderItems; // Saved folderItem array
    
    DTFolderItem *_leftItem;
    UIButton *_actionButton;
}

@end

@implementation DTFolderBar

#pragma mark - Initialize Class

+ (id)folderBarWithFrame:(CGRect)frame
{
    DTFolderBar *folderBar = [[[DTFolderBar alloc] initWithFrame:frame] autorelease];
    
    return folderBar;
}

+ (id)folderBarWithFrame:(CGRect)frame style:(DTFolderBarStyle)style
{
    DTFolderBar *folderBar = [[[DTFolderBar alloc] initWithFrame:frame style:style] autorelease];
    
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
    
    UIViewAutoresizing autoresizing = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    [backgroundView setImage:[UIImage imageNamed:kBarBlackgroundImage]];
    [backgroundView setTag:kBackgroundViewTag];
    [backgroundView setContentMode:UIViewContentModeScaleToFill];
    [backgroundView setAutoresizingMask:autoresizing];
    
    CGRect scrollViewFrame = self.bounds;
    
    if (_style == DTFolderBarStyleFixedLeftHome || _style == DTFolderBarStyleFixedHomeAndAtionButton) {
        scrollViewFrame.origin.x += 22.0f;
        scrollViewFrame.size.width -= 22.0f;
    }
    
    if (_style == DTFolderBarStyleActionButton || _style == DTFolderBarStyleFixedHomeAndAtionButton) {
        scrollViewFrame.size.width -= 44.0f;
        
        CGRect actionButtomFrame = self.bounds;
        actionButtomFrame.origin.x = scrollViewFrame.origin.x + scrollViewFrame.size.width - 2;
        actionButtomFrame.size = CGSizeMake(44, 44);
        
        UIButton *actionButton = [UIButton buttonWithType:kButtonType];
        [actionButton setBackgroundImage:[UIImage imageNamed:kActionButtonImage] forState:UIControlStateNormal];
        [actionButton setBackgroundImage:[UIImage imageNamed:kActionButtonPressImage] forState:UIControlStateHighlighted];
        [actionButton setFrame:actionButtomFrame];
        [actionButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
        
        _actionButton = actionButton;
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    [scrollView setTag:kScrollViewTag];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setContentOffset:CGPointMake(0, 0)];
    [scrollView setAutoresizingMask:autoresizing];
    
    CGRect folderItemViewFrame = self.bounds;
    folderItemViewFrame.size.width = 0;
    
    UIView *folderItemView = [[UIView alloc] initWithFrame:folderItemViewFrame];
    [folderItemView setBackgroundColor:[UIColor clearColor]];
    [folderItemView setClipsToBounds:YES];
    [folderItemView setTag:kFolderItemViewTag];
    [folderItemView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    
    [self addSubview:backgroundView];
    [self addSubview:scrollView];
    
    if (_actionButton != nil) {
        [self addSubview:_actionButton];
    }
    
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

#pragma mark - Add Folder Item Methods

- (void)setFolderItems:(NSArray *)folderItems
{
    [self setFolderItems:folderItems animated:NO];
}

- (void)setFolderItems:(NSArray *)folderItems animated:(BOOL)animated
{
    if (folderItems.count > _folderItems.count) {
        [_folderItems removeAllObjects];
        [_folderItems addObjectsFromArray:folderItems];
        
        DTFolderItem *folderItem = _folderItems.lastObject;
        [self addFolderItem:folderItem animated:animated];
    } else {
        NSMutableArray *removedItems = [NSMutableArray arrayWithArray:_folderItems];
        [removedItems removeObjectsInArray:folderItems];
        [removedItems enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(DTFolderItem *folderItem, NSUInteger idx, BOOL *stop){
            [self deleteFolderItem:folderItem animated:animated];
        }];
        
        [_folderItems removeAllObjects];
        [_folderItems addObjectsFromArray:folderItems];
    }
}

- (NSArray *)folderItems
{
    return _folderItems;
}

- (void)addFolderItem:(DTFolderItem *)folderItem animated:(BOOL)animated
{
    NSTimeInterval duration = animated ? kAddFolderDuration : 0.0f;
    
    UIView *folderItemView = (UIView *)[self viewWithTag:kFolderItemViewTag];
    CGRect folderItemViewFrame = folderItemView.frame;
    
    CGFloat nextItemPosition = folderItemViewFrame.size.width - 22.0f;
    folderItemViewFrame.size.width += folderItem.frame.size.width;
    
    if (nextItemPosition < 0.0f) {
        nextItemPosition = 0.0f;
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
    [scrollView setContentSize:CGSizeMake((folderItemViewWidth + 44.0f), 0)];
    
    if (folderItemViewWidth > scrollView.frame.size.width) {
        CGPoint offset = scrollView.contentOffset;
        offset.x = folderItemViewWidth - scrollView.frame.size.width + 44.0f;
        
        [scrollView setContentOffset:offset animated:YES];
    }
}

- (void)deleteFolderItem:(DTFolderItem *)folderItem animated:(BOOL)animated
{
    NSTimeInterval duration = animated ? kDeleteFolderDuration : 0.0f;
    
    UIView *folderItemView = (UIView *)[self viewWithTag:kFolderItemViewTag];
    CGRect folderItemViewFrame = folderItemView.frame;
    folderItemViewFrame.size.width -= ( folderItem.frame.size.width - 22.0f );
    
    UIScrollView *scrollView = (UIScrollView *)[self viewWithTag:kScrollViewTag];
    
    CGSize contenSize = scrollView.contentSize;
    contenSize.width = folderItemViewFrame.size.width + 44.0f;
    
    DTAnimationsBlock animations = ^{
        [folderItemView setFrame:folderItemViewFrame];
        [scrollView setContentSize:contenSize];
    };
    
    DTCompletionBlock completion = ^(BOOL finsh){
        [folderItem removeFromSuperview];
    };
    
    [UIView animateWithDuration:duration animations:animations completion:completion];
}

#pragma mark - Overwrite Methods
#pragma mark #Style

- (DTFolderBarStyle)style
{
    return _style;
}

#pragma mark #Background Image

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

#pragma mark #LeftItem

- (void)setLeftItem:(DTFolderItem *)leftItem
{
    if (_style == DTFolderBarStyleActionButton || _style == DTFolderBarStyleNormal) {
        NSString *style = nil;
        
        switch (_style) {
            case DTFolderBarStyleNormal:
                style = @"DTFolderBarStyleNormal";
                break;
                
            case DTFolderBarStyleActionButton:
                style = @"DTFolderBarStyleActionButton";
                break;
                
            default:
                break;
        }
        
        [NSException raise:NSInvalidArgumentException format:@"Style error, you style is %@", style];
        
        return;
    }
    
    if (_leftItem != nil) {
        [_leftItem removeFromSuperview];
        _leftItem = nil;
    }
    
    CGRect leftItemFrame = leftItem.frame;
    leftItemFrame.origin = CGPointMake(0, 0);
    
    [leftItem setFrame:leftItemFrame];
    
    _leftItem = [leftItem retain];
    [self addSubview:_leftItem];
}

- (DTFolderItem *)leftItem
{
    return _leftItem;
}

#pragma mark #ActionButton

- (UIButton *)actionButton
{
    return _actionButton;
}

@end
