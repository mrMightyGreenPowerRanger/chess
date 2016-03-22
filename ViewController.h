//
//  ViewController.h
//  TestApiVk
//
//  Created by Галанов Сергей on 16.03.16.
//  Copyright © 2016 Галанов Сергей. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

typedef enum {
    UsersListFriends,
    UsersListFollowers,
    UsersListSubscriptions
}UsersList;

@interface ViewController : UITableViewController

@property (assign, nonatomic) UsersList usersList;
@property (strong, nonatomic) User* user;

@end

