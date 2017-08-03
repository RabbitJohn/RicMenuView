//
//  SecondViewController.m
//  RicMenuView
//
//  Created by 张礼焕 on 2017/7/20.
//
//

#import "FirstViewController.h"
#import "DistrictViewController.h"
#import "RecipesViewController.h"

@interface DemoCell : UITableViewCell

@end

@implementation DemoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
    }
    return self;
}

@end

@interface FirstViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *navigationTitles;
@end

@implementation FirstViewController
- (NSArray *)navigationTitles
{
    return @[@"区域信息",
             @"菜谱"
             ];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.navigationTitles.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DemoCell *demoCell = (DemoCell *)[self.tableView dequeueReusableCellWithIdentifier:@"DemoCell"];
    
    demoCell.textLabel.text = self.navigationTitles[indexPath.row];
    
    return demoCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        DistrictViewController *districVC = [[DistrictViewController alloc] init];
        [self.navigationController pushViewController:districVC animated:YES];
    }else if(indexPath.row == 1){
        RecipesViewController *recipesVC = [[RecipesViewController alloc] init];
        [self.navigationController pushViewController:recipesVC animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:[DemoCell class] forCellReuseIdentifier:@"DemoCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
