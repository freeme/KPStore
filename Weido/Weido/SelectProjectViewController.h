//
//  SelectProjectViewController.h
//  Todo
//
//  Created by he baochen on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FetchListViewController.h"
#import "Project.h"

@class Project;
@protocol SelectProjectDelegate <NSObject>

- (void) didSelectedProject:(Project*)project;

@end

@interface SelectProjectViewController : FetchListViewController {
    Project *_currentProject;
    id<SelectProjectDelegate> _delegate;
}

@property(nonatomic, assign) id<SelectProjectDelegate> delegate;
@property(nonatomic, retain) Project *curProject;

@end
