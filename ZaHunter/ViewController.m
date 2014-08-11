//
//  ViewController.m
//  ZaHunter
//
//  Created by Nicolas Semenas on 06/08/14.
//  Copyright (c) 2014 Nicolas Semenas. All rights reserved.
//

#import "ViewController.h"
#import "Pizzaria.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) NSMutableArray * pizzarias;

@property (strong,nonatomic) CLLocation * actualLocation;
@property (strong,nonatomic) CLLocationManager * myLocationManager;
@property (nonatomic) int totalTime;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pizzarias = [[NSMutableArray alloc]init];
    self.totalTime = 0;
    
    self.myLocationManager = [[CLLocationManager alloc]init];
    self.myLocationManager.delegate = self;

    [self.myLocationManager startUpdatingLocation];
    
    [self addFooter];
    

    

}


-(void) addFooter {
    
    UIView *fView = [[UIView alloc] initWithFrame:CGRectMake(0, 718, 239, 50)];
    fView.backgroundColor =[UIColor yellowColor];
    
    UILabel *yourLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
    
    [yourLabel setTextColor:[UIColor blackColor]];
    [yourLabel setBackgroundColor:[UIColor clearColor]];
    [yourLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
    yourLabel.text = [NSString stringWithFormat:@"%i",self.totalTime];
    [fView addSubview:yourLabel];
    
    self.myTableView.tableFooterView = fView;
}


- (void) calculateTotalTime{
    
    //[self getDirectionsFrom:self.actualLocation to:self.actualLocation];
}


-(void) getDirectionsFrom: (MKMapItem *) source to: (MKMapItem *) destination {
    
    MKDirectionsRequest *request = [MKDirectionsRequest new];
    
    request.source = source;
    request.destination = destination;
    
    MKDirections * directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        MKRoute * route = response.routes.firstObject;
        
        for (MKRouteStep * step in route.steps){
            self.totalTime++;
        }
        
    }];
    
}




-(void) findPizzarias{
    
    MKLocalSearchRequest * request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = @"restaurants";
    request.region = MKCoordinateRegionMakeWithDistance(self.actualLocation.coordinate, 5000, 5000);
    
    MKLocalSearch * search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {

        NSArray *mapItems = [response.mapItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
			CLLocation *locationObj1 = [(MKMapItem *)obj1 placemark].location;
			CLLocation *locationObj2 = [(MKMapItem *)obj2 placemark].location;
            
			NSNumber *distanceObj1 = [NSNumber numberWithDouble:[locationObj1 distanceFromLocation:self.actualLocation]];
			NSNumber *distanceObj2 = [NSNumber numberWithDouble:[locationObj2 distanceFromLocation:self.actualLocation]];
            
			return [distanceObj1 compare:distanceObj2];
		}];
        
		int numItems = 0;
		for (MKMapItem *mapItem in mapItems) {
			if (numItems++ < 4) {
				[self.pizzarias addObject:[[Pizzaria alloc] initWithMapItem:mapItem]];
                
			} else {
				break;
			}
		}
        
        [self.myTableView reloadData];
        [self calculateTotalTime];
        
    }];
}

#pragma mark - Table View Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    Pizzaria *thisPizzaria = [[Pizzaria alloc]init];
    thisPizzaria = self.pizzarias[indexPath.row];
    
    cell.textLabel.text = thisPizzaria.mapItem.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.02f m", [thisPizzaria.mapItem.placemark.location distanceFromLocation:self.actualLocation]];

    return cell;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.pizzarias.count;
}



#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    for (CLLocation *location in locations) {
        self.actualLocation = location;
        [self.myLocationManager stopUpdatingLocation];
        break;
    }
    
    [self findPizzarias];
}

@end