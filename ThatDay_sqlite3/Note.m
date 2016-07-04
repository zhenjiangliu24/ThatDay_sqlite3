//
//  Note.m
//  ThatDay_sqlite3
//
//  Created by ZhongZhongzhong on 16/5/1.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "Note.h"

@implementation Note
- (id)initWithTitle:(NSString *)title andContent:(NSString *)content andDate:(NSDate *)date andLocation:(NSString *)location
{
    self = [super init];
    if (self) {
        self.title = title;
        self.content = content;
        self.date = date;
        self.location = location;
        self.weather = @"No weather Info";
    }
    return self;
}

- (id)initWithTitle:(NSString *)title andContent:(NSString *)content andDate:(NSDate *)date andLocation:(NSString *)location andWeatherInfo:(NSString *)weatherInfo
{
    self = [super init];
    if (self) {
        self.title = title;
        self.content = content;
        self.date = date;
        self.location = location;
        self.weather = weatherInfo;
    }
    return self;
}

- (BOOL)isEqualToNote:(Note *)note
{
    return [self.date isEqualToDate:note.date];
}
@end
