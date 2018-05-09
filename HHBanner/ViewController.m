//
//  ViewController.m
//  HHBanner
//
//  Created by lixy on 2018/5/9.
//  Copyright © 2018年 Github.com. All rights reserved.
//

#import "ViewController.h"

#import "HHBannerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    NSArray *urls = @[@"http://bpic.588ku.com/back_pic/04/87/92/3458ef5baa9fb92.jpg!/fh/300/quality/90/unsharp/true/compress/true",@"http://bpic.588ku.com/back_pic/00/15/01/1556792adfbca83.jpg!/fh/300/quality/90/unsharp/true/compress/true",@"http://bpic.588ku.com/back_pic/00/00/69/40/e813e05e7e2a4039313a82cd1ef3de02.jpg!/fh/300/quality/90/unsharp/true/compress/true",@"http://bpic.588ku.com/back_pic/03/72/92/6657b9a240d3d1f.jpg!/fh/300/quality/90/unsharp/true/compress/true",@"http://bpic.588ku.com/back_pic/04/88/86/6858f5e2e7d71e1.jpg!/fh/300/quality/90/unsharp/true/compress/true", @"http://bpic.588ku.com/back_pic/00/02/08/715610daff1c208.jpg"];
    
    CGRect rect = CGRectMake(0, 100, CGRectGetWidth(self.view.bounds), 200);
    HHBannerView *view = [[HHBannerView alloc] initWithFrame:rect];
    [self.view addSubview:view];
    [view reloadBanners:urls touchBlock:^(NSInteger index, NSString *url) {
        NSLog(@"clicked: %@ [%@]",@(index), url);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
