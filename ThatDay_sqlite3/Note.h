//
//  Note.h
//  ThatDay_sqlite3
//
//  Created by ZhongZhongzhong on 16/5/1.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//


@interface Note : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *weather;

- (id)initWithTitle:(NSString *)title andContent:(NSString *)content andDate:(NSDate *)date andLocation:(NSString *)location;
- (id)initWithTitle:(NSString *)title andContent:(NSString *)content andDate:(NSDate *)date andLocation:(NSString *)location andWeatherInfo:(NSString *)weatherInfo;
- (BOOL)isEqualToNote:(Note *)note;
@end
