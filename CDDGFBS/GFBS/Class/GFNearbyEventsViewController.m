//
//  GFNearbyEventsViewController.m
//  GFBS
//
//  Created by Alice Jin on 17/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "GFNearbyEventsViewController.h"

#import "GFEventsCell.h"

#import "GFTopic.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>

#import "MinScrollMenu.h"
#import "MinScrollMenuItem.h"

@interface GFNearbyEventsViewController () <MinScrollMenuDelegate>
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) MinScrollMenu *menu;
@property (weak, nonatomic) IBOutlet MinScrollMenu *ibMenu;
@end

@implementation GFNearbyEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 35, [UIScreen mainScreen].bounds.size.width, 165);
    self.automaticallyAdjustsScrollViewInsets = NO;
    _count = 20;
    _ibMenu.delegate = self;
    
    _menu = [[MinScrollMenu alloc] initWithFrame:self.view.frame];
    _menu.delegate = self;
    
    [self.view addSubview:_menu];

    //[self setUpTable];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _menu.frame = CGRectMake(0.0, 0.0, ScreenWidth, self.view.gf_height);
}

- (IBAction)reload:(UIBarButtonItem *)sender {
    _count = arc4random() % 100;
    [_ibMenu reloadData];
    _count = arc4random() % 1000;
    [_menu reloadData];
}

#pragma MinScrollMenuDelegate Method

- (NSInteger)numberOfMenuCount:(MinScrollMenu *)menu {
    return _count;
}

- (CGFloat)scrollMenu:(MinScrollMenu *)menu widthForItemAtIndex:(NSInteger)index {
    return self.view.gf_width / 2;
}

- (MinScrollMenuItem *)scrollMenu:(MinScrollMenu *)menu itemAtIndex:(NSInteger)index {
    /*
    if (index %2 == 0) {
        MinScrollMenuItem *item = [menu dequeueItemWithIdentifer:@"textItem"];
        if (item == nil) {
            item = [[MinScrollMenuItem alloc] initWithType:TextType reuseIdentifier:@"textItem"];
            item.textLabel.textAlignment = NSTextAlignmentCenter;
            //item.textLabel.text = @"this is an event";
            item.backgroundColor = [UIColor cyanColor];
            //item.textLabel.layer.borderWidth = 1;
            //item.textLabel.layer.borderColor = [UIColor blackColor].CGColor;
        }
        item.textLabel.text = [NSString stringWithFormat:@"%ld", index];
        
        return item;
     
    } else {
     */
        NSLog(@"index%ld", index);
        MinScrollMenuItem *item = [menu dequeueItemWithIdentifer:@"imageItem"];
        item.backgroundColor = [UIColor redColor];
        if (item == nil) {
            item = [[MinScrollMenuItem alloc] initWithType:ImageType reuseIdentifier:@"imageItem"];
           
        }
        item.imageView.image = [UIImage imageNamed:@"pexels-photo.png"];
        item.textLabel.text = @"Fitness Morning";
        item.timeLabel.text = @"  Today 15:00";
    item.timeLabel.layer.cornerRadius = 5.0f;
        return item;
}

- (void)scrollMenu:(MinScrollMenu *)menu didSelectedItem:(MinScrollMenuItem *)item atIndex:(NSInteger)index {
    NSLog(@"tap index: %ld", index);
}

-(void)willMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"NearbyVC moving to or from parent view controller");
    //self.view.backgroundColor = [UIColor redColor];
}

-(void)didMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"NearbyVC did move to or from parent view controller");
    //self.view.frame = CGRectMake(0, 35, self.view.gf_width, 165);
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
