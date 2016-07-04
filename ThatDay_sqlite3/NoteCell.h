//
//  NoteCell.h
//  ThatDayUniversal
//
//  Created by ZhongZhongzhong on 16/4/29.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//


@interface NoteCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
- (void)setLabelsWithFontName:(NSString *)fontName andSize:(CGFloat)size;

@end
