//
//  RicModel.h
//  john
//
//  Created by john on 16/5/30.
//  Copyright © 2016年 john. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RicMenuItem;

/**
   数据源要实现以下几个方法
*/
@protocol RicMenuModelDataSource <NSObject>

@required

@property (nonatomic, readonly) NSString *tag;

/**
  显示的标题
 */
@property (nonatomic, readonly) NSString *title;
/**
  子节点数据
 */
@property (nonatomic, readonly) NSArray <id<RicMenuModelDataSource>>*subMenuItems;

@property (nonatomic, readonly) BOOL isDefaultValue;

// 这个方法会用来判断两个选项是不是同一个选项，用于构建默认筛选项的时候的判断
- (BOOL)isEqual:(id<RicMenuModelDataSource>)object;

@optional

@property (nonatomic, readonly) NSString *parentName;

- (void)setParentName:(NSString *)parentName;

@end
// 某个节点是否允许对子节点的多选
@protocol RicMenuItemDelegate <NSObject>

@optional
// 是否支持多选
- (BOOL)supportMutiSelectionForItem:(RicMenuItem *)item;
// 多选限制
- (NSInteger)maxSelectionCountForDepth:(NSInteger)depth parentItem:(RicMenuItem *)parentItem;
// 多选限制的提示
- (BOOL)filterViewShouldSelectedItem:(RicMenuItem *)item leftSelectCount:(NSInteger)leftCount;

@end


/// 筛选模型
@interface RicMenuItem : NSObject

////用于显示
/**
 标题
 */
@property (nonatomic, copy, readonly) NSString *title;
/**
 是否选中(根据这个状态显示页面的ui)
 */
@property (nonatomic, assign, readonly) BOOL isSelected;
/////
/**
   区别不同的分类筛选的类型, not assagined value yet
 */
@property (nonatomic, copy, readonly) NSString *tag;
/////结构
/**
   父节点
 */
@property (nonatomic, readonly, weak) RicMenuItem *parent;

/**
   根节点
 */
@property (nonatomic, weak, readonly) RicMenuItem *root;
/**
   是否是叶子节点
 */
@property (nonatomic, assign, readonly) BOOL isLeaf;
/**
   子节点
 */
@property (nonatomic, strong, readonly) NSArray <RicMenuItem *>*subMenuItems;
/**
  原数据
 */
@property (nonatomic, strong, readonly) id<RicMenuModelDataSource>itemValue;
/**
  是否有子项被选中
 */
@property (nonatomic, assign, readonly) BOOL hasSubMenuSelected;
/**
   子节点是否全是叶子节点
 */
@property (nonatomic, assign, readonly) BOOL allSubMenusAreLeaves;
/**
   所在的层次,从0开始,第1栏的值为1（0所代表的depth不显示，因为root节点只有一个）显示从depth为1开始
 */
@property (nonatomic, assign, readonly) NSInteger depth;

/**
  最深的节点
 */
@property (nonatomic, assign, readonly) NSInteger deepestDepth;
/**
   做配置的代理
 */
@property (nonatomic, weak, readonly) id<RicMenuItemDelegate>delegate;
/**
   是否支持对子菜单的多选
 */
@property (nonatomic, assign, readonly) BOOL supportMutiChildrenSelected;

/**
 所有选中的子节点
 */
@property (nonatomic, strong, readonly) NSArray <RicMenuItem *> *allSelectedSubItems;
/**
   当前节点的所有叶子节点
 */
@property (nonatomic, strong, readonly) NSArray <RicMenuItem *> *allLeaves;
/**
  所有选中的叶子节点
 */
@property (nonatomic, strong, readonly) NSArray <RicMenuItem *> *allSelectedLeaves;
/**
   初始化
 */
- (instancetype)initWithDelegate:(id<RicMenuItemDelegate>)delegate oriData:(id<RicMenuModelDataSource>)oriData defaultSelections:(NSArray <id<RicMenuModelDataSource>>*)defaultSelections;

/**
 设置选中状态
 */
- (void)updateSelected:(BOOL)isSelected;

/**
 清空不包含在items的叶子节点的选中状态
 */
- (void)clearSelectedStatusExclude:(NSArray<RicMenuItem*> *)items;

/**
 清空当前选中状态
 */
- (void)clearSelectedStatus;

/**
  清空所有叶子节点的选中状态
 */
- (void)clearAllSelectedStatus;

@end
