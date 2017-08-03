//
//  RicMenuView.m
//  rice
//
//  Created by 张礼焕 on 16/5/30.
//  Copyright © 2016年 rice. All rights reserved.
//

#import "RicMenuView.h"

@interface RicMenuView ()<RicMenuControllerDelegate>

// tableView中的索引代表tableView对应的层级depth.
@property (nonatomic, strong) NSMutableArray <RicMenuController *>*tableViewControllers;


@property (nonatomic, weak) id <RicMenuDelegate> delegate;
@property (nonatomic, strong) RicMenuItem *rootData;

- (void)setUpSubViews;

@end

@implementation RicMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
       [self setUpSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews
{
    self.tableViewControllers = [NSMutableArray new];
}

- (void)setRootData:(RicMenuItem *)rootData{
    
    _rootData = rootData;
   RicMenuController *controller = [self addTableViewForMenuNode:_rootData];
    [self checkoutDefaultsForController:controller];
}

- (void)checkoutDefaultsForController:(RicMenuController *)controller
{
    if(controller.menuItem.hasSubMenuSelected && controller.menuItem.subMenuItems.count > 0){
        
        __block RicMenuItem *subItem = [controller.menuItem.subMenuItems firstObject];
        __block NSInteger index = 0;

        [controller.menuItem.subMenuItems enumerateObjectsUsingBlock:^(RicMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj.isSelected){
                subItem = obj;
                index = obj.isSelected && index==0 ? idx:index;
                *stop = YES;
            }
        }];
        if(!subItem.isSelected){
            subItem.isSelected = YES;
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        if([controller.tableView visibleCells].count > 0){
            [controller.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
        }
        if(!subItem.isLeaf){
            RicMenuController *subController = [self addTableViewForMenuNode:subItem];
            [self checkoutDefaultsForController:subController];
        }
    }
}

- (void)setDelegate:(id <RicMenuDelegate>)delegate rootData:(RicMenuItem *)rootData{
    // 先设置delegate后设置rootData,因为设置rootData的时候会refreshData.
    self.delegate = delegate;
    self.rootData = rootData;
}

- (RicMenuController *)addTableViewForMenuNode:(RicMenuItem *)menuNode
{
    RicMenuController *filterController = nil;
    if(menuNode.depth < self.tableViewControllers.count){
        filterController = self.tableViewControllers[menuNode.depth];
        filterController.menuItem = menuNode;
        filterController.tableView.hidden = NO;
        [self autoSizeOrHideTableViewsOfController:filterController];
        [filterController refreshData];
        return filterController;
    }
    
    filterController = [[RicMenuController alloc] initWithDelegate:self];
    if(self.delegate && [self.delegate respondsToSelector:@selector(configControllerOfMenu:controller:)]){
        
        filterController.menuItem = menuNode;
        [filterController setValue:self forKey:@"delegate"];

        [self.delegate configControllerOfMenu:menuNode controller:filterController];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(configTableViewAtDepth:tableView:)]){
            
            [self.delegate configTableViewAtDepth:menuNode.depth tableView:filterController.tableView];
        }
        [self addSubview:filterController.tableView];
        [self.tableViewControllers addObject:filterController];
        [self autoSizeOrHideTableViewsOfController:filterController];
        [filterController refreshData];
    }
 
    return filterController;
}
- (void)autoSizeOrHideTableViewsOfController:(RicMenuController *)controller{
    //
    NSInteger preControllerIndex = controller.menuItem.parent.depth;
    RicMenuController *preController = nil;
    if(preControllerIndex < self.tableViewControllers.count){
      preController = self.tableViewControllers[preControllerIndex];
    }
    CGFloat offset = preController ? CGRectGetMaxX(preController.tableView.frame)-1 : 0;
    
    CGFloat width = 0;
    if(self.delegate && [self.delegate respondsToSelector:@selector(widthOfTableViewOfMenu:)]){
        width = [self.delegate widthOfTableViewOfMenu:controller.menuItem];
    }
    RicMenuItem *nextItem = [controller.menuItem.subMenuItems firstObject];
    if(!nextItem || nextItem.isLeaf){
        width = CGRectGetWidth(self.bounds) - offset;
    }else{
        width = width+1;
    }
    controller.tableView.frame = CGRectMake(offset, 0,width, CGRectGetHeight(self.bounds));
    for(NSInteger i=0;i<self.tableViewControllers.count;i++){
        RicMenuController *sm = self.tableViewControllers[i];
        sm.tableView.hidden = i>= controller.menuItem.depth+1;
    }
}
- (void)autoScrollToSelectedItemsForItem:(RicMenuItem *)item controller:(RicMenuController *)controller
{
    if(item.hasSubMenuSelected && item.subMenuItems.count > 0){
        
        __block RicMenuItem *subItem = [item.subMenuItems firstObject];
        __block NSInteger index = 0;
        
        [item.subMenuItems enumerateObjectsUsingBlock:^(RicMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            subItem = obj;
            index = obj.isSelected && index==0 ? idx:index;
            *stop = obj.hasSubMenuSelected;
        }];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        
        [controller.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
}

// 选中某个depth中的某个item.
- (void)didSelectedFilterData:(RicMenuItem *)data{
    if(data && !data.isLeaf){
        // 已经不是叶子节点的情况
        // 增加一个tableView
        RicMenuItem *menu = data;
        while (menu.subMenuItems.count > 0) {
            [self addTableViewForMenuNode:menu];
            menu = [menu.allSelectedSubItems firstObject] ? : [menu.subMenuItems firstObject];
        }
    }else if(data.isLeaf){
        //是叶子节点还需刷新parent的tableView
        NSInteger parentIndex = data.parent.depth-1;
        if(parentIndex >= 0 && parentIndex < self.tableViewControllers.count){
            RicMenuController *mainController = self.tableViewControllers[parentIndex];
            if(mainController.menuItem.hasSubMenuSelected == NO){
                [mainController refreshData];
            }
        }
    }
    // 刷新子菜单
    if(data.depth < self.tableViewControllers.count){
        RicMenuController *subMenuController = self.tableViewControllers[data.depth];
        if(self.delegate && [self.delegate respondsToSelector:@selector(configControllerOfMenu:controller:)]){
            [self.delegate configControllerOfMenu:data controller:subMenuController];
        }
        subMenuController.menuItem = data;
        [subMenuController refreshData];
        [self autoScrollToSelectedItemsForItem:data controller:subMenuController];
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(filterMenuDidClickedItem:)]){
        [self.delegate filterMenuDidClickedItem:data];
    }
}

- (void)configureCellActionsForCell:(UITableViewCell *)cell
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(configureActionsForCell:)]){
        [self.delegate configureActionsForCell:cell];
    }
}

- (NSArray <id<RicMenuModelDataSource>>*)filteredResult
{
    NSMutableArray *result = [NSMutableArray new];
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(RicMenuItem * _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return evaluatedObject.isSelected;
    }];
    NSArray *filterItems = [self.rootData.allLeaves filteredArrayUsingPredicate: pre];
    for(RicMenuItem *item in filterItems){
        if(item.itemValue){
            [result addObject:item.itemValue];
        }
    }
    return result;
}

- (void)reloadAll
{
    [self.tableViewControllers makeObjectsPerformSelector:@selector(refreshData)];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
