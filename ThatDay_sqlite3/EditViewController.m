//
//  EditViewController.m
//  ThatDayUniversal
//
//  Created by ZhongZhongzhong on 16/4/29.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "EditViewController.h"
@interface EditViewController()
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *myDatePicker;
@property (weak, nonatomic) IBOutlet UITextView *myTextView;
@property (weak, nonatomic) IBOutlet UIButton *downButton;



@end
@implementation EditViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *customButton;
    if (self.isModalSegue) {
        
        customButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(TopCancelButtonClicked)];
        UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50.0)];
        UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:self.titleString];
        item.rightBarButtonItem = customButton;
        [bar pushNavigationItem:item animated:YES];
        [self.view addSubview:bar];
        [self.downButton setTitle:@"Add" forState:UIControlStateNormal];
        [self.downButton addTarget:self action:@selector(downButtonAddClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        customButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(TopDownButtonClicked)];
        self.navigationItem.rightBarButtonItem = customButton;
        self.navigationItem.leftItemsSupplementBackButton = YES;
        [self.downButton setTitle:@"Delete" forState:UIControlStateNormal];
        [self.downButton addTarget:self action:@selector(downButtonDeleteClicked) forControlEvents:UIControlEventTouchUpInside];
        self.titleTextField.text = self.titleString;
        [self.myDatePicker setDate:self.date animated:YES];
        [self.myTextView setText:self.contentString];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboardAction:)];
    [tap setNumberOfTapsRequired:1];
    [tap cancelsTouchesInView];
    [self.view addGestureRecognizer:tap];
}


- (void)dismissKeyboardAction:(UITapGestureRecognizer *)sender
{
    [self.titleTextField resignFirstResponder];
    [self.myTextView resignFirstResponder];
}

#pragma mark - modal segue
//top cancel button clicked
- (void)TopCancelButtonClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//down add button clicked
- (void)downButtonAddClicked
{
//    Note *note = [[Note alloc] initWithTitle:self.titleTextField.text andContent:self.myTextView.text andDate:[self.myDatePicker date]];
//    [self.delegate addNote:note];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - show segue

- (void)TopDownButtonClicked
{
//    Note *note = [[Note alloc] initWithTitle:self.titleTextField.text andContent:self.myTextView.text andDate:[self.myDatePicker date]];
//    [self.delegate editWithNote:note];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downButtonDeleteClicked
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Are you sure to delete the note" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.delegate deleteNote];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}


@end
