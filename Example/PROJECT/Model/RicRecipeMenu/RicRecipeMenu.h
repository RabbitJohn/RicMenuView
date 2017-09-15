//
//  RicMenu.h
//  RicMenuView
//
//  Created by john on 2017/7/4.
//
//

#import "RicBaseModel.h"
#import "RicMenuItem.h"
#import "RicRecipe.h"

@interface RicRecipeMenu : RicBaseModel<RicMenuModelDataSource>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray <RicRecipe *>*recipes;
@property (nonatomic, strong) NSString *menutag;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *tag;
@property (nonatomic, readonly) NSArray <RicMenuModelDataSource>*subMenuItems;
@property (nonatomic, readonly) BOOL isDefaultValue;



@end
