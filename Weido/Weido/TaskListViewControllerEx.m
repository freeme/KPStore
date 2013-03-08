//
//  TaskListViewControllerEx.m
//  Todo
//
//  Created by he baochen on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TaskListViewControllerEx.h"
#import "Task.h"

@implementation TaskListViewControllerEx
@synthesize project = _project;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAddView)] autorelease];
    self.title = _project.name;
}

- (void) showAddView {
    EditTaskViewController * viewController = [[EditTaskViewController alloc] initWithStyle:UITableViewStyleGrouped];
    viewController.createdInProject = _project;
    viewController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentModalViewController:navController animated:YES];
    
    [viewController release];
    [navController release];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_project.tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        UIImage *img = [UIImage imageNamed:@"CheckboxActive-N.png"];
        cell.imageView.image = img;
        UIControl *markControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
        [markControl addTarget:self action:@selector(markAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.imageView.userInteractionEnabled = YES;
        [cell.imageView addSubview:markControl];
        [markControl release];
    }
    Task *task = [_project.tasks objectAtIndex:indexPath.row];
    cell.textLabel.text = task.title;
  if ([task.isFinish boolValue]) {
    cell.imageView.image = [UIImage imageNamed:@"CheckboxDone-N.png"];
  } else {
    cell.imageView.image = [UIImage imageNamed:@"CheckboxActive-N.png"];
  }
    return cell;
}

- (void) markAction:(id)sender {
  UIControl *control = (UIControl*)sender;
  //推荐的解决方案
  CGPoint originInTable = [control convertPoint:control.frame.origin toView:self.tableView];
  NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:originInTable];
  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
  Task *task = [_project.tasks objectAtIndex:indexPath.row];
  task.isFinish = [NSNumber numberWithBool:![task.isFinish boolValue]];
  if ([task.isFinish boolValue]) {
    cell.imageView.image = [UIImage imageNamed:@"CheckboxDone-N.png"];
  } else {
    cell.imageView.image = [UIImage imageNamed:@"CheckboxActive-N.png"];
  }
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } 
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditTaskViewController * viewController = [[EditTaskViewController alloc] initWithStyle:UITableViewStyleGrouped];
    viewController.createdInProject = _project;
    viewController.delegate = self;
    viewController.editingTask = (Task*)[_project.tasks objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
    
    [viewController release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Edit Task delegate
- (void) didFinishEditTask:(Task*)task {
    [self.tableView reloadData];
}

@end
