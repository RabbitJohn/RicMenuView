//
//  RicDistrictMenu.h
//  RicMenu
//
//  Created by rice on 16/5/30.
//
//

#import <Foundation/Foundation.h>
#import "RicMenuItem.h"
#import "RicBaseModel.h"

@interface RicDistrictMenu :RicBaseModel  <RicMenuModelDataSource>

@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) NSInteger depth;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, assign) BOOL multiple;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray <RicDistrictMenu*> *submenus;
@property (nonatomic, assign) BOOL isDefault;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSString *value;

@property (nonatomic, readonly) NSString *tag;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSArray <RicMenuModelDataSource>*subMenuItems;
@property (nonatomic, readonly) BOOL isDefaultValue;

@end
