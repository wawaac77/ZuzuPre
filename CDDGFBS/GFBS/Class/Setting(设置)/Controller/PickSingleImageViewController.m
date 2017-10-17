//
//  PickSingleImageViewController.m
//  GFBS
//
//  Created by Alice Jin on 16/10/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "PickSingleImageViewController.h"
#import <RSKImageCropper.h>
#import "ZBLocalized.h"

#import <SVProgressHUD.h>
#import <SDImageCache.h>
#import <UIImageView+WebCache.h>

@interface PickSingleImageViewController () <RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource, UIImagePickerControllerDelegate> {
    CGFloat imageViewWidth;
    CGFloat chooseButtonWidth;
}

@property (weak, nonatomic) IBOutlet UIButton *chooseButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) UIImage *pickedImage;


@end

@implementation PickSingleImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    self.navigationItem.title = ZBLocalized(@"Upload Profile Image", nil);
    [self setUpNavBar];
    
    //_chooseButton.frame = CGRectMake((GFScreenWidth - chooseButtonWidth) / 2, 300, chooseButtonWidth, 40);
    [_chooseButton addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
    [_chooseButton setTintColor:[UIColor whiteColor]];
    _chooseButton.backgroundColor = ZZGoldColor;
    _chooseButton.layer.cornerRadius = 4.0f;
    [_chooseButton setTitle:@"Choose from Library" forState:UIControlStateNormal];
    [self.view addSubview:_chooseButton];
    
    imageViewWidth = 200;
    NSString *imageURL = [ZZUser shareUser].userProfileImage.imageUrl;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil];
    //_imageView.frame = CGRectMake((GFScreenWidth - imageViewWidth)/2, 80, imageViewWidth, imageViewWidth);
    _imageView.layer.cornerRadius = _imageView.gf_width / 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpNavBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Upload" style:UIBarButtonItemStyleDone target:self action:@selector(okButtonClicked)];
    
}

- (void)okButtonClicked {
    NSLog(@"Upload button clicked");
}

- (void)chooseImage {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    //self.imageView.image = chosenImage;
    
    self.pickedImage = chosenImage;
    
    NSLog(@"chosenImage %@", chosenImage);
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:chosenImage];
    imageCropVC.delegate = self;
    [self.navigationController pushViewController:imageCropVC animated:YES];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma cropVC
//************* crop vc delegate

// Crop image has been canceled.
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image has been cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
{
    self.imageView.image = croppedImage;
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image has been cropped. Additionally provides a rotation angle used to produce image.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
                  rotationAngle:(CGFloat)rotationAngle
{
    self.imageView.image = croppedImage;
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image will be cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                  willCropImage:(UIImage *)originalImage
{
    // Use when `applyMaskToCroppedImage` set to YES.
    [SVProgressHUD show];
}

// Returns a custom rect for the mask.
- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller
{
    CGSize maskSize;
    if ([controller isPortraitInterfaceOrientation]) {
        maskSize = CGSizeMake(250, 250);
    } else {
        maskSize = CGSizeMake(220, 220);
    }
    
    CGFloat viewWidth = CGRectGetWidth(controller.view.frame);
    CGFloat viewHeight = CGRectGetHeight(controller.view.frame);
    
    CGRect maskRect = CGRectMake((viewWidth - maskSize.width) * 0.5f,
                                 (viewHeight - maskSize.height) * 0.5f,
                                 maskSize.width,
                                 maskSize.height);
    
    return maskRect;
}

// Returns a custom path for the mask.
- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller
{
    CGRect rect = controller.maskRect;
    CGPoint point1 = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGPoint point2 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPoint point3 = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    
    UIBezierPath *triangle = [UIBezierPath bezierPath];
    [triangle moveToPoint:point1];
    [triangle addLineToPoint:point2];
    [triangle addLineToPoint:point3];
    [triangle closePath];
    
    return triangle;
}

// Returns a custom rect in which the image can be moved.
- (CGRect)imageCropViewControllerCustomMovementRect:(RSKImageCropViewController *)controller
{
    // If the image is not rotated, then the movement rect coincides with the mask rect.
    return controller.maskRect;
}


@end
