//
//  RicMenuItemCellDelegate.h
//  john
//
//  Created by john on 16/5/31.
//
//

#ifndef RicMenuItemCellDelegate_h
#define RicMenuItemCellDelegate_h

#import "RicMenuItem.h"

@protocol RicMenuItemCellDelegate <NSObject>

@required

@property (nonatomic, readonly) RicMenuItem *menuItem;

- (void)updateMenuItem:(RicMenuItem *)menuItem;

@end


#endif /* RicMenuItemCellDelegate_h */
