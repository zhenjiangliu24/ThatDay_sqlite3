//
//  NoteBL.m
//  ThatDay_sqlite3
//
//  Created by ZhongZhongzhong on 16/5/1.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "NoteBL.h"

@implementation NoteBL
- (NSMutableArray *)addNote:(Note *)note
{
    NoteList *listObj = [NoteList shareManager];
    [listObj addNote:note];
    return [listObj getAllNotes];
}

- (NSMutableArray *)editNote:(Note *)note
{
    NoteList *listObj = [NoteList shareManager];
    [listObj editWithNote:note];
    return [listObj getAllNotes];
}

- (NSMutableArray *)deleteNote:(Note *)note
{
    NoteList *listObj = [NoteList shareManager];
    [listObj deleteNote:note];
    return [listObj getAllNotes];
}

- (NSMutableArray *)getAllNote
{
    NoteList *listObj = [NoteList shareManager];
    return [listObj getAllNotes];
}
@end
