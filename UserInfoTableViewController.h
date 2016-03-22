//
//  UserInfoTableViewController.h
//  TestApiVk
//
//  Created by Галанов Сергей on 16.03.16.
//  Copyright © 2016 Галанов Сергей. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;
@protocol ButtonsDelegate;

@interface UserInfoTableViewController : UITableViewController <ButtonsDelegate>

@property (strong, nonatomic) User* user;

- (instancetype)initForUser:(User*)user;

@end
