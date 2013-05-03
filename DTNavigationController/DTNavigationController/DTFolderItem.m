//
//  DTFolderItem.m
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

#import "DTFolderItem.h"

#define kBackgroundImage @"FolderItemBgImage.png"
#define kBackgroundHighlightedImage @""

#define kBackgroundImageViewTag 1
#define kTitleLabelTag          2
#define kIconImageViewTag       3

@interface DTFolderItem ()
{
    id      _targer;
    SEL     _action;
    CGRect  _frame;
}

@end

@implementation DTFolderItem

+ (id)itemWithFolderName:(NSString *)folderName targer:(id)targer action:(SEL)action
{
    DTFolderItem *folderItem = [[[DTFolderItem alloc] initWithFolderName:folderName targer:targer action:action] autorelease];
    
    return folderItem;
}

+ (id)itemWithImage:(UIImage *)iconImage targer:(id)targer action:(SEL)action
{
    DTFolderItem *folderItem = [[[DTFolderItem alloc] initWithImage:iconImage targer:targer action:action] autorelease];
    
    return folderItem;
}

- (id)initWithFolderName:(NSString *)folderName targer:(id)targer action:(SEL)action
{
    CGFloat fontSize = [UIFont systemFontSize];
    CGFloat width = folderName.length * fontSize - 10;
    CGFloat height = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? 32 : 44;
    
    self = [super initWithFrame:CGRectMake(0, 0, width, height)];
    
    if (self == nil) return nil;
    [self setUserInteractionEnabled:YES];
    
    _targer = targer;
    _action = action;
    
    [self setViewWithFolderName:folderName];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapItem:)];
    
    [self addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    return self;
}

- (id)initWithImage:(UIImage *)iconImage targer:(id)targer action:(SEL)action
{
    CGFloat width = iconImage.size.width + 22;
    CGFloat height = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? 32 : 44;
    
    self = [super initWithFrame:CGRectMake(0, 0, width, height)];
    
    if (self == nil) return nil;
    [self setUserInteractionEnabled:YES];
    
    _targer = targer;
    _action = action;
    
    [self setViewWithImage:iconImage];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapItem:)];
    
    [self addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    return self;
}

- (void)dealloc
{
    
    [super dealloc];
}

#pragma mark - Set Subvies

- (void)setViewWithFolderName:(NSString *)folderName
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(22, 1, 22, 44);
    UIImage *bgImage = [[UIImage imageNamed:kBackgroundImage] resizableImageWithCapInsets:edgeInsets];
    UIImage *bgHighlightedImage = [[UIImage imageNamed:kBackgroundHighlightedImage] resizableImageWithCapInsets:edgeInsets];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:bgImage highlightedImage:bgHighlightedImage];
    [backgroundImageView setFrame:self.frame];
    [backgroundImageView setTag:kBackgroundImageViewTag];
    [backgroundImageView setContentMode:UIViewContentModeScaleToFill];
    [backgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setText:folderName];
    [titleLabel sizeToFit];
    [titleLabel setCenter:self.center];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTag:kTitleLabelTag];
    [titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    
    [self addSubview:backgroundImageView];
    [self addSubview:titleLabel];
    
    [backgroundImageView release];
    [titleLabel release];
    
    [self sizeToFit];
}

- (void)setViewWithImage:(UIImage *)iconImage
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(22, 1, 22, 44);
    UIImage *bgImage = [[UIImage imageNamed:kBackgroundImage] resizableImageWithCapInsets:edgeInsets];
    UIImage *bgHighlightedImage = [[UIImage imageNamed:kBackgroundHighlightedImage] resizableImageWithCapInsets:edgeInsets];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:bgImage highlightedImage:bgHighlightedImage];
    [backgroundImageView setFrame:self.frame];
    [backgroundImageView setTag:kBackgroundImageViewTag];
    [backgroundImageView setContentMode:UIViewContentModeScaleToFill];
    [backgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:iconImage];
    [iconImageView sizeToFit];
    [iconImageView setCenter:CGPointMake(self.center.x - 5, self.center.y)];
    [iconImageView setTag:kIconImageViewTag];
    [iconImageView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    
    [self addSubview:backgroundImageView];
    [self addSubview:iconImageView];
    
    [backgroundImageView release];
    [iconImageView release];
}

#pragma mark - Gesture recognizer method

- (IBAction)tapItem:(UITapGestureRecognizer *)sender
{
    [[UIApplication sharedApplication] sendAction:_action to:_targer from:self forEvent:nil];
}

#pragma mark - Overwrite Methods
#pragma mark #Hightlighted

- (void)setHightlighted:(BOOL)hightlighted
{
    UIImageView *backgroundImageView = (UIImageView *)[self viewWithTag:kBackgroundImageViewTag];
    
    [backgroundImageView setHighlighted:hightlighted];
}

- (BOOL)isHightlighted
{
    UIImageView *backgroundImageView = (UIImageView *)[self viewWithTag:kBackgroundImageViewTag];
    
    return backgroundImageView.highlighted;
}

#pragma mark #Title

- (NSString *)title
{
    UILabel *titleLabel = (UILabel *)[self viewWithTag:kTitleLabelTag];
    
    return titleLabel.text;
}

#pragma mark #BackgroundImage

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    UIImageView *backgroundImageView = (UIImageView *)[self viewWithTag:kBackgroundImageViewTag];
    [backgroundImageView setImage:backgroundImage];
}

- (UIImage *)backgroundImage
{
    UIImageView *backgroundImageView = (UIImageView *)[self viewWithTag:kBackgroundImageViewTag];
    
    return backgroundImageView.image;
}

#pragma mark #HighlightedImage

- (void)setHighlightedImage:(UIImage *)highlightedImage
{
    UIImageView *backgroundImageView = (UIImageView *)[self viewWithTag:kBackgroundImageViewTag];
    [backgroundImageView setHighlightedImage:highlightedImage];
}

- (UIImage *)highlightedImage
{
    UIImageView *backgroundImageView = (UIImageView *)[self viewWithTag:kBackgroundImageViewTag];
    
    return backgroundImageView.highlightedImage;
}

#pragma mark #BackgroundImage and highlightedImage

- (void)setBackgroundImage:(UIImage *)backgroundImage highlightedImage:(UIImage *)highlightedImage
{
    UIImageView *backgroundImageView = (UIImageView *)[self viewWithTag:kBackgroundImageViewTag];
    [backgroundImageView setImage:backgroundImage];
    [backgroundImageView setHighlightedImage:highlightedImage];
}

@end
