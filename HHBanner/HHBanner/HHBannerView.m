//
//  HHBannerView.m
//  HHBanner
//
//  Created by bruthlee on 2018/5/9.
//  Copyright © 2018年 Github.com. All rights reserved.
//

#import "HHBannerView.h"

#import <SDWebImage/UIImageView+WebCache.h>

#import "HHBannerPageControl.h"

@interface HHBannerView() <UIScrollViewDelegate> {
    NSInteger _totalPages;
    NSTimer *_bannerTimer;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HHBannerPageControl *pageControl;
@property (nonatomic, copy) HHBannerViewBlock bannerBlock;
@property (nonatomic, strong) NSArray *bannerList;
@end

@implementation HHBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        self.scrollView.scrollsToTop = NO;
        [self addSubview:self.scrollView];
        
        self.pageControl = [[HHBannerPageControl alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 10.0)];
        [self addSubview:self.pageControl];
    }
    return self;
}

- (void)reloadBanners:(NSArray *)banners touchBlock:(HHBannerViewBlock)block {
    self.bannerList = banners;
    _totalPages = banners ? banners.count : 0;
    self.bannerBlock = block;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self destoryTimer];
    
    if (banners && _totalPages > 0) {
        CGSize size = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        NSInteger count = _totalPages > 1 ? (_totalPages + 2) : 1;
        self.scrollView.contentSize = CGSizeMake(count * size.width, size.height);
        self.pageControl.totalPage = _totalPages;
        self.pageControl.currentPage = 0;
        
        CGRect frame = CGRectMake(0, 0, size.width, size.height);
        UIImage *place = [UIImage imageNamed:@"icon_home_banner"];
        for (NSInteger i = 0; i < count; i++) {
            NSString *url = nil;
            if (count > 1) {
                if (i == 0) {
                    url = [banners lastObject];
                }
                else if (i > _totalPages) {
                    url = [banners firstObject];
                }
                else {
                    url = [banners objectAtIndex:(i-1)];
                }
            }
            else {
                url = [banners firstObject];
            }
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
            [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:place];
            [self.scrollView addSubview:imageView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImageView:)];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:tap];
            
            frame.origin.x += frame.size.width;
        }
        
        if (_totalPages > 1) {
            [self.scrollView setContentOffset:CGPointMake(size.width, 0) animated:NO];
            
            _bannerTimer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(runBannerTimer) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_bannerTimer forMode:NSRunLoopCommonModes];
        }
    }
}

- (void)touchImageView:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.scrollView];
    NSInteger index = point.x / CGRectGetWidth(self.scrollView.bounds);
    if (_totalPages > 1) {
        if (index == 0) {
            index = _totalPages - 1;
        }
        else if (index > _totalPages) {
            index = 0;
        }
        else {
            index--;
        }
        if (self.bannerList && self.bannerList.count > index) {
            NSString *url = [self.bannerList objectAtIndex:index];
            self.bannerBlock(index, url);
        }
    }
    else if (self.bannerList && self.bannerList.count > 0) {
        if (self.bannerBlock) {
            NSString *url = [self.bannerList firstObject];
            self.bannerBlock(index, url);
        }
    }
}

#pragma mark - Inherit

- (void)dealloc {
    [self destoryTimer];
    self.scrollView.delegate = nil;
    self.bannerBlock = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    CGRect frame = self.pageControl.frame;
    frame.origin.y = CGRectGetHeight(self.bounds) - 15.0;
    self.pageControl.frame = frame;
}

#pragma mark - Timer

- (void)pauseTimer {
    if (_bannerTimer) {
        [_bannerTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)destoryTimer {
    if (_bannerTimer) {
        [_bannerTimer invalidate];
        _bannerTimer = nil;
    }
}

- (void)runBannerTimer {
    CGFloat width = self.scrollView.bounds.size.width;
    NSInteger index = self.scrollView.contentOffset.x / width;
    [self.scrollView setContentOffset:CGPointMake((index + 1) * width, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat width = scrollView.bounds.size.width;
    if (width <= 0) {
        return;
    }
    
    NSInteger index = scrollView.contentOffset.x / width;
    if (_totalPages > 1) {
        if (index == 0) {
            [scrollView setContentOffset:CGPointMake(width * _totalPages, 0) animated:NO];
            index = _totalPages - 1;
        }
        else if (index > _totalPages) {
            [scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
            index = 0;
        }
        else {
            index--;
        }
    }
    
    if (index != self.pageControl.currentPage) {
        self.pageControl.currentPage = index;
    }
}

@end
