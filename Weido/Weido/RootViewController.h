//
//  RootViewController.h
//  Todo
//
//  Created by he baochen on 12-2-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditTaskViewController.h"
#import "FetchRequestFactory.h"
#import "TestAction.h"

typedef enum {
    SectionTypeInput = 0,
    SectionTypeInbox ,
    SectionTypeTime,
    SectionTypeProject,
    SectionTypeFinish,
    SectionTypeCount
} SectionType;


@interface RootViewController : UITableViewController<UITextFieldDelegate, EditTaskDelegate> {
    UITextField *_inputField;
  NSFetchRequest *_inboxFetchRequest;
  NSFetchRequest *_todayFetchRequest;
  NSFetchRequest *_projectFetchRequest;
  NSFetchRequest *_finishFetchRequest;
  BOOL _needReloadData;
  TestAction *_testAction ;
}

@end
