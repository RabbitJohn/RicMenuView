//
//  RicModel.m
//  rice
//
//  Created by 张礼焕 on 16/5/30.
//  Copyright © 2016年 rice. All rights reserved.
//

#import "RicMenuItem.h"

@interface RicMenuItem ()
{
    BOOL __isSelected__;
}
//@property (nonatomic, copy) NSString *tag;
@property (nonatomic, weak) RicMenuItem *parent;
@property (nonatomic, weak) RicMenuItem *theRoot;
@property (nonatomic, strong) NSMutableArray <RicMenuItem*>*theSubMenuItems;
@property (nonatomic, strong) id<RicMenuModelDataSource> itemValue;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger totalDepth;
@property (nonatomic, assign) NSInteger theDepth;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) NSNumber *submenusPureLeaves;

@property (nonatomic, strong) NSMutableArray *allTheLeaves;

// 默认选中的叶子节点
@property (nonatomic, strong) NSArray *defaultSelections;
/**
 获取数据
 */
- (void)getValueFromData:(id<RicMenuModelDataSource>)oriData;
/**
 获取数据后检查默认选项
 */
- (void)checkoutDefault;

@end


@implementation RicMenuItem

- (instancetype)initWithDelegate:(id<RicMenuItemDelegate>)delegate oriData:(id<RicMenuModelDataSource>)oriData defaultSelections:(NSArray <id<RicMenuModelDataSource>>*)defaultSelections{
    self = [super init];
    if(self){
        self.delegate = delegate;
        self.defaultSelections = defaultSelections;
        [self getValueFromData:oriData];
        [self checkoutDefault];
    }
    
    return self;
}

- (void)getValueFromData:(id<RicMenuModelDataSource>)oriData
{
    self.itemValue = oriData;
    self.title = oriData.title;
//    self.tag = oriData.tag;
    NSMutableArray *subMenuItems = nil;
    if(oriData.subMenuItems.count > 0){
        subMenuItems = [[NSMutableArray alloc] initWithCapacity:oriData.subMenuItems.count];
    }
    for(int i=0; i<oriData.subMenuItems.count; i++){
        
        id<RicMenuModelDataSource> oriSubData = oriData.subMenuItems[i];
        RicMenuItem *subItem = [RicMenuItem new];
        subItem.delegate = self.delegate;
        subItem.parent = self;
        subItem.theDepth = self.theDepth + 1;
        self.root.totalDepth = MAX(subItem.theDepth, self.root.totalDepth);
        if([oriSubData respondsToSelector:@selector(setParentName:)]){
            [oriSubData setParentName:subItem.parent.title];
        }
        [subItem getValueFromData:oriSubData];
        [subMenuItems addObject:subItem];
    }
    self.theSubMenuItems = subMenuItems;
}

- (void)checkoutDefault
{
    if(self.root.defaultSelections.count == 0){
        
        // 无默认选项的时候,选中一项默认选项
        if(self.parent.depth == 0 && [self.itemValue isDefaultValue]){
            [self setIsSelected:YES];
        }else if (self.parent.isSelected && [self.itemValue isDefaultValue]){
            [self setIsSelected:YES];
        }
        
        if(self.subMenuItems.count > 0)
        {
            RicMenuItem *subItem = [self.subMenuItems firstObject];
            [subItem checkoutDefault];
        }
    }else{
        //有默认选项
        __weak RicMenuItem *weakSelf = self;
        
        NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(RicMenuItem * _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
           return [weakSelf.defaultSelections containsObject:evaluatedObject.itemValue];        }];
        
        NSArray *defaultItems = [self.root.allLeaves filteredArrayUsingPredicate:pre];
        
        [defaultItems makeObjectsPerformSelector:@selector(makeSelected)];
        
        if(defaultItems.count > 0){
            
            RicMenuItem *firstItem = [defaultItems firstObject];
            RicMenuItem *item = firstItem.parent;
            
            while (item) {
                [item setIsSelected:YES];
                item = item.parent;
            }
            
        }
    }
}

- (NSString *)tag
{
    return self.itemValue.tag;
}

- (BOOL)isLeaf{
    return self.theSubMenuItems.count == 0;
}

- (NSInteger)depth{
    
    return self.theDepth;
}

- (NSArray *)subMenuItems{
    return self.theSubMenuItems;
}

- (RicMenuItem *)root
{
    if(_theRoot){
        return _theRoot;
    }
    _theRoot = self;
    while (_theRoot.depth != 0) {
        _theRoot = _theRoot.parent;
    }
    return _theRoot;
}

- (void)setIsSelected:(BOOL)isSelected
{
    __isSelected__ = isSelected;
}

- (BOOL)isSelected
{
    return __isSelected__;
}

- (BOOL)supportMutiChildrenSelected{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(supportMutiSelectionForItem:)]){
        return [self.delegate supportMutiSelectionForItem:self];
    }
    return NO;
}

- (BOOL)hasSubMenuSelected
{
    __block BOOL hasSubMenuSelected = NO;
    
    [self.subMenuItems enumerateObjectsUsingBlock:^(RicMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.hasSubMenuSelected || obj.isSelected){
            hasSubMenuSelected = YES;
            *stop = YES;
        }
    }];
    
    return hasSubMenuSelected;
}

- (BOOL)allSubMenusAreLeaves
{
    if(!self.submenusPureLeaves){
        __weak RicMenuItem *weakSelf = self;
        self.submenusPureLeaves = @(YES);
        [self.subMenuItems enumerateObjectsUsingBlock:^(RicMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj.subMenuItems.count > 0){
                weakSelf.submenusPureLeaves = @(NO);
                *stop = YES;
            }
        }];
    }
    return self.submenusPureLeaves.boolValue;
}

- (NSArray <RicMenuItem *>*)allLeaves
{
    if(self.allTheLeaves){
        return self.allTheLeaves;
    }else{
        if(!self.allTheLeaves){
            self.allTheLeaves = [NSMutableArray new];
        }
        if(self.isLeaf){
            return @[self];
        }else{
            for(RicMenuItem *subMenu in self.subMenuItems){
                [self.allTheLeaves addObjectsFromArray:subMenu.allLeaves];
            }
        }
        return self.allTheLeaves;
    }
}
- (NSArray *)allSelectedLeaves
{
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(RicMenuItem*  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return evaluatedObject.isSelected;
    }];
    return [self.allLeaves filteredArrayUsingPredicate:pre];
}
- (NSArray *)allSelectedSubItems
{
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(RicMenuItem*  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return evaluatedObject.isSelected;
    }];
    return [self.subMenuItems filteredArrayUsingPredicate:pre];
}
- (void)clearSelectedStatusExclude:(NSArray <RicMenuItem*> *)items
{
    NSArray *result = nil;
    if(items.count){
        NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(RicMenuItem*  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return ![items containsObject:evaluatedObject] && evaluatedObject.isSelected == YES && [evaluatedObject respondsToSelector:@selector(clearSelectedStatus)];
        }];
        result = [self.allLeaves filteredArrayUsingPredicate:pre];
    }else{
        NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(RicMenuItem*  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return evaluatedObject.isSelected == YES && [evaluatedObject respondsToSelector:@selector(clearSelectedStatus)];
        }];
        result = [self.allLeaves filteredArrayUsingPredicate:pre];
    }
    [result makeObjectsPerformSelector:@selector(clearSelectedStatus)];
}

- (void)clearAllSelectedStatus
{
    [self clearSelectedStatusExclude:nil];
}

- (void)clearSelectedStatus
{
    [self setIsSelected:NO];
}

- (void)makeSelected
{
    [self setIsSelected:YES];
}

@end
