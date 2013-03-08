//
//  RootViewController.m
//  Todo
//
//  Created by he baochen on 12-2-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "TaskListViewController.h"
#import "ProjectListViewController.h"
#import "FetchRequestFactory.h"
#import "EditTaskViewController.h"
#import "KPStore.h"

@interface RootViewController(Private) 

- (BOOL) saveTask;

@end

@implementation RootViewController

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    
    //KPAppDelegate *appDelegate = [KPAppDelegate shareDelegate];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(objectsDidChanged:)
//                                                 name:NSManagedObjectContextObjectsDidChangeNotification
//                                               object:appDelegate.managedObjectContext];//设置这个参数有什么好处？大家可以想一下
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(objectsDidChanged:)
                                                 name:NSManagedObjectContextObjectsDidChangeNotification
                                               object:[KPStore sharedStore].managedObjectContext];
  }
  return self;
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [_inputField release];
  [_inboxFetchRequest release];
  [_todayFetchRequest release];
  [_projectFetchRequest release];
  [_finishFetchRequest release];
  [super dealloc];
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
  
  // Uncomment the following line to preserve selection between presentations.
  self.clearsSelectionOnViewWillAppear = YES;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"新建任务" style:UIBarButtonItemStyleBordered target:self action:@selector(showAddTaskView)] autorelease];
  
  self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"新建项目" style:UIBarButtonItemStyleBordered target:self action:@selector(showAddListView)] autorelease];
  
  _inputField = [[UITextField alloc] initWithFrame:CGRectMake(6, 10, 240, 22)];
  _inputField.font = [UIFont systemFontOfSize:18];
  //_inputField.backgroundColor = [UIColor lightGrayColor];
  _inputField.placeholder = @"在此添加新任务";
  _inputField.delegate = self;
  
  _inboxFetchRequest = [[FetchRequestFactory inboxTaskFetchRequest] retain];
  _todayFetchRequest = [[FetchRequestFactory todayTaskFetchRequest] retain];
  _projectFetchRequest = [[FetchRequestFactory defaultProjectFetchRequest] retain];
  _finishFetchRequest = [[FetchRequestFactory finishTaskFetchRequest] retain];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  if (_needReloadData) {
    [self.tableView reloadData];
    _needReloadData = NO;
  }
}

- (void) quickAddAction {
  [self saveTask];
}

- (void) objectsDidChanged:(NSNotification*) notification {
  _needReloadData = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  BOOL result = [self saveTask];
  if (result) {
    [_inputField resignFirstResponder];
  }
  
  return result;
}

- (BOOL) saveTask {
  if ([_inputField.text length] > 0) {
    //KPAppDelegate *appDelegate = [KPAppDelegate shareDelegate];
//    Task *newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:appDelegate.managedObjectContext];
    Task *newTask = (Task*)[Task createNewObject];
    newTask.title = _inputField.text;
    newTask.createDate = [NSDate date];
    newTask.dueDate = [NSDate date]; //简单实现一下
    [newTask save];
    BOOL result = YES;//TODO: [appDelegate saveContext];
    if (result) {
      _inputField.text = @"";
      [self.tableView reloadData];
      return result;
    }
  } 
  return NO;
}

- (void) showAddTaskView {
  
  EditTaskViewController * viewController = [[EditTaskViewController alloc] initWithStyle:UITableViewStyleGrouped];
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
  viewController.delegate = self;
  [self presentModalViewController:navController animated:YES];  
  [viewController release];
  [navController release];
}

- (void) showAddListView {
  ProjectListViewController *listViewController = [[ProjectListViewController alloc] init];
  listViewController.title = @"项目";
  listViewController.fetchRequest = [FetchRequestFactory defaultProjectFetchRequest];
  [self.navigationController pushViewController:listViewController animated:YES];
  [listViewController showAddView];
  [listViewController release];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  
  // Return the number of sections.
  return SectionTypeCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
  // Return the number of rows in the section.
  NSInteger rowCount = 1;
  return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    
    if (indexPath.section == SectionTypeInput) {
      UIButton *quickAdd = [UIButton buttonWithType:UIButtonTypeContactAdd];
      [quickAdd addTarget:self action:@selector(quickAddAction) forControlEvents:UIControlEventTouchUpInside];
      quickAdd.center = CGPointMake(280, 22);
      [cell.contentView addSubview:quickAdd];
      [cell.contentView addSubview:_inputField];
    } else {
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
  }
  
  //KPAppDelegate *appDelegate = [KPAppDelegate shareDelegate];
  switch (indexPath.section) {
    case SectionTypeInbox:{
      cell.textLabel.text = @"整理箱";
      NSInteger count = [[KPStore sharedStore].managedObjectContext countForFetchRequest:_inboxFetchRequest error:NULL];
      cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",count ];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
      break;        
    case SectionTypeTime:{
      cell.textLabel.text = @"今天";
      NSInteger count = [[KPStore sharedStore].managedObjectContext countForFetchRequest:_todayFetchRequest error:NULL];
      cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",count ];
    }
      break;        
    case SectionTypeProject:{
      cell.textLabel.text = @"项目";
      NSInteger count = [[KPStore sharedStore].managedObjectContext countForFetchRequest:_projectFetchRequest error:NULL];
      cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",count ];
    }
      break; 
    case SectionTypeFinish:{
      cell.textLabel.text = @"已完成";
      NSInteger count = [[KPStore sharedStore].managedObjectContext countForFetchRequest:_finishFetchRequest error:NULL];
      cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",count ];
    }
      break;
      
    default:
      break;
  }
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.section) {
    case SectionTypeInbox:{
      TaskListViewController *viewController = [[TaskListViewController alloc] init];
      viewController.title = @"整理箱";;
      viewController.fetchRequest = _inboxFetchRequest;
      [self.navigationController pushViewController:viewController animated:YES];
      [viewController release];
    }
      break;
    case SectionTypeTime:{
      TaskListViewController *viewController = [[TaskListViewController alloc] init];
      viewController.title = @"今天";;
      viewController.fetchRequest = _todayFetchRequest;
      [self.navigationController pushViewController:viewController animated:YES];
      [viewController release];
    }
      break;
    case SectionTypeFinish:{
      TaskListViewController *viewController = [[TaskListViewController alloc] init];
      viewController.title = @"已完成";;
      viewController.fetchRequest = _finishFetchRequest;
      [self.navigationController pushViewController:viewController animated:YES];
      [viewController release];
    }
      break;
    case SectionTypeProject:{
      
      ProjectListViewController *viewController = [[ProjectListViewController alloc] init];
      viewController.title = @"项目";;
      viewController.fetchRequest = _projectFetchRequest;
      [self.navigationController pushViewController:viewController animated:YES];
      [viewController release];
    }
      break;
    default:
      break;
  }
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Edit Task delegate

- (void) didFinishEditTask:(Task*)task {
  
  [self.tableView reloadData];
}

//界面滚动，键盘自动消失
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat moveY = fabs(scrollView.contentOffset.y);
  if (moveY > 20) {
    [_inputField resignFirstResponder];
  }
}

@end
