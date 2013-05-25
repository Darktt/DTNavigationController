//
//  DTFolderBar.h
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
#import "DTFolderStyle.h"

@class DTFolderItem;


@interface DTFolderBar : UIView

@property (nonatomic, assign ,readonly) DTFolderBarStyle style;
@property (nonatomic, retain) NSArray *folderItems;     // DTFolderItems in DTFolderBar.
@property (nonatomic, retain) UIImage *backgroundImage; // Defaul is nil.
@property (nonatomic, readonly) UIButton *actionButton; // nil at DTFolderBarStyleNormal & DTFolderBarStyleFixedHome style.
@property (nonatomic, retain) DTFolderItem *leftItem;   // Must set folderItem at DTFolderBarStyleFixedLeftHome and DTFolderBarStyleFixedAll style.

+ (id)folderBarWithFrame:(CGRect)frame;
+ (id)folderBarWithFrame:(CGRect)frame style:(DTFolderBarStyle)style;

- (void)setFolderItems:(NSArray *)folderItems animated:(BOOL)animated;

@end
