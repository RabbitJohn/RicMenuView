# RicMenuView
###Effect

![image](https://github.com/zLihuan/RicMenuView/blob/master/demo.gif) 

###Usage
// initialize menu data

    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"district" ofType:@"json"]];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *realData = jsonDic[@"data"];
    RicDistrictMenu *rootDataModel = [RicDistrictMenu new];
    [rootDataModel setValuesForKeysWithDictionary:realData];
    
    RicMenuItem *rootItem = [[RicMenuItem alloc] initWithDelegate:self oriData:rootDataModel defaultSelections:nil];
    
    _menuView = [[RicMenuView alloc] initWithFrame:RicBaseFilterViewContentBounds];
    [_menuView setDelegate:self rootItem:rootItem];
    
    [self.view addSubview:_menuView];

    // get the result

    NSArray *result = _menuView.filteredLeafMenuItems;

    // delegates
    - (void)filterMenuDidClickedItem:(RicMenuItem *)item
    {  
    // for clicking the item in the menu
    }

    - (BOOL)supportMutiSelectionForItem:(RicMenuItem *)item{
    // for selection enable    
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
    // config the MenuController
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

    // add actions for your cells
    // cell 动作
    - (void)configureActionsForCell:(UITableViewCell *)cell{
    NSLog(@"configure cell here");
    }

###Integration:

To integrate the control use Cocoapods add the line below into your Podfile: 

pod:'RicMenuView','~>0.0.1'
