//
//  TaskListViewController.m
//  Todo
//
//  Created by he baochen on 12-2-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TaskListViewController.h"

@implementation TaskListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];


}

- (void) showAddView {
    
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
    Task *task = (Task*)[_fetchController objectAtIndexPath:indexPath];

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
  Task *task = (Task*)[_fetchController objectAtIndexPath:indexPath];
    task.isFinish = [NSNumber numberWithBool:![task.isFinish boolValue] ];
  if ([task.isFinish boolValue]) {
    cell.imageView.image = [UIImage imageNamed:@"CheckboxDone-N.png"];
  } else {
    cell.imageView.image = [UIImage imageNamed:@"CheckboxActive-N.png"];
  }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  EditTaskViewController * viewController = [[EditTaskViewController alloc] initWithStyle:UITableViewStyleGrouped];
  viewController.delegate = self;
  viewController.editingTask = (Task*)[_fetchController objectAtIndexPath:indexPath];
  [self.navigationController pushViewController:viewController animated:YES];
  
  [viewController release];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Task Edit delegate
- (void) didFinishEditTask:(Task*)task {
  
  [self.tableView reloadData];
}
@end
