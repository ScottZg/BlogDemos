//
//  GeneratationViewController.m
//  CoreImageDemo
//
//  Created by zhanggui on 2017/10/31.
//  Copyright © 2017年 zhanggui. All rights reserved.
//

#import "GeneratationViewController.h"

@interface GeneratationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation GeneratationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = self.img;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideV)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:tap];
}
- (void)hideV {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
 
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
    self.navigationController.navigationBarHidden = NO;
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
