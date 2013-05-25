//
//  DTFolderItem.h
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

#import <UIKit/UIKit.h>

@interface DTFolderItem : UIView

@property (nonatomic, retain) UIImage *backgroundImage;
@property (nonatomic, retain) UIImage *highlightedImage;
@property (nonatomic, getter = isHightlighted) BOOL hightlighted;
@property (nonatomic, readonly) NSString *title; // nil at use image
@property (nonatomic, readonly) UILabel *textLable; // nil at use image

+ (id)itemWithFolderName:(NSString *)folderName targer:(id)targer action:(SEL)action;
+ (id)itemWithImage:(UIImage *)iconImage targer:(id)targer action:(SEL)action;

- (id)initWithFolderName:(NSString *)folderName targer:(id)targer action:(SEL)action;
- (id)initWithImage:(UIImage *)iconImage targer:(id)targer action:(SEL)action;

- (void)setBackgroundImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage;

@end
