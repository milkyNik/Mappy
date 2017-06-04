//
//  ViewController.h
//  Mappy
//
//  Created by iMac on 03.06.17.
//  Copyright © 2017 hata. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKMapView;
@class Marker;

@interface ViewController : UIViewController 

@property (strong, nonatomic) NSArray* markers;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)goToMarkerAction:(UIBarButtonItem *)sender;

@end

