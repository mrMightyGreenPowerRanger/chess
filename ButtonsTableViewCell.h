//
//  ButtonsTableViewCell.h
//  HW45
//
//  Created by Илья Егоров on 20.09.15.
//  Copyright © 2015 Илья Егоров. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ButtonsDelegate

-(void)actionShowFriends:(UIButton*)sender;
- (void)actionShowSubscriptions:(UIButton *)sender;
- (void)actionShowFollowers:(UIButton *)sender;
    
@end;

@interface ButtonsTableViewCell : UITableViewCell

@property (strong, nonatomic) id <ButtonsDelegate> delegate;
@end
