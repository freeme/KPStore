//
//  BaseListViewController.h
//  Todo
//
//  Created by he baochen on 12-2-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FetchListViewController : UITableViewController <NSFetchedResultsControllerDelegate>{
    NSFetchedResultsController *_fetchController;
    NSFetchRequest *_fetchRequest;
}

@property(nonatomic, retain) NSFetchRequest *fetchRequest;

@end
