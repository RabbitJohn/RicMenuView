//
//  RecipesViewController.m
//  RicMenuView
//
//  Created by john on 2017/7/20.
//
//

#import "RecipesViewController.h"
#import "Masonry.h"

#import "RicMenuView.h"
#import "RicMenuDepth0Cell.h"
#import "RicMenuDepth2Cell.h"

#import "RicDistrictMenu.h"
#import "RicRecipe.h"
#import "RicMenuItem.h"
#import "RicRecipeMenu.h"

#import <MJExtension/MJExtension.h>

@interface RecipesViewController ()<RicMenuDelegate,RicMenuItemDelegate>

@property (nonatomic, strong) RicMenuView *filterView;

@end

@implementation RecipesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"recipe" ofType:@"json"]];

    NSError *err = nil;
    NSDictionary *menuDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    
    RicRecipeMenu* menu = [RicRecipeMenu new];
    [menu setValuesForKeysWithDictionary:menuDic];
    
    RicMenuItem *rootItem = [[RicMenuItem alloc] initWithDelegate:self oriData:menu defaultSelections:nil];
        
    _filterView = [[RicMenuView alloc] initWithFrame:RicBaseFilterViewContentBounds];
    [_filterView setDelegate:self rootItem:rootItem];
    
    [self.view addSubview:_filterView];

    // Do any additional setup after loading the view.
}

- (void)getResult
{
    NSArray *result = _filterView.filteredLeafMenuItems;
}

- (void)filterMenuDidClickedItem:(RicMenuItem *)item
{
    
}

- (BOOL)supportMutiSelectionForItem:(RicMenuItem *)item{
    
    if(item.allSubMenusAreLeaves){
        return YES;
    }else{
        return NO;
    }
    
}

- (void )configTableViewAtDepth:(NSInteger)depth tableView:(UITableView *)tableView
{
    UIColor *bgColor = [UIColor whiteColor];
    if(depth == 0){
        bgColor = [UIColor colorWithRed:243.0f/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:1.0f];
    }else if(depth == 1){
        bgColor = [UIColor colorWithRed:113.0f/255.0f green:133.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    }
    tableView.backgroundColor = bgColor;
}

// 返回一个偏移量给tableView
- (CGFloat)widthOfTableViewOfMenu:(RicMenuItem *)menu{
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width/3.0f;
    
    return width;
}

// 这个代理方法需要指定 filterController的 heightForRowAtIndexPath 和 tableViewCellClass 两个属性
- (void)configControllerOfMenu:(RicMenuItem *)menu controller:(RicMenuController *)controller
{
    
    RicMenuController *filterController = controller;
    
    filterController.heightForRowAtIndexPath = ^CGFloat(NSInteger depth,NSIndexPath *indexPath,RicMenuItem *filterModel){
        if(depth == 0){
            return 50.0f;
        }else if(depth == 1){
            return 60.0f;
        }else{
            return 40.0f;
        }
    };
    
    if(menu.depth == 0){
        filterController.tableViewCellClass = [RicMenuDepth0Cell class];
    }else{
        filterController.tableViewCellClass = [RicMenuDepth2Cell class];
    }
}

// cell 动作
- (void)configureActionsForCell:(UITableViewCell *)cell{
    NSLog(@"configure cell here");
}


@end
