//
//  RicMenuItemCellDelegate.h
//  Ric
//
//  Created by 张礼焕 on 16/5/31.
//
//

#ifndef RicMenuItemCellDelegate_h
#define RicMenuItemCellDelegate_h

#import "RicMenuItem.h"

@protocol RicMenuItemCellDelegate <NSObject>

@required

@property (nonatomic, readonly) RicMenuItem *filterModel;

- (void)setFilterModel:(RicMenuItem *)filterModel;

@end


#endif /* RicMenuItemCellDelegate_h */
