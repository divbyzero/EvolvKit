//
//  EvolvClientHelper.m
//  ExampleObjC
//
//  Created by divbyzero on 02/10/2019.
//  Copyright © 2019 EvolvKit. All rights reserved.
//

#import "EvolvClientHelper.h"
#import "CustomAllocationStore.h"

@interface EvolvClientHelper ()
@property (strong, nonatomic) id<EvolvHttpClient> httpClient;
@property (strong, nonatomic) id<EvolvAllocationStore> store;
@end

@implementation EvolvClientHelper

+ (instancetype)shared {
    static EvolvClientHelper *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (instancetype)init {
    if (self = [super init]) {
        /*
         When you receive the fetched json from the participants API, it will be as type String.
         If you use the DefaultEvolvHttpClient, the string will be parsed to EvolvRawAllocation array
         (required data type for EvolvAllocationStore).
         
         This example shows how the data can be structured in your view controllers,
         your implementation can work directly with the raw string and serialize into EvolvRawAllocation.
         */
        _httpClient = [[DefaultEvolvHttpClient alloc] init];
        _store = [[CustomAllocationStore alloc] init];
        
        /// - Build config with custom timeout and custom allocation store
        // set client to use sandbox environment
        EvolvConfig *config = [[[EvolvConfig builderWithEnvironmentId:@"sandbox" httpClient:_httpClient] setWithAllocationStore:_store] build];
        
        // set error or debug logLevel for debugging
        [config setWithLogLevel:EvolvLogLevelDebug];
        
        /// - Initialize the client with a stored user
        /// fetches allocations from Evolv, and stores them in a custom store
        _client = [EvolvClientFactory createClientWithConfig:config
                                                 participant:[[[EvolvParticipant builder] setWithUserId:@"sandbox_user"] build]
                                                    delegate:self];
        
        /// - Initialize the client with a new user
        /// - Uncomment this line if you prefer this initialization.
        // _client = [EvolvClientFactory createClientWithConfig:config participant:nil delegate:nil];
    }
    
    return self;
}

- (void)didChangeClientStatus:(enum EvolvClientStatus)status {
    self.didChangeClientStatus(status);
}

@end
