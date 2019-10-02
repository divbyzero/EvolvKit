//
//  EvolvClientHelper.h
//  ExampleObjC
//
//  Created by divbyzero on 02/10/2019.
//  Copyright © 2019 EvolvKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvolvKit-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface EvolvClientHelper : NSObject<EvolvClientDelegate>

@property (strong, nonatomic) id<EvolvClient> client;
@property (nonatomic, copy) void (^didChangeClientStatus)(enum EvolvClientStatus status);

+ (instancetype)shared;

@end

NS_ASSUME_NONNULL_END
