//
//  AddNoteTableViewController.h
//  ThatDay_sqlite3
//
//  Created by ZhongZhongzhong on 16/5/4.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "Note.h"

@protocol AddNoteVCDelegate <NSObject>
- (void)addNote:(Note *)note;
@end
@interface AddNoteTableViewController : UITableViewController
@property (weak, nonatomic) id<AddNoteVCDelegate> delegate;
@end
