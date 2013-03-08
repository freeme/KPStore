//
//  FetchRequestFactory.m
//  Todo
//
//  Created by He baochen on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FetchRequestFactory.h"
#import "KPStore.h"
@interface FetchRequestFactory (private)
+ (NSFetchRequest*) defaultFetchRequest;
+ (NSArray*) defaultSortDescriptors;
+ (NSFetchRequest*) defaultTaskFetchRequest;
+ (NSFetchRequest*) defaultProjectFetchRequest;


@end

@implementation FetchRequestFactory

//默认的排序规则是，按到期时间近的，和创建时间早的
+ (NSArray*) defaultSortDescriptors {
  NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:YES];
  NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:YES];
  
  NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortDescriptor1,sortDescriptor2, nil] autorelease];
  [sortDescriptor1 release];
  [sortDescriptor2 release];
  return sortDescriptors;
}

+ (NSFetchRequest*) defaultFetchRequest {
  NSFetchRequest *request = nil;
  request = [[NSFetchRequest alloc] init];
  NSArray* sortDescriptors = [self defaultSortDescriptors];
  [request setSortDescriptors:sortDescriptors];
  return request;
}


+ (NSFetchRequest*) defaultTaskFetchRequest {
  NSFetchRequest *request = [self defaultFetchRequest];
//  KPAppDelegate *appDelegate = [KPAppDelegate shareDelegate];
//  [request setEntity:[NSEntityDescription entityForName:@"Task" inManagedObjectContext:appDelegate.managedObjectContext]];
  [request setEntity:[[KPStore sharedStore] entityForName:@"Task"]];
  return request;
}

+ (NSFetchRequest*) defaultProjectFetchRequest {
  NSFetchRequest *request = [self defaultFetchRequest];
//  KPAppDelegate *appDelegate = [KPAppDelegate shareDelegate];
//  [request setEntity:[NSEntityDescription entityForName:@"Project" inManagedObjectContext:appDelegate.managedObjectContext]];
  [request setEntity:[[KPStore sharedStore] entityForName:@"Project"]];
  NSMutableArray* sortDescriptors = [NSMutableArray arrayWithArray:[request sortDescriptors]];
  NSSortDescriptor *sortDescriptor0 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
  //project 按先照名称进行排序
  [sortDescriptors insertObject:sortDescriptor0 atIndex:0];
  [request setSortDescriptors:sortDescriptors];
  [sortDescriptor0 release];
  return request;
}

+ (NSFetchRequest*) inboxTaskFetchRequest {
  NSFetchRequest *request = [self defaultTaskFetchRequest];
  // 不在任何项目中的任务
  NSPredicate *predicate = [NSPredicate
                            predicateWithFormat:@"(project == nil) AND (isFinish == %@)",[NSNumber numberWithBool:NO]];
  [request setPredicate:predicate];
  return request;
}

+ (NSFetchRequest*) todayTaskFetchRequest {
  NSFetchRequest *request = [self defaultTaskFetchRequest];
  // 今天的任务，任务的到期时间 小于等于　今天的
  NSDate *today = [NSDate date];
  //NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *todayComponents =
  [calendar components:(kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear) fromDate:today];
  NSInteger day = [todayComponents day];
  [todayComponents setDay:day + 1];
  
  //今天晚上12:00，所有小于这个时间都放在今天显示
  NSDate *todayEnd = [calendar dateFromComponents:todayComponents];
  NSPredicate *predicate = [NSPredicate
                            predicateWithFormat:@"(isFinish == %@) AND (dueDate!=nil) AND (dueDate<%@)",[NSNumber numberWithBool:NO],todayEnd];
  [request setPredicate:predicate];
  return request;
}

+ (NSFetchRequest*) finishTaskFetchRequest {
  NSFetchRequest *request = [self defaultTaskFetchRequest];
  // 不在任何项目中的任务
  NSPredicate *predicate = [NSPredicate
                            predicateWithFormat:@"isFinish == %@",[NSNumber numberWithBool:YES]];
  [request setPredicate:predicate];
  return request;
}

@end
