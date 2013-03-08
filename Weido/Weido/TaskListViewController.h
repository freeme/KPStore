//
//  TaskListViewController.h
//  Todo
//
//  Created by he baochen on 12-2-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FetchListViewController.h"
#import "EditTaskViewController.h"

@interface TaskListViewController : FetchListViewController<EditTaskDelegate> {

}

@end
