//
//  ThatDayUniversalCollectionViewController.m
//  ThatDayUniversal
//
//  Created by ZhongZhongzhong on 16/4/29.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "ThatDayUniversalCollectionViewController.h"
#import "Note.h"
#import "NoteList.h"
#import "NoteBL.h"
#import "NoteCell.h"
#import "DetailViewController.h"
#import "AddNoteTableViewController.h"
@interface ThatDayUniversalCollectionViewController ()<DetailVCDelegate, AddNoteVCDelegate, UISearchBarDelegate>
@property (strong, nonatomic) NSMutableArray *listNote;
@property (strong, nonatomic) NoteBL *noteBL;
@property (strong, nonatomic) NSIndexPath *selectedPath;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *filterNotes;

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSUInteger)scope;

@end

@implementation ThatDayUniversalCollectionViewController

static NSString * const reuseIdentifier = @"NoteCell";
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations
     self.clearsSelectionOnViewWillAppear = NO;
    
    UIBarButtonItem *addDateButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDateButtonClicked)];
    self.navigationItem.rightBarButtonItem = addDateButton;
    self.noteBL = [[NoteBL alloc] init];
    self.listNote = [self.noteBL getAllNote];
    [self setSearchBar];
    
    [self filterContentForSearchText:@"" scope:0];
}

- (void)dealloc
{
    [self removeObservers];
}

#pragma mark - set search bar
- (void)setSearchBar
{
    CGFloat yOffset = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, yOffset, CGRectGetWidth(self.collectionView.frame), 44)];
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.delegate = self;
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.tintColor = [UIColor whiteColor];
    self.searchBar.barTintColor = [UIColor whiteColor];
    self.searchBar.placeholder = @"search notes by title";
    [self.searchBar sizeToFit];
    [self addObservers];
    if (![self.searchBar isDescendantOfView:self.view]) {
        [self.view addSubview:self.searchBar];
    }
}


- (NSMutableArray *)listNote
{
    if (!_listNote) {
        _listNote = [[NSMutableArray alloc] init];
    }
    return  _listNote;
}

- (void)addDateButtonClicked
{
    [self performSegueWithIdentifier:@"toAddNoteSegue" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - fliter the notes
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSUInteger)scope
{
    if ([searchText length] == 0) {
        self.filterNotes = [NSMutableArray arrayWithArray:self.listNote];
    }else{
        NSPredicate *scopePredicate;
        NSArray *tempArray ;
        if (scope == 1) {
            scopePredicate = [NSPredicate predicateWithFormat:@"SELF.title contains[cd] %@",searchText];
            tempArray =[self.listNote filteredArrayUsingPredicate:scopePredicate];
            self.filterNotes = [NSMutableArray arrayWithArray:tempArray];
        }else{
            self.filterNotes = [NSMutableArray arrayWithArray:self.listNote];
        }
    }
}

#pragma mark --UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.searchBar.showsScopeBar = TRUE;
    [self.searchBar sizeToFit];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.showsScopeBar = NO;
    [self.searchBar sizeToFit];
    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //filter all
    [self filterContentForSearchText:self.searchBar.text scope:0];
    self.searchBar.showsScopeBar = NO;
    [self.searchBar sizeToFit];
    [self.collectionView reloadData];
    [self.searchBar resignFirstResponder];
}

//when text changes
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filterContentForSearchText:self.searchBar.text scope:1];
    [self.collectionView reloadData];
}

#pragma mark - observer
- (void)addObservers{
    [self.collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}
- (void)removeObservers{
    [self.collectionView removeObserver:self forKeyPath:@"contentOffset" context:Nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UICollectionView *)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"] && object == self.collectionView ) {
        self.searchBar.frame = CGRectMake(self.searchBar.frame.origin.x,
                                          self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height,
                                          self.searchBar.frame.size.width,
                                          self.searchBar.frame.size.height);
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toDetailSegue"]) {
        DetailViewController *editVC;
        if ([segue.destinationViewController isKindOfClass:[DetailViewController class]]) {
            editVC = (DetailViewController *)segue.destinationViewController;
            
        }else if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]){
            editVC = (DetailViewController *)[(UINavigationController *)segue.destinationViewController topViewController];
        }
        NSIndexPath *path = [self.collectionView indexPathForCell:sender];
        Note *note = self.listNote[path.row];
        self.selectedPath = path;
        editVC.titleString = note.title;
        editVC.date = note.date;
        editVC.locationString = note.location;
        editVC.contentString = note.content;
        editVC.weatherString = note.weather;
        editVC.delegate = self;
    }else if ([segue.identifier isEqualToString:@"toAddNoteSegue"]){
        AddNoteTableViewController *addNoteVC;
        if ([segue.destinationViewController isKindOfClass:[AddNoteTableViewController class]]) {
            addNoteVC = (AddNoteTableViewController *)segue.destinationViewController;
            
        }else if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]){
            addNoteVC = (AddNoteTableViewController *)[(UINavigationController *)segue.destinationViewController topViewController];
        }
        addNoteVC.delegate = self;
        self.selectedPath = nil;
    }
}

- (void)getUserSettings
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    self.title = [user stringForKey:@"multivalue_preference"];
}

#pragma mark - Add note VC delegate
- (void)addNote:(Note *)note
{
    [self.listNote addObject:note];
    [self.noteBL addNote:note];
    [self filterContentForSearchText:@"" scope:0];
    [self.collectionView reloadData];
}

#pragma mark - DetailVC delegate


- (void)editWithNote:(Note *)note
{
    [self.listNote removeObjectAtIndex:self.selectedPath.row];
    [self.listNote insertObject:note atIndex:self.selectedPath.row];
    [self.noteBL editNote:note];
    [self filterContentForSearchText:@"" scope:0];
    [self.collectionView reloadData];
}

- (void)deleteNote
{
    Note *deleteNote = self.listNote[self.selectedPath.row];
    [self.listNote removeObjectAtIndex:self.selectedPath.row];
    [self.noteBL deleteNote:deleteNote];
    [self filterContentForSearchText:@"" scope:0];
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filterNotes.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedPath = indexPath;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NoteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    Note *note = self.filterNotes[indexPath.row];
    cell.titleLabel.text = note.title;
    cell.dateLabel.text = [ThatDayUniversalCollectionViewController getStringFromDate:note.date];
    // Configure the cell
    [cell setLabelsWithFontName:LABEL_FONT andSize:16.0];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark - UICollectionViewFlow delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(200.0, 100.0);
}

#pragma mark - self define method
+ (NSString *)getStringFromDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd/MM/yyyy hh:mm a"];
    NSString *dateString = [format stringFromDate:date];
    return dateString;
}

@end
