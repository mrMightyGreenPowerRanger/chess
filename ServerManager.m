//
//  ServerManager.m
//  TestApiVk
//
//  Created by Галанов Сергей on 16.03.16.
//  Copyright © 2016 Галанов Сергей. All rights reserved.
//

#import "ServerManager.h"
#import "AFNetworking.h"
#import "WallPost.h"
#import "User.h"

@interface ServerManager()

@property (strong, nonatomic) AFHTTPRequestOperationManager* requestOperationManager;

@end

@implementation ServerManager

+ (ServerManager*) sharedManager {
    
    static ServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURL* url = [NSURL URLWithString:@"https://api.vk.com/method/"];
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    }
    return self;
}



-(void)getUserWithID:(NSInteger)userID
            onSuccess:(void(^)(User* user)) success
            onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @(userID),     @"user_id",
                            @"photo_max, photo_50, online, has_mobile, contacts, bdate",    @"fields",
                            @"nom",         @"name_case",   nil];
    
    [self.requestOperationManager GET:@"users.get"
                           parameters:params
                              success:^void(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                                  
                                  NSArray* dictsArray = [responseObject objectForKey:@"response"];
                                  
                                  User* user = [[User alloc] initWithServerResponce:[dictsArray firstObject]];
                                      
                                  if (success) {
                                      success(user);
                                  }
                                  
                              } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                                  NSLog(@"error: %@", error);
                                  
                                  if (failure) {
                                      failure(error, operation.response.statusCode);
                                  }
                              }];
}

-(void)getFriendsForID:(NSInteger)userID
                 Offset:(NSInteger)offset
               andCount:(NSInteger)count
              onSuccess:(void(^)(NSArray* friends)) success
              onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @(userID),      @"user_id",
                            @"name",        @"order",
                            @(count),       @"count",
                            @(offset),      @"offset",
                            @"photo_50, online",    @"fields",
                            @"nom",         @"name_case",   nil];
    
    [self.requestOperationManager
     GET:@"friends.get"
     parameters:params
     success:^void(AFHTTPRequestOperation * __nonnull operation, id __nonnull responseObject) {
         // NSLog(@"JSON: %@", responseObject);
         
         NSArray* dictsArray = [responseObject objectForKey:@"response"];
         
         NSMutableArray* objectsArray = [NSMutableArray array];
         
         
         for (NSDictionary* dict in dictsArray) {
             
             User* user = [[User alloc] initWithServerResponce:dict];
             [objectsArray addObject:user];
         }
         
         if (success) {
             success(objectsArray);
         }
         
     } failure:^void(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
         NSLog(@"error: %@", error);
         
         if (failure) {
             failure(error, operation.response.statusCode);
         }
         
     }];
}


-(void)getSubscriptionsForID:(NSInteger)userID
                 Offset:(NSInteger)offset
               andCount:(NSInteger)count
              onSuccess:(void(^)(NSArray* friends)) success
              onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @(userID),     @"user_id",
                            @"name",        @"order",
                            @(count),       @"count",
                            @(offset),      @"offset",
                            @"photo_50, online",    @"fields",
                            @"nom",         @"name_case",   nil];
    
    [self.requestOperationManager
     GET:@"users.getSubscriptions"
     parameters:params
     success:^void(AFHTTPRequestOperation * __nonnull operation, id __nonnull responseObject) {
         // NSLog(@"JSON: %@", responseObject);
         
         NSArray* dictsArray = [responseObject objectForKey:@"response"];
         
         NSMutableArray* objectsArray = [NSMutableArray array];
         
         if ([[dictsArray valueForKey:@"users"][@"count"] integerValue] > 0) {
             for (NSNumber* userID in [dictsArray valueForKey:@"users"][@"items"]) {
                 User* user = [[User alloc] initWithId:[userID integerValue]];
                 [objectsArray addObject:user];
             }
         }
         
         if (success) {
             success(objectsArray);
         }
         
     } failure:^void(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
         if (failure) {
             failure(error, operation.response.statusCode);
         }
     }];
}

-(void)getFollowersForID:(NSInteger)userID
                 Offset:(NSInteger)offset
               andCount:(NSInteger)count
              onSuccess:(void(^)(NSArray* friends)) success
              onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @(userID),     @"user_id",
                            @"name",        @"order",
                            @(count),       @"count",
                            @(offset),      @"offset",
                            @"photo_50, online",    @"fields",
                            @"nom",         @"name_case",   nil];
    
    [self.requestOperationManager
     GET:@"users.getFollowers"
     parameters:params
     success:^void(AFHTTPRequestOperation * __nonnull operation, id __nonnull responseObject) {
         // NSLog(@"JSON: %@", responseObject);
         
         NSArray* dictsArray = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
         
         NSMutableArray* objectsArray = [NSMutableArray array];
         
         
         for (NSDictionary* dict in dictsArray) {
             
             User* user = [[User alloc] initWithServerResponce:dict];
             [objectsArray addObject:user];
         }
         
         if (success) {
             success(objectsArray);
         }
         
     } failure:^void(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
         if (failure) {
             failure(error, operation.response.statusCode);
         }
     }];
}


-(void)getWallForID:(NSInteger)userID
             Offset:(NSInteger)offset
           andCount:(NSInteger)count
          onSuccess:(void(^)(NSNumber* postsNumber, NSArray* wallPosts)) success
          onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @(userID),     @"owner_id",
                            @(count),       @"count",
                            @(offset),      @"offset",   nil];
    
    [self.requestOperationManager
     GET:@"wall.get"
     parameters:params
     success:^void(AFHTTPRequestOperation * __nonnull operation, id __nonnull responseObject) {
         // NSLog(@"JSON: %@", responseObject);
         
         NSMutableArray* dictsArray = [[responseObject objectForKey:@"response"] mutableCopy];
         
         NSNumber* postNumber = [dictsArray firstObject];
         
         [dictsArray removeObject:[dictsArray firstObject]];
         NSMutableArray* objectsArray = [NSMutableArray array];
         
         
         for (NSDictionary* dict in dictsArray) {
             WallPost* wallPost = [[WallPost alloc] initWithServerResponce:dict];
             [objectsArray addObject:wallPost];
         }
         
         if (success) {
             success(postNumber, objectsArray);
         }
         
     } failure:^void(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
         if (failure) {
             failure(error, operation.response.statusCode);
         }
     }];
}

@end

