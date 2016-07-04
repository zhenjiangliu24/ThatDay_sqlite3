//
//  DetailViewController.h
//  ThatDay_sqlite3
//
//  Created by ZhongZhongzhong on 16/5/4.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "Note.h"

@protocol DetailVCDelegate <NSObject>

- (void)editWithNote:(Note *)note;
- (void)deleteNote;
@end

@interface DetailViewController : UIViewController
@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *locationString;
@property (strong, nonatomic) NSString *contentString;
@property (strong, nonatomic) NSString *weatherString;
@property (weak, nonatomic) id<DetailVCDelegate> delegate;
@end
