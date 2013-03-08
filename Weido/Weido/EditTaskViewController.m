//
//  EditTaskViewController.m
//  Todo
//
//  Created by he baochen on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EditTaskViewController.h"
#import "FetchRequestFactory.h"

@implementation EditTaskViewController
@synthesize editingTask = _editingTask;
@synthesize createdInProject = _createdInProject;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc {
    [_taskTextField release];
    [_taskNoteField release];
    [_editingTask release];
    [_createdInProject release];
    [super dealloc];
}

- (void)setEditingTask:(Task *)editingTask {
    if (_editingTask != editingTask) {
        [_editingTask release];
        _editingTask = [editingTask retain];
        if (_editingTask) {
            _editingMode = YES;
            self.title = @"编辑任务";
        } else {
            _editingMode = NO;
            self.title = @"新建任务";
        }
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_editingMode) {
        self.title = @"编辑任务";
    } else {
        self.title = @"新建任务";
    }
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTask)] autorelease];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(close)] autorelease];
    
    _taskTextField = [[UITextField alloc] initWithFrame:CGRectMake(6, 10, 280, 22)];
    _taskTextField.font = [UIFont systemFontOfSize:18];
    //_inputField.backgroundColor = [UIColor lightGrayColor];
    _taskTextField.placeholder = @"在此添加新任务";
    [_taskTextField becomeFirstResponder];
    
    _taskNoteField = [[UITextField alloc] initWithFrame:CGRectMake(6, 10, 280, 22)];
    _taskNoteField.font = [UIFont systemFontOfSize:18];
    //_inputField.backgroundColor = [UIColor lightGrayColor];
    _taskNoteField.placeholder = @"备注";
}

- (void) close {
    if (_editingMode) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void) saveTask {
    if ([_taskTextField.text length] >0) {
        //KPAppDelegate *appDelegate = [KPAppDelegate shareDelegate];
        Task *tempTask = nil;
        if (_editingMode) {
            tempTask = _editingTask;
        } else {
//            tempTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:appDelegate.managedObjectContext];
          tempTask = (Task*)[Task createNewObject];
            tempTask.project = _createdInProject;
          /*
           方法一
           newTask.project = _project;
           */
          
          /*
           方法二
           [_project addTasksObject:newTask];
           在指定project.tasks的属性为ordered时，系统生成的代码有个BUG，而非ordered时没有。
           解决方案，自己实现这个方法
           - (void)addTasksObject:(Task *)value {
           NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.tasks];
           [tempSet addObject:value];
           self.tasks = tempSet;
           }
           */
        }
        tempTask.title = _taskTextField.text;
        tempTask.createDate = [NSDate date];
        tempTask.dueDate = [NSDate date];
      [tempTask save];
        //[appDelegate saveContext];
        if ([_delegate respondsToSelector:@selector(didFinishEditTask:)]) {
            [_delegate didFinishEditTask:tempTask];
        }
    }
    
    [self close];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (cell == nil) {
            if (indexPath.row == 0) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                [cell.contentView addSubview:_taskTextField];
            } else if (indexPath.row == 1 || indexPath.row == 2) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else if (indexPath.row == 3) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                [cell.contentView addSubview:_taskNoteField];
            } 
        }
    }
    
    
    // 编辑模式
    if (_editingMode) {
        if (indexPath.row == 0) {
            _taskTextField.text = _editingTask.title;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"结束时间";
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"添加到项目";
            cell.detailTextLabel.text = _editingTask.project.name;
        } else {
            _taskNoteField.text = _editingTask.note;
        }
    } else { 
        //新建模式
        if (indexPath.row == 1) {
            cell.textLabel.text = @"结束时间";
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"添加到项目";
            if (_createdInProject) {
                cell.detailTextLabel.text = _createdInProject.name;
            }
        } 
    }

    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        SelectProjectViewController *viewController = [[SelectProjectViewController alloc] init];
        viewController.curProject = _createdInProject;
        viewController.delegate = self;
        viewController.fetchRequest = [FetchRequestFactory defaultProjectFetchRequest];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - Select project delegate
- (void) didSelectedProject:(Project*)project {
  if (_editingMode) {
    _editingTask.project = project;
  } else {
    self.createdInProject = project;
  }
    
  [self.tableView reloadData];
}

@end
