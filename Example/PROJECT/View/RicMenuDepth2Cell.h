//
//  RicMenuDepth2Cell.h
//  RicMenuView
//
//  Created by 张礼焕 on 2017/7/23.
//
//

#import <UIKit/UIKit.h>
#import "RicMenuItemCellDelegate.h"

@interface RicMenuDepth2Cell : UITableViewCell<RicMenuItemDelegate>

@property (nonatomic, readonly) RicMenuItem *filterModel;

- (void)setFilterModel:(RicMenuItem *)filterModel;

@end
