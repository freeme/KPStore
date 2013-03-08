//
//  ProjectListViewController.m
//  Todo
//
//  Created by he baochen on 12-2-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ProjectListViewController.h"
#import "Project.h"
#import "TaskListViewControllerEx.h"

@interface ProjectListViewController(Private) 

- (BOOL) saveProject ;
- (void) reloadList;
- (void) closeAddView;
@end

@implementation ProjectListViewController
@synthesize fetchRequest = _fetchRequest;


- (void) dealloc {
    [_inputField release];
    [_fetchRequest release];
    [_projectArray release];
    [_coverView release];
    [_inputContainer release];
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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480-20-44)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _coverView = [[UIControl alloc] initWithFrame:CGRectMake(0, 44, 320, 480)];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0.0;
    [_coverView addTarget:self action:@selector(closeAddView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_coverView];
    _inputContainer = [[UIView alloc] initWithFrame:CGRectMake(0, -44, 320, 44)];
    _inputContainer.backgroundColor = [UIColor whiteColor];
    _inputField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 22)];
    _inputField.font = [UIFont systemFontOfSize:18];
    _inputField.delegate = self;
    //_inputField.backgroundColor = [UIColor lightGrayColor];
    [_inputContainer addSubview:_inputField];
    
    UIButton *quickAdd = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [quickAdd addTarget:self action:@selector(quickAdd) forControlEvents:UIControlEventTouchUpInside];
    quickAdd.center = CGPointMake(300, 22);
    [_inputContainer addSubview:quickAdd];

    [self.view addSubview:_inputContainer];
    

    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAddView)] autorelease];
    
//    KPAppDelegate *appDelegate = [KPAppDelegate shareDelegate];
//    NSManagedObjectContext *context = appDelegate.managedObjectContext;
//    
    NSError *error = nil;
//    NSArray *array = [context executeFetchRequest:_fetchRequest error:&error];
  NSArray *array = [Project executeFetchRequest:_fetchRequest error:&error];
    _projectArray = [[NSMutableArray alloc] initWithArray:array];
    [_tableView reloadData];
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [_tableView reloadData];
}

- (void) reloadList {
//    KPAppDelegate *appDelegate = [KPAppDelegate shareDelegate];
//    NSManagedObjectContext *context = appDelegate.managedObjectContext;
//    NSArray *array = [context executeFetchRequest:_fetchRequest error:NULL];
  NSArray *array = [Project executeFetchRequest:_fetchRequest error:NULL];
    if (_projectArray) {
        [_projectArray release];
    }
    _projectArray = [[NSMutableArray alloc] initWithArray:array];
    [_tableView reloadData];
}

- (void) showAddView {
    self.title = @"新建项目";
    [_inputField becomeFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    _inputContainer.frame = CGRectMake(0, 0, 320, 44);
    _tableView.scrollEnabled = NO;
    _coverView.alpha = 0.7;
    //self.tableView.userInteractionEnabled = NO;
    [UIView commitAnimations];
}

- (void) closeAddView {
    self.title = @"项目";
    _inputField.text = @"";
    [_inputField resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    _inputContainer.frame = CGRectMake(0, -44, 320, 44);
    _tableView.scrollEnabled = YES;
    _coverView.alpha = 0.0;
    [UIView commitAnimations];
}

- (void) quickAdd {
    BOOL result = [self saveProject];
    if (result) {
        _inputField.text = @"";
    }
}

- (BOOL) saveProject {
    if ([_inputField.text length] >0) {
        BOOL result = [Project addProjectWithName:_inputField.text];
        if (result) {
            [self reloadList];
            return result;
        }
    } 
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL result = [self saveProject];
    if (result) {
        [self closeAddView];
    }
    return result;
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
    return [_projectArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    Project *project = (Project*)[_projectArray objectAtIndex:indexPath.row];
    // Configure the cell...
    cell.textLabel.text = project.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [project.tasks count]];
    return cell;
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
        // Delete the row from the data source

        //从DB中删除
//        KPAppDelegate *appDelegate = [KPAppDelegate shareDelegate];
//        NSManagedObjectContext *context = appDelegate.managedObjectContext;
//        [context deleteObject:[_projectArray objectAtIndex:indexPath.row]];
//        [appDelegate saveContext];
      Project *project = (Project*)[_projectArray objectAtIndex:indexPath.row];
      [project deleteSelf];
      [project save];
        //从内存中删除
        [_projectArray removeObjectAtIndex:indexPath.row];
        //从表格中删除Cell
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskListViewControllerEx *viewController = [[TaskListViewControllerEx alloc] init];
     viewController.project = [_projectArray objectAtIndex:indexPath.row];
     [self.navigationController pushViewController:viewController animated:YES];
     [viewController release];
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
