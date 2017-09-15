//
//  RicMenuDepth2Cell.h
//  RicMenuView
//
//  Created by john on 2017/7/23.
//
//

#import <UIKit/UIKit.h>
#import "RicMenuItemCellDelegate.h"

@interface RicMenuDepth2Cell : UITableViewCell<RicMenuItemCellDelegate>

@property (nonatomic, readonly) RicMenuItem *menuItem;

- (void)updateMenuItem:(RicMenuItem *)menuItem;

@end
