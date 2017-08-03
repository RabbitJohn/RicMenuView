//
//  RicMenuController.h
//  Ric
//
//  Created by 张礼焕 on 16/5/31.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RicMenuItemCellDelegate.h"
#import "RicMenuItem.h"

@protocol RicMenuControllerDelegate <NSObject>

@optional

- (void)didSelectedFilterData:(RicMenuItem *)data;
- (void)configureCellActionsForCell:(UITableViewCell *)cell;
@end
// configure this controller in the RicMenuView's delegate
@interface RicMenuController : UIViewController

/**
 这个类必须要遵守 RicMenuItemCellDelegate 协议
 当前controller展示的列表里面的cell类
 */
@property (nonatomic, strong) Class tableViewCellClass;
/**
 */
@property (nonatomic, copy) CGFloat(^heightForRowAtIndexPath)(NSInteger depth,NSIndexPath *indexPath,RicMenuItem *filterModel);
@property (nonatomic, strong) RicMenuItem *menuItem;


@property (nonatomic, readonly,weak) id <RicMenuControllerDelegate> delegate;
/**
  设置tableView
 */
@property (nonatomic, readonly) UITableView *tableView;
/**
   数据源包含子节点的一个根节点
 */
@property (nonatomic, readonly) RicMenuItem *selectedSubItem;

/**
   强制刷新数据
 */
- (void)refreshData;

- (instancetype)initWithDelegate:(id<RicMenuControllerDelegate>)delegate;

@end
