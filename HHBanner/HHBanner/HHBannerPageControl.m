//
//  HHBannerPageControl.m
//  HHBannerPageControl
//
//  Created by bruthlee on 2018/5/9.
//  Copyright © 2018年 Github.com. All rights reserved.
//

#import "HHBannerPageControl.h"

@interface YTPageControlDot : UIView
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, assign) CGFloat normalSize;
@property (nonatomic, assign) CGFloat selectedSize;
@property (nonatomic, assign) NSInteger index;
@end

@implementation YTPageControlDot

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _normalColor = [UIColor grayColor];
        _selectedColor = [UIColor redColor];
        _normalSize = 6.0;
        _selectedSize = 8.0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    UIColor *color = self.selected ? self.selectedColor : self.normalColor;
    CGFloat size = self.selected ? self.selectedSize : self.normalSize;
    CGRect frame = CGRectMake((CGRectGetWidth(rect) - size) / 2.0, (CGRectGetHeight(rect) - size) / 2.0, size, size);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:size/2.0];
    [color setFill];
    [path fill];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    [self setNeedsDisplay];
}

@end


#pragma mark -
#pragma mark -

@interface HHBannerPageControl()
@property (nonatomic, assign) CGFloat dotSize;
@property (nonatomic, assign) CGFloat dotSpace;
@end


@implementation HHBannerPageControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _dotSize = 10.0;
        _dotSpace = 10.0;
        _hideSinglePage = YES;
    }
    return self;
}

- (void)setTotalPage:(NSInteger)totalPage {
    _totalPage = totalPage;
    [self setupPageControl];
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    [self setupPageControl];
}

- (void)setupPageControl {
    if (self.totalPage > 0) {
        if (self.totalPage == 1 && self.hideSinglePage) {
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            return;
        }
        
        if (self.subviews.count == self.totalPage) {
            for (UIView *sub in self.subviews) {
                if ([sub isKindOfClass:[YTPageControlDot class]]) {
                    YTPageControlDot *dot = (YTPageControlDot *)sub;
                    if (dot.index == self.currentPage) {
                        dot.selected = YES;
                    }
                    else {
                        dot.selected = NO;
                    }
                }
            }
        }
        else {
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            CGFloat maxWidth = self.totalPage * self.dotSize + (self.totalPage - 1) * self.dotSpace;
            CGFloat x = (CGRectGetWidth(self.bounds) - maxWidth) / 2.0;
            CGFloat y = (CGRectGetHeight(self.bounds) - self.dotSize) / 2.0;
            CGRect frame = CGRectMake(x, y, self.dotSize, self.dotSize);
            for (NSInteger i = 0; i < self.totalPage; i++) {
                YTPageControlDot *dot = [[YTPageControlDot alloc] initWithFrame:frame];
                dot.index = i;
                if (i == self.currentPage) {
                    dot.selected = YES;
                }
                [self addSubview:dot];
                
                frame.origin.x += frame.size.width + self.dotSpace;
            }
        }
    }
    else {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}

@end
