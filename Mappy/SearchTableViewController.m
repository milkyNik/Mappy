//
//  SearchTableViewController.m
//  Mappy
//
//  Created by iMac on 04.06.17.
//  Copyright © 2017 hata. All rights reserved.
//

#import "SearchTableViewController.h"
#import "Marker.h"
#import "ViewController.h"

@interface SearchTableViewController ()


@end

@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.markers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    Marker* marker = self.markers[indexPath.row];
    
    cell.textLabel.text = marker.title;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    for (int i = 0; i < [self.markers count]; i++) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:newIndexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    Marker* destination = self.markers[indexPath.row];
    
    self.destinationMarker = destination;
    
    [self.delegate setDestination:destination];
    
}


- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.destinationMarker isEqual:self.markers[indexPath.row]]) {
        return UITableViewCellAccessoryCheckmark;
    }
    
    return UITableViewCellAccessoryNone;
    
}










@end
