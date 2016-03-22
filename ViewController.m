//
//  ViewController.m
//  TestApiVk
//
//  Created by Галанов Сергей on 16.03.16.
//  Copyright © 2016 Галанов Сергей. All rights reserved.
//

#import "ViewController.h"
#import "ServerManager.h"
#import "User.h"
#import "UserInfoTableViewController.h"
#import "UIImageView+AFNetworking.h"


@interface ViewController ()

@property (strong, nonatomic) NSMutableArray* friendsArray;

@end


@implementation ViewController

static NSInteger friendsInRequest = 20;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSInteger randInt = (long)arc4random_uniform(100);
    
    if (self.user == nil) {
        self.user = [[User alloc] initWithId:randInt];
    }
    
    self.friendsArray =  [NSMutableArray array];
    
    switch (self.usersList) {
        case UsersListFriends:
            [self getFriendsFromServer];
            break;
        case UsersListFollowers:
            [self getFollowersFromServer];
            break;
        case UsersListSubscriptions:
            [self getSubscriptionsFromServer];
            break;
        default:
            break;
    }
    
    [self.tableView setTableFooterView: [[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

-(void)getFriendsFromServer {
    
    [[ServerManager sharedManager]
     getFriendsForID:self.user.userID
     Offset:[self.friendsArray count]
     andCount:friendsInRequest
     onSuccess:^(NSArray *friends) {
         
         [self.friendsArray addObjectsFromArray:friends];
         [self.tableView reloadData];
         
     } onFailure:^(NSError *error, NSInteger statusCode) {
         
         NSLog(@"error = %@, code = %d", [error localizedDescription], statusCode);
         
     }];
}


-(void)getFollowersFromServer {
    [[ServerManager sharedManager]
     getFollowersForID:self.user.userID
     Offset:[self.friendsArray count]
     andCount:friendsInRequest
     onSuccess:^(NSArray *friends) {
         
         [self.friendsArray addObjectsFromArray:friends];
         [self.tableView reloadData];
         
     } onFailure:^(NSError *error, NSInteger statusCode) {
         
         NSLog(@"error = %@, code = %d", [error localizedDescription], statusCode);
         
     }];
}

-(void)getSubscriptionsFromServer {
    
    [[ServerManager sharedManager]
     getSubscriptionsForID:self.user.userID
     Offset:[self.friendsArray count]
     andCount:friendsInRequest
     onSuccess:^(NSArray *friends) {
         if ([[friends firstObject] userID] != [[self.friendsArray firstObject] userID]) {
             [self.friendsArray addObjectsFromArray:friends];
             [self.tableView reloadData];
         }
     } onFailure:^(NSError *error, NSInteger statusCode) {
         
         NSLog(@"error = %@, code = %d", [error localizedDescription], statusCode);
         
     }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.friendsArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:identifier];
    }
    
    if (indexPath.row == [self.friendsArray count]) {
        
        cell.textLabel.text = @"Load More";
        cell.imageView.image = nil;
        
    } else {
        
        User* friend = [self.friendsArray objectAtIndex:indexPath.row];
        
        __weak UITableViewCell* weakCell = cell;
        
        if (!friend.firstName) {
            [[ServerManager sharedManager] getUserWithID:friend.userID onSuccess:^(User *user) {
                [self.friendsArray setObject:user atIndexedSubscript:indexPath.row];
                [self.tableView reloadData];
            } onFailure:^(NSError *error, NSInteger statusCode) {}];
        } else {
        
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",friend.firstName, friend.lastName];
            [cell.detailTextLabel setText: friend.isOnline ? @"Online" : nil ];
        
            NSURLRequest* request = [NSURLRequest requestWithURL:friend.smallImageURL];
        
        weakCell.imageView.image = nil;
        
        [cell.imageView setImageWithURLRequest:request
                              placeholderImage:nil
                                       success:^void(NSURLRequest * __nonnull request,
                                                     NSHTTPURLResponse * __nonnull responce,
                                                     UIImage * __nonnull image) {
                                               weakCell.imageView.image = image;
                                           [weakCell setNeedsLayout];
                                       } failure:^ void(NSURLRequest * __nonnull request,
                                                        NSHTTPURLResponse * __nonnull responce,
                                                        NSError * __nonnull error) {
                                       }];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [self.friendsArray count]) {
        switch (self.usersList) {
            case UsersListFriends:
                [self getFriendsFromServer];
                break;
            case UsersListFollowers:
                [self getFollowersFromServer];
                break;
            case UsersListSubscriptions:
                [self getSubscriptionsFromServer];
                break;
            default:
                break;
        }
    } else {
        User* user = [self.friendsArray objectAtIndex:indexPath.row];
        [[ServerManager sharedManager] getUserWithID:user.userID onSuccess:^(User *user) {
            UserInfoTableViewController* vc = [[UserInfoTableViewController alloc] initForUser:user];
            [self.navigationController pushViewController:vc animated:YES];
        } onFailure:^(NSError *error, NSInteger statusCode) {
        }];
        
    }
}

@end

