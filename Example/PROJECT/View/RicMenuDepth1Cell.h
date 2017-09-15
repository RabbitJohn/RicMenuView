//
//  RicMenuDepth1Cell.h
//  RicMenu
//
//  Created by john on 16/5/31.
//
//

#import <UIKit/UIKit.h>

#import "RicMenuItemCellDelegate.h"

@interface RicMenuDepth1Cell : UITableViewCell<RicMenuItemCellDelegate>

@property (nonatomic, readonly) RicMenuItem *menuItem;

- (void)updateMenuItem:(RicMenuItem *)menuItem;

@end
