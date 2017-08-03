//
//  RicMenuView.h
//  rice
//
//  Created by 张礼焕 on 16/5/30.
//  Copyright © 2016年 rice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RicMenuItem.h"
#import "RicMenuController.h"

@protocol RicMenuDelegate <NSObject>

@optional

// 配置tableView的样式，不要在这里设置tableView的delegate和tableView的dataSource.
// depth 目录所在的深度（是这个目录的父节点的深度+1）
- (void)configTableViewAtDepth:(NSInteger)depth tableView:(UITableView *)tableView;

// for cell actions. also if you use the mvvm pattern. you could configure the actions in the viewModel of your cell instead implementing this method
- (void)configureActionsForCell:(UITableViewCell *)cell;
@required
// 返回一个偏移量给tableView
// depth:某个目录的父节点深度
- (CGFloat)widthOfTableViewOfMenu:(RicMenuItem *)menu;
// 这个代理方法需要配置 filterController的 heightForRowAtIndexPath 和 tableViewCellClass 两个属性
// depth:某个目录的父节点深度
// controller:某个目录父节点的MenuController
- (void)configControllerOfMenu:(RicMenuItem *)menu controller:(RicMenuController *)controller;
// 点击某个菜单选项
- (void)filterMenuDidClickedItem:(RicMenuItem *)item;

@end

//// 暂时支持现有功能。
@interface RicMenuView : UIView

@property (nonatomic,readonly,weak) id <RicMenuDelegate> delegate;

// 根节点数据源
@property (nonatomic, readonly,strong) RicMenuItem *rootData;
/**
   筛选结果
 */
@property (nonatomic, readonly) NSArray <id<RicMenuModelDataSource>> *filteredResult;
/**
   数据源
 */
- (void)setDelegate:(id <RicMenuDelegate>)delegate rootData:(RicMenuItem *)rootData;
/**
  重新加载数据
 */
- (void)reloadAll;

@end
