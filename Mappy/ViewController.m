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

@property (strong, nonatomic) MKDirections* directions;
@property (strong, nonatomic) UIActivityIndicatorView* activityIndicator;
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
    
    UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityIndicator.center = self.view.center;
    activityIndicator.color = [UIColor darkGrayColor];
    [self.mapView addSubview:activityIndicator];
    
    self.activityIndicator = activityIndicator;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)goToMarkerAction:(UIBarButtonItem *)sender {
    
    if (!self.destinationMarker) {
        
        [self showAlertWithTitle:@"Внимание!" andMessage:@"Сначала выберите город"];
        return;
    }
    
    [self.activityIndicator startAnimating];
    
    NSArray* annotations = [NSArray arrayWithObjects:self.destinationMarker, self.mapView.userLocation, nil];
    
    CLLocationCoordinate2D coordinate = self.destinationMarker.coordinate;
    
    MKDirectionsRequest* request = [[MKDirectionsRequest alloc] init];
    
    request.source = [MKMapItem mapItemForCurrentLocation];
    
    request.destination = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
    
    request.transportType = MKDirectionsTransportTypeAutomobile;
    
    self.directions = [[MKDirections alloc] initWithRequest:request];
    
    __weak ViewController* weakSelf = self;
    
    [self.directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        
        [weakSelf.mapView removeOverlays:[weakSelf.mapView overlays]];
        
        NSMutableArray* array = [NSMutableArray array];
        
        for (MKRoute* route in response.routes) {
            
            [array addObject:route.polyline];
            
        }
        
        [weakSelf.activityIndicator stopAnimating];
        
        self.trashBarButtonItem.enabled = YES;
        
        [weakSelf showDirectionWithAnnotation:annotations];
        
        [weakSelf.mapView addOverlays:array level:MKOverlayLevelAboveRoads];
        
    }];
    
}

- (IBAction)removeOverlaysAction:(UIBarButtonItem *)sender {
    
    self.trashBarButtonItem.enabled = NO;
    self.destinationMarker = nil;
    [self.mapView removeOverlays:[self.mapView overlays]];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"Search"]) {
        
        SearchTableViewController* searchController = [segue destinationViewController];
        [searchController setMarkers:self.markers];
        [searchController setDestinationMarker:self.destinationMarker];
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

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        
        MKPolylineRenderer* renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        
        renderer.strokeColor = [UIColor colorWithRed:0.f green:0.5f blue:1.f alpha:0.9f];
        renderer.lineWidth = 5.f;
        
        return renderer;
    }
    
    return nil;
}

#pragma mark - SearchDelegate

- (void) setDestination:(Marker*) destinationMarker {
    
    self.destinationMarker = destinationMarker;
    
}

#pragma mark - Support methods

- (void) showDirectionWithAnnotation:(NSArray*) annotations {
    
    MKMapRect zoomRect = MKMapRectNull;
    
    for (id <MKAnnotation> annotation in annotations) {
        
        Marker* pin = annotation;
        
        CLLocationCoordinate2D location = pin.coordinate;
        
        MKMapPoint center = MKMapPointForCoordinate(location);
        
        static double delta = 20000;
        
        MKMapRect rect = MKMapRectMake(center.x - delta, center.y - delta, delta * 2, delta * 2);
        
        zoomRect = MKMapRectUnion(zoomRect, rect);
        
    }
    
    zoomRect = [self.mapView mapRectThatFits:zoomRect];
    
    [self.mapView setVisibleMapRect:zoomRect
                        edgePadding:UIEdgeInsetsMake(50, 50, 50, 50)
                           animated:YES];
    
}

- (void) showAlertWithTitle:(NSString*) title andMessage:(NSString*) message {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    
    [alert addAction:okAction];
    
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
    
}

@end
