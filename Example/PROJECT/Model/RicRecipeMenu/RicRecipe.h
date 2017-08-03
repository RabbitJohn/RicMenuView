//
//  RicRecipe.h
//  RicMenuView
//
//  Created by 张礼焕 on 2017/7/4.
//
//

#import "RicBaseModel.h"
#import "RicMenuItem.h"

@class RicDish;
@class RicRecipe;

@interface RicRecipe : RicBaseModel<RicMenuModelDataSource>

@property (nonatomic, copy) NSString *flavor;
@property (nonatomic, copy) NSString *recipeId;
@property (nonatomic, strong) NSArray <RicDish *> *dishes;
@property (nonatomic, assign) BOOL isDefault;



@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *tag;
@property (nonatomic, readonly) NSArray <RicMenuModelDataSource>*subMenuItems;
@property (nonatomic, readonly) BOOL isDefaultValue;

@end

@interface RicDish : RicBaseModel<RicMenuModelDataSource>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *buyamount;
@property (nonatomic, copy) NSString *approve;
@property (nonatomic, copy) NSString *spicy;
@property (nonatomic, copy) NSString *lastComment;
@property (nonatomic, copy) NSString *recipeId;
@property (nonatomic, assign) BOOL isDefault;


@property (nonatomic, readonly) NSString *tag;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSArray <RicMenuModelDataSource>*subMenuItems;
@property (nonatomic, readonly) BOOL isDefaultValue;


@end
