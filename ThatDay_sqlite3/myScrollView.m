//
//  myScrollView.m
//  ThatDay_sqlite3
//
//  Created by ZhongZhongzhong on 16/5/5.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "myScrollView.h"

@implementation myScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated {
    // restrict movement to vertical only
    CGPoint newOffset = CGPointMake(0, contentOffset.y);
    [super setContentOffset:newOffset animated:animated];
}

- (void)setContentOffset:(CGPoint)contentOffset {
    // restrict movement to vertical only
    CGPoint newOffset = CGPointMake(0, contentOffset.y);
    [super setContentOffset:newOffset];
}

@end
