//
//  AddNoteTableViewController.m
//  ThatDay_sqlite3
//
//  Created by ZhongZhongzhong on 16/5/4.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "AddNoteTableViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <Contacts/Contacts.h>

@interface AddNoteTableViewController ()<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UISwitch *locationEnableSwitch;
@property (weak, nonatomic) IBOutlet UIDatePicker *myDatePicker;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property(nonatomic, strong) CLLocationManager *locationManager;

@property(nonatomic, strong)  CLLocation *currLocation;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *weatherActivityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@end

@implementation AddNoteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboardAction:)];
    [tap setNumberOfTapsRequired:1];
    [tap cancelsTouchesInView];
    [self.view addGestureRecognizer:tap];
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 1000.0f;
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    
    [self.locationEnableSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.activityIndicator.hidden = YES;
    self.weatherActivityIndicator.hidden = YES;
    [self startRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - get weather from OpenWeatherMap
- (void)startRequest
{
    self.weatherActivityIndicator.hidden = NO;
    if (!self.weatherActivityIndicator.isAnimating) {
        [self.weatherActivityIndicator startAnimating];
    }
    NSString *path = [[NSString alloc] initWithFormat:@"/data/2.5/forecast/city?id=%@&APPID=%@",MONTREAL_KEY, OPEN_WEATHER_KEY];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"api.openweathermap.org" customHeaderFields:nil];
    MKNetworkOperation *operation = [engine operationWithPath:path];
    __weak AddNoteTableViewController *weakSelf = self;
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSData *data = [completedOperation responseData];
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *tempArray = [resultDic objectForKey:@"list"];
        NSDictionary *tempDic = [tempArray firstObject];
        NSDictionary *weatherDic = [[tempDic objectForKey:@"weather"] firstObject];
        
        NSString *mainWeather = [weatherDic objectForKey:@"main"];
        NSString *description = [weatherDic objectForKey:@"description"];
        
        NSDictionary *mainDic = [tempDic objectForKey:@"main"];
        double temp_min = [[mainDic objectForKey:@"temp_min"] doubleValue] - 272.15;
        double temp_max = [[mainDic objectForKey:@"temp_max"] doubleValue] - 272.15;
        //double temp_now = [[mainDic objectForKey:@"temp"] doubleValue] -272.15;
        NSString *cityName = [[resultDic objectForKey:@"city"] objectForKey:@"name"];
        weakSelf.weatherLabel.text = [NSString stringWithFormat:@"%@, %@, %@, temperature from %.2f to %.2f", cityName, mainWeather, description, temp_min, temp_max];
        [weakSelf.weatherActivityIndicator stopAnimating];

    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"MKNetwork request wrong : %@", [error localizedDescription]);

    }];
    [engine enqueueOperation:operation];
}

#pragma mark - CLLocationManager delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    self.currLocation = [locations lastObject];
    //[self.activityIndicator stopAnimating];
}

- (void)switchValueChanged:(UISwitch *)theSwitch
{
    if (theSwitch.on) {
        self.activityIndicator.hidden = NO;
        if (!self.activityIndicator.isAnimating) {
            [self.activityIndicator startAnimating];
        }
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        __weak AddNoteTableViewController *weakSelf = self;
        [geocoder reverseGeocodeLocation:self.currLocation
                       completionHandler:^(NSArray *placemarks, NSError *error) {
                           
                           if ([placemarks count] > 0) {
                               
                               CLPlacemark *placemark = placemarks[0];
                               
                               NSDictionary *addressDictionary =  placemark.addressDictionary;
                               
                               NSString *address = [addressDictionary
                                                    objectForKey:@"Street"];
                               address = address == nil ? @"": address;
                               
                               NSString *state = [addressDictionary
                                                  objectForKey:@"State"];
                               state = state == nil ? @"": state;
                               
                               NSString *city = [addressDictionary
                                                 objectForKey:@"City"];
                               city = city == nil ? @"": city;
                               
                               weakSelf.locationLabel.text = [NSString stringWithFormat:@"%@ %@ %@",state, address,city];
                               [weakSelf.activityIndicator stopAnimating];
                           }
                           
                       }];
    }
}

- (IBAction)addAction:(id)sender {
    Note *note = [[Note alloc] initWithTitle:self.titleTextField.text andContent:self.contentTextView.text andDate:[self.myDatePicker date] andLocation:self.locationLabel.text andWeatherInfo:self.weatherLabel.text];
    [self.delegate addNote:note];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKeyboardAction:(UITapGestureRecognizer *)sender
{
    [self.titleTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows;
    switch (section) {
        case 0:
            numberOfRows = 2;
            break;
        case 1:
            numberOfRows = 2;
            break;
        case 2:
            numberOfRows = 1;
            break;
        case 3:
            numberOfRows = 1;
            break;
        default:
            numberOfRows = 1;
            break;
    }
    return numberOfRows;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
