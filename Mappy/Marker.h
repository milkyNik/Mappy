//
//  Marker.h
//  Mappy
//
//  Created by iMac on 04.06.17.
//  Copyright © 2017 hata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Marker : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, nullable) NSString *title;

@end
