//
//  SelectProjectViewController.m
//  Todo
//
//  Created by he baochen on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SelectProjectViewController.h"


@implementation SelectProjectViewController
@synthesize curProject = _currentProject;
@synthesize delegate = _delegate;

- (void) dealloc {
    [_currentProject release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
    self.title = @"选择项目";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Project *project = (Project*)[_fetchController objectAtIndexPath:indexPath];
    cell.textLabel.text = project.name;
    if (project.objectID == _currentProject.objectID) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

//overwrite super method
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Project *project = (Project*)[_fetchController objectAtIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    if ([_delegate respondsToSelector:@selector(didSelectedProject:)]) {
        [_delegate didSelectedProject:project];
    }
  [self.navigationController popViewControllerAnimated:YES];
}



@end
