//
//  NoteCell.m
//  ThatDayUniversal
//
//  Created by ZhongZhongzhong on 16/4/29.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "NoteCell.h"

@implementation NoteCell
- (void)setLabelsWithFontName:(NSString *)fontName andSize:(CGFloat)fontSize
{
    self.titleLabel.font = [UIFont fontWithName:fontName size:fontSize];
    self.dateLabel.font = [UIFont fontWithName:fontName size:fontSize];
}
@end
