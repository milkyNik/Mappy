//
//  ViewController.h
//  Mappy
//
//  Created by iMac on 03.06.17.
//  Copyright © 2017 hata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchTableViewController.h"

@class MKMapView;
@class Marker;

@interface ViewController : UIViewController <SearchDelegate>

@property (strong, nonatomic) NSArray* markers;
@property (strong, nonatomic) Marker* destinationMarker;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)goToMarkerAction:(UIBarButtonItem *)sender;

@end

