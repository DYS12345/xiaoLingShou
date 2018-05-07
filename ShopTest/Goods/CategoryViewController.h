//
//  CategoryViewController.h
//  ShopTest
//
//  Created by dong on 2017/9/1.
//  Copyright © 2017年 dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryViewControllerDelegate <NSObject>

-(void)selectedTagId:(NSString*)tagId;

@end

@interface CategoryViewController : UIViewController

@property (nonatomic, strong) NSArray *modelAry;
@property (nonatomic, copy) NSString *selectedTag;
@property (nonatomic, weak) id<CategoryViewControllerDelegate> delegate;

@end
