//
//  CartSummary.m
//  RT
//
//  Created by yiqin on 5/26/14.
//  Copyright (c) 2014 telerik. All rights reserved.
//

#import "CartSummary.h"

@implementation CartSummary

@synthesize someProperty;
@synthesize currentOrder;

#pragma mark Singleton Methods
+ (id)sharedManager {
    static CartSummary *sharedCartSummary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCartSummary = [[self alloc] init];
    });
    return sharedCartSummary;
}

- (id)init {
    if (self = [super init]) {
        someProperty = @"Default Property Value";
    }
    return self;
}

#pragma mark Shared Public Methods
+(NSString *) getSomeData {
    // Ensure we are using the shared instance
    CartSummary *shared = [CartSummary sharedManager];
    return shared.someProperty;
}

+(void) setSomeData:(NSString *)someData {
    // Ensure we are using the shared instance
    CartSummary *shared = [CartSummary sharedManager];
    shared.someProperty = someData;
}

+(NSString *) getCurrentOrder {
    CartSummary *shared = [CartSummary sharedManager];
    return shared.currentOrder;
}

+(void) setCurrentOrder:(NSString *)order {
    CartSummary *shared = [CartSummary sharedManager];
    shared.currentOrder = order;
}

@end
