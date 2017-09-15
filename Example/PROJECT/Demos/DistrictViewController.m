//
//  ViewController.m
//  RicMenu
//
//  Created by john on 16/5/30.
//
//

#import "DistrictViewController.h"
#import "Masonry.h"

#import "RicMenuView.h"
#import "RicMenuDepth0Cell.h"
#import "RicMenuDepth1Cell.h"
#import "RicMenuDepth2Cell.h"

#import "RicDistrictMenu.h"
#import "RicRecipe.h"
#import "RicMenuItem.h"
#import "RicRecipeMenu.h"

#import <MJExtension/MJExtension.h>

@interface DistrictViewController ()<RicMenuDelegate,RicMenuItemDelegate>

@property (nonatomic, strong) RicMenuView *filterView;

@end

@implementation DistrictViewController

- (void)viewDidLoad
{
    [super viewDidLoad];    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"district" ofType:@"json"]];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *realData = jsonDic[@"data"];
    RicDistrictMenu *rootDataModel = [RicDistrictMenu new];
    [rootDataModel setValuesForKeysWithDictionary:realData];
    
    RicMenuItem *rootItem = [[RicMenuItem alloc] initWithDelegate:self oriData:rootDataModel defaultSelections:nil];
    
    _filterView = [[RicMenuView alloc] initWithFrame:RicBaseFilterViewContentBounds];
    [_filterView setDelegate:self rootItem:rootItem];
    
    [self.view addSubview:_filterView];

    
    // Do any additional setup after loading the view, typically from a nib.
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
- (CGFloat )widthOfTableViewOfMenu:(RicMenuItem *)menu
{
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width/3.0f;
    
    return width;
}

// 这个代理方法需要指定 filterController的 heightForRowAtIndexPath 和 tableViewCellClass 两个属性
- (void)configControllerOfMenu:(RicMenuItem *)menu controller:(RicMenuController *)controller
{
    
    RicMenuController *subMenuController = controller;
    
    subMenuController.heightForRowAtIndexPath = ^CGFloat(NSInteger depth,NSIndexPath *indexPath,RicMenuItem *subMenu){
        if(depth == 0){
            return 50.0f;
        }else if(depth == 1){
            return 60.0f;
        }else{
            return 40.0f;
        }
    };
    
    if(menu.depth == 0){
        subMenuController.tableViewCellClass = [RicMenuDepth0Cell class];
    }else if(menu.depth == 1){
        if([menu.tag isEqualToString:@"location_district"]){
            subMenuController.tableViewCellClass = [RicMenuDepth1Cell class];
        }else{
            subMenuController.tableViewCellClass = [RicMenuDepth2Cell class];
        }
    }else if (menu.depth == 2){
        subMenuController.tableViewCellClass = [RicMenuDepth2Cell class];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
