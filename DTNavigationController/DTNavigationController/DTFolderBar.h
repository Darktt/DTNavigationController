//
//  DTFolderBar.h
//  DTNavigationController
//
//  Created by Darktt on 13/4/26.
//  Copyright (c) 2013 Darktt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTFolderItem.h"

@interface DTFolderBar : UIView

@property (nonatomic, retain) NSArray *folderItems;
@property (nonatomic, retain) UIImage *backgroundImage;

+ (id)folderBarWithFrame:(CGRect)frame;

- (void)setFolderItems:(NSArray *)folderItems animated:(BOOL)animated;

@end
