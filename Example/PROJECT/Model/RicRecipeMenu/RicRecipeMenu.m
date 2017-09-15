//
//  RicMenu.m
//  RicMenuView
//
//  Created by john on 2017/7/4.
//
//

#import "RicRecipeMenu.h"

@implementation RicRecipeMenu

- (NSString *)tag
{
    return self.menutag;
}

- (NSString *)title{
    return self.name;
}
- (NSArray <RicMenuModelDataSource>*) subMenuItems{
    return (NSArray <RicMenuModelDataSource>*)self.recipes;
}

- (BOOL)isDefaultValue{
    return YES;
}

- (void)setValue:(id)value forKey:(NSString *)key{
    if([key isEqualToString:@"recipes"]){
        NSArray *recipes = (NSArray *)value;
        NSMutableArray *rs = [[NSMutableArray alloc] initWithCapacity:[recipes count]];
        for(int i=0;i<recipes.count; i++){
            NSDictionary *recipeDic = [recipes objectAtIndex:i];
            RicRecipe *recipe = [[RicRecipe alloc] init];
            [recipe setValuesForKeysWithDictionary:recipeDic];
            [rs addObject:recipe];
        }
        self.recipes = rs;
    }else{
        [super setValue:value  forKey:key];
    }
}

@end
