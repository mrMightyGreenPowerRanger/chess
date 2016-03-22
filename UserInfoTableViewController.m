//
//  UserInfoTableViewController.m
//  TestApiVk
//
//  Created by Галанов Сергей on 16.03.16.
//  Copyright © 2016 Галанов Сергей. All rights reserved.
//

#import "UserInfoTableViewController.h"
#import "User.h"
#import "ServerManager.h"
#import "ViewController.h"
#import "GrandUserImageTableViewCell.h"
#import "ButtonsTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "WallController.h"

@interface UserInfoTableViewController ()

@end

@implementation UserInfoTableViewController

- (instancetype)initForUser:(User*)user
{
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GrandUserImageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"grandUserImageCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ButtonsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"buttonsCell"];
    [self.tableView setTableFooterView: [[UIView alloc] initWithFrame:CGRectZero]];
    
    
    if (!self.user) {
        NSInteger randInt = (long)arc4random_uniform(100);
        self.user = [[User alloc] initWithId:randInt];
    }
    
    [[ServerManager sharedManager] getUserWithID:self.user.userID
                                       onSuccess:^(User *user) {
                                           self.user = user;
                                           self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", self.user.firstName, self.user.lastName];
                                           [self.tableView reloadData];
                                       } onFailure:^(NSError *error, NSInteger statusCode) {}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section > 0) {
        return 2;
    }
    return 1;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 1 ? @"Info" : nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section ? 43.f : 260.f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        GrandUserImageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"grandUserImageCell" forIndexPath:indexPath];

        NSURLRequest* request = [NSURLRequest requestWithURL:self.user.largeImageURL];
        
        __weak GrandUserImageTableViewCell* weakCell = cell;
        
        weakCell.grandImageView.image = nil;
        
        [cell.grandImageView setImageWithURLRequest:request
                              placeholderImage:nil
                                       success:^void(NSURLRequest * __nonnull request, NSHTTPURLResponse * __nonnull responce, UIImage * __nonnull image) {
                                           weakCell.grandImageView.image = image;
                                           [weakCell setNeedsLayout];
                                       } failure:^ void(NSURLRequest * __nonnull request,
                                                        NSHTTPURLResponse * __nonnull responce,
                                                        NSError * __nonnull error) {
                                       }];
        
        return cell;
        
    } else if (indexPath.section == 1) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:@"infoCell"];
        }
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Birth date"];
            [cell.detailTextLabel setText: self.user.birthDate ? self.user.birthDate : @"hidden"];
        } else {
            [cell.textLabel setText:@"Mobile phone"];
            [cell.detailTextLabel setText: self.user.mobilePhone ? self.user.mobilePhone : @"hidden"];
        }
        return cell;
        
    } else if (indexPath.section == 2 && indexPath.row == 0){
        
        ButtonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonsCell" forIndexPath:indexPath];
        [cell setDelegate:self];
        return cell;
    } else {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"wallCell"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"wallCell"];
        }
        
        [cell.textLabel setText:@"WALL"];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2 && indexPath.row == 1) {
        WallController* wc = [[WallController alloc] init];
        [wc setUserID:self.user.userID];
        [wc setUserPhotoURL:self.user.smallImageURL];
        [self.navigationController pushViewController:wc animated:YES];
    }
}

#pragma mark - IBActions
- (void)actionShowFriends:(UIButton *)sender {
    ViewController* vc = [[ViewController alloc] initWithStyle:UITableViewStylePlain];
    [vc setUser:self.user];
    [vc setUsersList:UsersListFriends];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)actionShowSubscriptions:(UIButton *)sender {
    ViewController* vc = [[ViewController alloc] initWithStyle:UITableViewStylePlain];
    [vc setUser:self.user];
    [vc setUsersList:UsersListSubscriptions];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)actionShowFollowers:(UIButton *)sender {
    ViewController* vc = [[ViewController alloc] initWithStyle:UITableViewStylePlain];
    [vc setUser:self.user];
    [vc setUsersList:UsersListFollowers];
    [self.navigationController pushViewController:vc animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
