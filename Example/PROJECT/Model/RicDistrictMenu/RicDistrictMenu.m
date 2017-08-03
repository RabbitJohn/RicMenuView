//
//  RicDistrictMenu.m
//  RicMenu
//
//  Created by rice on 16/5/30.
//
//

#import "RicDistrictMenu.h"

@interface RicDistrictMenu ()

@property (nonatomic, weak) id<RicMenuModelDataSource>parent;
@property (nonatomic, assign) NSInteger itemIndex;

@end

@implementation RicDistrictMenu

- (void)setValue:(id)value forKey:(NSString *)key{
    if([key isEqualToString:@"submenus"]){
        NSArray *arr = (NSArray *)value;
        if(arr.count > 0){
            NSMutableArray *submenus = [NSMutableArray new];
            for(NSInteger i=0;i<arr.count;i++){
                NSDictionary *dic = arr[i];
                RicDistrictMenu *subMenu = [RicDistrictMenu new];
                [subMenu setValuesForKeysWithDictionary:dic];
                [submenus addObject:subMenu];
            }
            [super setValue:submenus forKey:key];
        }
    }else{
        [super setValue:value forKey:key];
    }
}

- (NSString *)tag
{
    return self.key;
}

- (NSString *)title{
    return self.name;
}

- (NSArray *)subMenuItems{
    return self.submenus;
}

- (BOOL)isDefaultValue{
    return self.isDefault;
}

@end
