//
//  ViewController.m
//  CoreImageDemo
//
//  Created by zhanggui on 2017/10/30.
//  Copyright © 2017年 zhanggui. All rights reserved.
//

#import "ViewController.h"
#import <CoreImage/CoreImage.h>
#import "BaseNavigationController.h"
#import "FilterViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *toolTableView;

@property (nonatomic,strong)NSMutableArray *toolArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"实用工具";
    
    self.toolTableView.tableFooterView = [UIView new];

}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.toolArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CELLIDENTIFIER = @"toolCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLIDENTIFIER];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.toolArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    FilterViewController *filterVC = [[FilterViewController alloc] init];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    filterVC.navigationItem.title = cell.textLabel.text;
    [self performSegueWithIdentifier:@"presentFilterView" sender:cell.textLabel.text];
//    BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:filterVC];
//    [self presentViewController:baseNav animated:YES completion:nil];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"presentFilterView"]) {
        BaseNavigationController *vc = segue.destinationViewController;
        NSString *title =  [NSString stringWithFormat:@"%@",sender];
        [vc.visibleViewController setValue:title forKey:@"title"];
    }
}
#pragma mark - Lazy load
- (NSMutableArray *)toolArr {
    if (!_toolArr) {
        _toolArr = [[NSMutableArray alloc] initWithObjects:@"亮度", nil];
    }
    return _toolArr;
}
@end
