//
//  RicMenuController.m
//  john
//
//  Created by john on 16/5/31.
//
//

#import "RicMenuController.h"

@interface RicMenuController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RicMenuItem *currentSelectedModel;
@property (nonatomic, strong) NSString *reusedId;
@property (nonatomic, weak) id <RicMenuControllerDelegate> delegate;
@end

@implementation RicMenuController

- (instancetype)init{
    self = [super init];
    if(self){
        [self initialize];
    }
    return self;
}

- (instancetype)initWithDelegate:(id<RicMenuControllerDelegate>)delegate
{
    self = [super init];
    if(self){
        [self initialize];
        self.delegate = delegate;
    }
    return self;
}
- (void)initialize
{
    self.tableView = [UITableView new];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    CGFloat footheight = 0.0f;
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    UIView *tableFootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f ,width , footheight)];
    tableFootView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = tableFootView;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}
- (void)setTableViewCellClass:(Class)tableViewCellClass
{
    #ifdef DEBUG
        NSAssert([tableViewCellClass isSubclassOfClass:[UITableViewCell class]], @"tableViewCellClass 必须是 UITableViewCell");
    #endif
    _tableViewCellClass =  tableViewCellClass;
    self.reusedId = NSStringFromClass(_tableViewCellClass);
    if(self.tableView && _tableViewCellClass){
        [self.tableView registerClass:_tableViewCellClass forCellReuseIdentifier:self.reusedId];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = self.menuItem.subMenuItems.count;
    return rowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 40.0f;
    if(self.heightForRowAtIndexPath){
        RicMenuItem *subMenuItem = self.menuItem.subMenuItems[indexPath.row];
        height = self.heightForRowAtIndexPath(self.menuItem.depth+1,indexPath,subMenuItem);
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell <RicMenuItemCellDelegate>*tableViewCell = [self.tableView dequeueReusableCellWithIdentifier:self.reusedId];
    
    RicMenuItem *subMenu = self.menuItem.subMenuItems[indexPath.row];
    [tableViewCell updateMenuItem:subMenu];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(configureCellActionsForCell:)]){
        [self.delegate configureCellActionsForCell:tableViewCell];
    }
    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RicMenuItem *subMenu = self.menuItem.subMenuItems[indexPath.row];
    self.currentSelectedModel = subMenu;
    if(self.menuItem.supportMutiChildrenSelected){
        
        [subMenu updateSelected:!subMenu.isSelected];

    }else{
        [self.menuItem.subMenuItems enumerateObjectsUsingBlock:^(RicMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj != subMenu){
                [obj updateSelected: NO];
            }else{
                [obj updateSelected: YES];
            }
        }];
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectedFilterData:)])
    {
        [self.delegate didSelectedFilterData:subMenu];
    }
    if(self.menuItem.supportMutiChildrenSelected && subMenu.isSelected && subMenu.isLeaf){
    // 选中后是否还原为非选
        if(subMenu.delegate && [subMenu.delegate respondsToSelector:@selector(supportMutiSelectionForItem:)])
        {
            //获取多选限制
            NSInteger maxSelectionCount = HUGE;
            
            if(subMenu.delegate && [subMenu.delegate respondsToSelector:@selector(maxSelectionCountForDepth:parentItem:)])
            {
                maxSelectionCount = [subMenu.delegate maxSelectionCountForDepth:subMenu.depth parentItem:subMenu.parent];
            }
            
            if(subMenu.delegate && [subMenu.delegate respondsToSelector:@selector(filterViewShouldSelectedItem:leftSelectCount:)] && maxSelectionCount > 0)
            {// 当前选项选中前已选的数量
                NSInteger leftCount = maxSelectionCount-subMenu.parent.allSelectedLeaves.count + 1;
                // 是否置为非选.
                BOOL shouldSelect = [subMenu.delegate filterViewShouldSelectedItem:subMenu leftSelectCount:leftCount];
                if(!shouldSelect)
                {
                    [subMenu updateSelected:NO];
                }
            }
        }
    }

    [self refreshData];
}

- (void)refreshData{
    [self.tableView reloadData];
}


@end
