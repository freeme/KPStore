//
//  ProjectListViewController.h
//  Todo
//
//  Created by he baochen on 12-2-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FetchListViewController.h"

@interface ProjectListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate> {
    UITableView *_tableView;
    NSFetchRequest *_fetchRequest;
    NSMutableArray *_projectArray;
    UIView *_inputContainer;
    UITextField *_inputField;
    UIControl *_coverView;
}

@property(nonatomic, retain) NSFetchRequest *fetchRequest;

- (void) showAddView;

@end
