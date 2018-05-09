//
//  HHBannerView.h
//  HHBanner
//
//  Created by bruthlee on 2018/5/9.
//  Copyright © 2018年 Github.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HHBannerViewBlock)(NSInteger index, NSString *url);

@interface HHBannerView : UIView

- (void)reloadBanners:(NSArray *)banners touchBlock:(HHBannerViewBlock)block;

@end
