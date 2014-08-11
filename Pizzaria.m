//
//  Pizzaria.m
//  ZaHunter
//
//  Created by Nicolas Semenas on 06/08/14.
//  Copyright (c) 2014 Nicolas Semenas. All rights reserved.
//

#import "Pizzaria.h"

@implementation Pizzaria



- (instancetype)initWithMapItem:(MKMapItem *)mapItem
{
	self = [super init];
	self.mapItem = mapItem;
	return self;
}

- (CLLocationDistance)distanceFromLocation:(CLLocation *)location
{
	return [self.mapItem.placemark.location distanceFromLocation:location];
}

@end