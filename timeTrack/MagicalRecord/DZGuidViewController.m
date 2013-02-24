//
//  DZGuidViewController.m
//  timeTrack
//
//  Created by dzpqzb on 13-2-24.
//  Copyright (c) 2013年 dzpqzb.com. All rights reserved.
//

#import "DZGuidViewController.h"

@interface DZGuidViewController () <DZGuidViewDelegate, UIScrollViewDelegate>
{
    UIScrollView* scrollViewBack;
    UIPageControl* pageControl;
}
@end

@implementation DZGuidViewController
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        scrollViewBack = [[UIScrollView alloc] init];
        scrollViewBack.pagingEnabled = YES;
        scrollViewBack.showsVerticalScrollIndicator= NO;
        scrollViewBack.delegate = self;
        // Custom initialization
    }
    return self;
}

- (NSInteger) numberOfImages
{
    return 2;
}

- (UIImage*) imageForIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            return [UIImage imageNamed:@"guide_1.jpg"];
            break;
        case 1:
            return [UIImage imageNamed:@"guide_2.jpg"];
            break;
        case 2:
            return [UIImage imageNamed:@"toggle_button"];
            break;
        default:
            return nil;
            break;
    }
}
- (void) enterTheApp
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger number = ceil(scrollView.contentOffset.x / CGRectGetWidth(self.view.frame));
    pageControl.currentPage = number;
    NSInteger numbersOfImage = [self.delegate numberOfImages];
    if (scrollView.contentOffset.x - scrollView.contentSize.width/numbersOfImage*(numbersOfImage -1) > 70) {
        [self enterTheApp];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!pageControl) {
        pageControl = [[UIPageControl alloc] init];
    }
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.delegate = self;
    NSInteger numberOfImages = [self.delegate numberOfImages];
    scrollViewBack.contentSize = CGSizeMake((CGRectGetWidth([[UIScreen mainScreen] bounds]))*numberOfImages, CGRectGetHeight(self.view.frame)-22);
    CGRect imageFrame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame) -20, CGRectGetHeight(self.view.frame) - 20);
    for (int i = 0; i < numberOfImages; i++) {
        UIImageView* imageView = [[UIImageView alloc] init];
        imageView.image = [self.delegate imageForIndex:i];
        imageView.frame = CGRectOffset(imageFrame, i*CGRectGetWidth(self.view.frame) + 10, 10);
        [scrollViewBack addSubview:imageView];
    }
    scrollViewBack.frame = CGRectMake(0.0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    [self.view addSubview:scrollViewBack];
    pageControl.frame = CGRectMake(0.0, CGRectGetHeight(self.view.frame) -52, CGRectGetWidth(self.view.frame), 30);
    pageControl.numberOfPages = [self.delegate numberOfImages];
    pageControl.currentPage = 0;
    [self.view addSubview:pageControl];
    
    //
    self.view.backgroundColor = [UIColor colorWithHex:0xEEEEEE];
}
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
