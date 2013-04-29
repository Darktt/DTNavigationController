//
//  DTFolderItem.h
//
//  Created by Darktt on 13/4/29.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTFolderItem : UIView

@property (nonatomic,retain) UIImage *backgroundImage;
@property (nonatomic,retain) UIImage *highlightedImage;
@property (nonatomic, getter = isHightlighted) BOOL hightlighted;
@property (nonatomic, readonly) NSString *title;

+ (id)itemWithFolderName:(NSString *)folderName targer:(id)targer action:(SEL)action;
+ (id)itemWithImage:(UIImage *)iconImage targer:(id)targer action:(SEL)action;

- (id)initWithFolderName:(NSString *)folderName targer:(id)targer action:(SEL)action;
- (id)initWithImage:(UIImage *)iconImage targer:(id)targer action:(SEL)action;

- (void)setBackgroundImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage;

@end
