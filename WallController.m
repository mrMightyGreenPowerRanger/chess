//
//  WallController.m
//  TestApiVk
//
//  Created by Галанов Сергей on 16.03.16.
//  Copyright © 2016 Галанов Сергей. All rights reserved.
//
#import "WallController.h"
#import "WallTableViewCell.h"
#import "WallPost.h"
#import "ServerManager.h"
#import "UIImageView+AFNetworking.h"

@interface WallController ()

@property (strong, nonatomic) NSNumber* postsNumber;
@property (assign, nonatomic) NSInteger offset;

@property (strong, nonatomic) UIImage* userImage;

@property (strong, nonatomic) NSMutableArray* posts;

@end

@implementation WallController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WallTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"wallPostCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.offset = 0;
    self.posts = [NSMutableArray array];
    
    self.userImage = nil;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUserID:(NSInteger)userID {
    _userID = userID;
    [self getMoreWallPosts];
}

-(void)getMoreWallPosts {
    [[ServerManager sharedManager] getWallForID:_userID Offset:self.offset andCount:10 onSuccess:^(NSNumber* postsNumber, NSArray *wallPosts) {
        self.postsNumber = postsNumber;
        [self.posts addObjectsFromArray:wallPosts];
        self.offset += [wallPosts count];
        [self.tableView reloadData];
    } onFailure:^(NSError *error, NSInteger statusCode) {
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.posts count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.posts.count) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        [cell.textLabel setText:@"Load More"];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        return cell;
    } else {
        WallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wallPostCell" forIndexPath:indexPath];
        
        [cell setWallPost:[self.posts objectAtIndex:indexPath.row]];
        
        UIImageView* userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 50, 50)];
        [cell addSubview:userImageView];
        NSURLRequest* request = [NSURLRequest requestWithURL:self.userPhotoURL];
 
        __weak UIImageView* weakCellImage = userImageView;
        
        userImageView.image = nil;
        
        [userImageView setImageWithURLRequest:request
                                   placeholderImage:nil
                                            success:^void(NSURLRequest * __nonnull request, NSHTTPURLResponse * __nonnull responce, UIImage * __nonnull image) {
                                                weakCellImage.image = image;
                                                [cell setNeedsLayout];
                                            } failure:^ void(NSURLRequest * __nonnull request,
                                                             NSHTTPURLResponse * __nonnull responce,
                                                             NSError * __nonnull error) {
                                            }];
        return cell;
    }
    
    // Configure the cell...
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.posts.count) {
        return 64.f;
    }
    WallPost* post = [self.posts objectAtIndex:indexPath.row];
    
    CGFloat postHeight = 8.f;
    if (post.text) {
        UIFont *font = [UIFont systemFontOfSize:15.0];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                    forKey:NSFontAttributeName];
        
        NSAttributedString* string = [[NSAttributedString alloc] initWithString:post.text attributes:attrsDictionary];
        CGRect rect = [string boundingRectWithSize:CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) - 66 - 8, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:NULL];
        postHeight += rect.size.height + 4;
    }
    if ([post.postType isEqualToString:@"copy"]) {
        UILabel* copy = [[UILabel alloc] initWithFrame:CGRectMake(66, postHeight, CGRectGetWidth([[UIScreen mainScreen] bounds]) - 66 - 8, 30)];
        [copy setText:@"REPOST"];
        [copy setBackgroundColor:[UIColor clearColor]];
        postHeight += 30 + 4;
    }
    if (post.attachments) {
        for (int i = 0; i <post.attachments.count; i++) {
            NSDictionary* attachment = [post.attachments objectAtIndex:i];
            if ([[attachment valueForKey:@"type"] isEqualToString:@"photo"]) {
                postHeight += (CGRectGetWidth([[UIScreen mainScreen] bounds]) - 66 - 8)/4*3 + 4;
            } else {
                postHeight += 30+4;
            }
        }
    }
    postHeight += 25 + 4;
    postHeight = MAX (postHeight, 50 + 8 + 8);
    return postHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == self.posts.count) {
        [self getMoreWallPosts];
    }
}

@end
