//
//  BTAppDelegate.h
//  Weido
//
//  Created by He baochen on 13-3-8.
//  Copyright (c) 2013年 He baochen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RootViewController;
@interface BTAppDelegate : UIResponder <UIApplicationDelegate> {
  UINavigationController *_navController;
  RootViewController *_rootViewController;
}

@property (strong, nonatomic) UIWindow *window;

@end
