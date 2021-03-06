//
//  FilterViewController.m
//  CoreImageDemo
//
//  Created by zhanggui on 2017/10/31.
//  Copyright © 2017年 zhanggui. All rights reserved.
//

#import "FilterViewController.h"
#import "GeneratationViewController.h"
@interface FilterViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *compleButton;
@property (nonatomic,strong)UIImagePickerController *picker;

@property (nonatomic,strong)CIContext *context;
@property (nonatomic,strong)CIFilter *filter;
@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(closeView)];
    self.compleButton.layer.cornerRadius = 6;
    
    self.imageView.contentMode = UIViewContentModeCenter;
    [self addGest];
}
- (IBAction)sliderValueChangedAction:(UISlider *)sender {
    CGFloat sliderValue = sender.value;
    NSLog(@"%f",sliderValue);
    [self.filter setValue:@(sliderValue) forKey:kCIInputIntensityKey];
    
   
    CGImageRef cgimg = [self.context createCGImage:[self.filter outputImage] fromRect:[[self.filter outputImage] extent]];
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    self.imageView.image = newImage;
    
    
}
- (IBAction)buttonAction:(id)sender {
    
    UIImage *image = self.imageView.image;
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    

    
    
    [self.filter setValue:ciImage forKey:kCIInputImageKey];
    [self.filter setValue:@(self.slider.value) forKey:kCIInputIntensityKey];
    
    
    CGImageRef cgimg = [self.context createCGImage:[self.filter outputImage] fromRect:[[self.filter outputImage] extent]];
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    [self performSegueWithIdentifier:@"showGenerate" sender:newImage];
}
- (void)addGest {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPhoto)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:tap];
}
- (void)selectPhoto {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择图片来源" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showPhoto];
    }];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showCamera];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:photoAction];
    [alert addAction:takePhotoAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)showCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _picker = [[UIImagePickerController alloc] init];
        
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        _picker.delegate = self;
        
        [self presentViewController:_picker animated:YES completion:nil];
    }
}
- (void)showPhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        _picker = [[UIImagePickerController alloc] init];

        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

        _picker.delegate = self;
        
        [self presentViewController:_picker animated:YES completion:nil];
    }
}
- (void)closeView {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    if ([[info allKeys] containsObject:UIImagePickerControllerOriginalImage] && info[UIImagePickerControllerOriginalImage]!=nil) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        self.imageView.image = image;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
        [self.filter setValue:ciImage forKey:kCIInputImageKey];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
   
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    GeneratationViewController *vc = segue.destinationViewController;
    UIImage *image = (UIImage *)sender;
    vc.img = image;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (CIContext *)context {
    if (!_context) {
        _context = [CIContext contextWithOptions:nil];
    }
    return _context;
}
- (CIFilter *)filter {
    if (!_filter) {
        _filter = [CIFilter filterWithName:@"CISepiaTone"];
    }
    return _filter;
}
@end
