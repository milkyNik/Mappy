//
//  ViewController.m
//  Mappy
//
//  Created by iMac on 03.06.17.
//  Copyright © 2017 hata. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "Marker.h"

@interface ViewController ()

@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];

    Marker* marker_1 = [[Marker alloc] init];
    Marker* marker_2 = [[Marker alloc] init];
    Marker* marker_3 = [[Marker alloc] init];
    
    marker_1.title = @"Киев";
    CLLocationCoordinate2D coordinate_1;
    coordinate_1.latitude = 50.45466f;
    coordinate_1.longitude = 30.5238f;
    [marker_1 setCoordinate:coordinate_1];
    
    marker_2.title = @"Львов";
    CLLocationCoordinate2D coordinate_2;
    coordinate_2.latitude = 49.83826f;
    coordinate_2.longitude = 24.02324f;
    [marker_2 setCoordinate:coordinate_2];
    
    marker_3.title = @"Днепр";
    CLLocationCoordinate2D coordinate_3;
    coordinate_3.latitude = 48.45000f;
    coordinate_3.longitude = 34.98333f;
    [marker_3 setCoordinate:coordinate_3];
    
    self.markers = [NSArray arrayWithObjects:marker_1, marker_2, marker_3, nil];
    

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)goToMarkerAction:(UIBarButtonItem *)sender {
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"Search"]) {
        
        SearchTableViewController* searchController = [segue destinationViewController];
        [searchController setMarkers:self.markers];
        [searchController setDelegate:self];
        
    }
    
}

#pragma mark - MKMapViewDelegate

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString* identifier = @"Marker";
    
    MKPinAnnotationView* marker = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (!marker) {
        
        marker = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        marker.animatesDrop = YES;
        marker.pinTintColor = [UIColor greenColor];
        marker.canShowCallout = YES;
        
    } else {
        
        marker.annotation = annotation;
        
    }
    
    return marker;
    
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {
    
    [self.mapView addAnnotations:self.markers];
    
}

#pragma mark - SearchDelegate

- (void) setDestination:(Marker*) destinationMarker {
    
    self.destinationMarker = destinationMarker;
    
}




@end
