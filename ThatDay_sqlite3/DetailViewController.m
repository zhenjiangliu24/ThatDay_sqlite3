//
//  DetailViewController.m
//  ThatDay_sqlite3
//
//  Created by ZhongZhongzhong on 16/5/4.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *customButton;
    customButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(TopDownButtonClicked)];
    self.navigationItem.rightBarButtonItem = customButton;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    [self.downButton setTitle:@"Delete" forState:UIControlStateNormal];
    [self.downButton addTarget:self action:@selector(downButtonDeleteClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboardAction:)];
    [tap setNumberOfTapsRequired:1];
    [tap cancelsTouchesInView];
    [self.view addGestureRecognizer:tap];
    
    self.titleText.text = self.titleString;
    self.dataLabel.text = [DetailViewController getStringFromDate:self.date];
    self.locationLabel.text = self.locationString;
    self.weatherLabel.text = self.weatherString;
    [self.contentTextView setText:self.contentString];
}

//dismiss key board
- (void)dismissKeyboardAction:(UITapGestureRecognizer *)sender
{
    [self.titleText resignFirstResponder];
    [self.contentTextView resignFirstResponder];
}

// top, finish editing
- (void)TopDownButtonClicked
{
    Note *note = [[Note alloc] initWithTitle:self.titleText.text andContent:self.contentTextView.text andDate:self.date andLocation:self.locationString];
    [self.delegate editWithNote:note];
    [self.navigationController popViewControllerAnimated:YES];
}
// down, delete note
- (void)downButtonDeleteClicked
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Are you sure to delete the note" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.delegate deleteNote];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{
        [alertVC setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [alertVC
                                                         popoverPresentationController];
        popPresenter.sourceView = self.downButton;
        popPresenter.sourceRect = self.downButton.bounds;
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (NSString *)getStringFromDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd/MM/yyyy hh:mm a"];
    NSString *dateString = [format stringFromDate:date];
    return dateString;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
