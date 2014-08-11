//
//  Pizzaria.h
//  ZaHunter
//
//  Created by Nicolas Semenas on 06/08/14.
//  Copyright (c) 2014 Nicolas Semenas. All rights reserved.
//

#import <MapKit/MapKit.h>


@interface Pizzaria : NSObject

@property MKMapItem *mapItem;

- (instancetype)initWithMapItem:(MKMapItem *)mapItem;
- (CLLocationDistance)distanceFromLocation:(CLLocation *)location;

@end
