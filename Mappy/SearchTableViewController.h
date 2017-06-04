//
//  SearchTableViewController.h
//  Mappy
//
//  Created by iMac on 04.06.17.
//  Copyright © 2017 hata. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Marker;
@protocol SearchDelegate;

@interface SearchTableViewController : UITableViewController

@property (strong, nonatomic) NSArray* markers;
@property (strong, nonatomic) Marker* destinationMarker;
@property (strong, nonatomic) id<SearchDelegate> delegate;

@end

@protocol SearchDelegate <NSObject>

@property (strong, nonatomic) Marker* destinationMarker;

- (void) setDestination:(Marker*) destinationMarker;

@end
