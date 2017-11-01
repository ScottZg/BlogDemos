//
//  GeneratationViewController.m
//  CoreImageDemo
//
//  Created by zhanggui on 2017/10/31.
//  Copyright © 2017年 zhanggui. All rights reserved.
//

#import "GeneratationViewController.h"
#import "PhotoManager.h"
@interface GeneratationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation GeneratationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = self.img;
    
    //点击返回
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideV)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:tap];
    
    //长按保存
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage)];
    [self.imageView addGestureRecognizer:longPress];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}
- (void)saveImage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveToAlbum];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:photoAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)saveToAlbum {
    [[PhotoManager shared] saveImage:self.imageView.image withCompleteHandler:^(BOOL boo, NSString *errorStr) {
        if (boo) {
            [self alertWithTitle:@"提示" andMessage:@"保存成功" andButtonTitle:@"确定"];
        }else {
            [self alertWithTitle:@"提示" andMessage:@"保存失败，请稍后重试" andButtonTitle:@"确定"];
        }
    }];
}

- (void)hideV {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
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
