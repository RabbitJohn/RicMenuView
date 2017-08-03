//
//  RicBaseFilterViewController.m
//  RicMenuView
//
//  Created by 张礼焕 on 2017/7/20.
//
//

#import "RicBaseFilterViewController.h"

@interface RicBaseFilterViewController ()


@end

@implementation RicBaseFilterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)-120, CGRectGetWidth(self.view.bounds), 50)];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor yellowColor];
    [button setTitle:@"get result" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(getResult) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    // Do any additional setup after loading the view.
}

- (void)getResult
{
    
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
