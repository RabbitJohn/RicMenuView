//
//  RicMenuCell.h
//  RicMenu
//
//  Created by john on 16/5/31.
//
//

#import <UIKit/UIKit.h>
#import "RicMenuItemCellDelegate.h"

@interface RicMenuDepth0Cell : UITableViewCell<RicMenuItemCellDelegate>

@property (nonatomic, readonly) RicMenuItem *menuItem;

- (void)updateMenuItem:(RicMenuItem *)menuItem;

@end
