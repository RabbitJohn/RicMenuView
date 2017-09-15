//
//  RicRecipe.m
//  RicMenuView
//
//  Created by john on 2017/7/4.
//
//

#import "RicRecipe.h"


@implementation RicRecipe

- (NSString *)tag
{
    return self.recipeId;
}

- (NSString *)title{
    return self.flavor;
}

- (NSArray <RicMenuModelDataSource>*) subMenuItems{
    return (NSArray <RicMenuModelDataSource>*)self.dishes;
}

- (BOOL)isDefaultValue{
    return self.isDefault;
}

- (void)setValue:(id)value forKey:(NSString *)key{
    if([key isEqualToString:@"dishes"]){
        NSArray *dishes = (NSArray *)value;
        NSMutableArray *ds = [[NSMutableArray alloc] initWithCapacity:[dishes count]];
        for(int i=0;i<dishes.count; i++){
            NSDictionary *dishDic = [dishes objectAtIndex:i];
            RicDish *dish = [[RicDish alloc] init];
            [dish setValuesForKeysWithDictionary:dishDic];
            [ds addObject:dish];
        }
        self.dishes = ds;
    }else{
        [super setValue:value forKey:key];
    }
}

@end

@implementation RicDish

- (NSString *)tag
{
    return self.recipeId;
}

- (NSString *)title{
    return self.name;
}
- (NSArray <RicMenuModelDataSource>*) subMenuItems{
    return nil;
}

- (BOOL)isDefaultValue{
    return self.isDefault;
}

@end
