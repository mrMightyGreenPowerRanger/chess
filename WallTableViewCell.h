//
//  WallTableViewCell.h
//  HW45
//
//  Created by Илья Егоров on 15.02.16.
//  Copyright © 2016 Илья Егоров. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WallPost;

@interface WallTableViewCell : UITableViewCell

-(void)setWallPost:(WallPost*)wallPost;

@end
