//
//  RicBaseFilterViewController.h
//  RicMenuView
//
//  Created by 张礼焕 on 2017/7/20.
//
//

#import <UIKit/UIKit.h>

#define RicBaseFilterViewContentBounds CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-150)

@interface RicBaseFilterViewController : UIViewController

- (void)getResult;

@end
