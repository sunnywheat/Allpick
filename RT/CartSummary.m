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

@end
