//
//  EditTaskViewController.h
//  Todo
//
//  Created by he baochen on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "SelectProjectViewController.h"
#import "Project.h"

@class Task;
@protocol EditTaskDelegate <NSObject>

- (void) didFinishEditTask:(Task*)task;

@end

@interface EditTaskViewController : UITableViewController<SelectProjectDelegate> {
    UITextField *_taskTextField;
    UITextField *_taskNoteField;
    Task* _editingTask;
    BOOL _editingMode;
    Project* _createdInProject;
    id<EditTaskDelegate> _delegate;
}

@property (nonatomic, assign) id<EditTaskDelegate> delegate;
@property (nonatomic, retain) Project *createdInProject;
@property (nonatomic, retain) Task *editingTask;

@end
