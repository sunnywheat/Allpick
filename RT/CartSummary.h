//
//  CartSummary.h
//  RT
//
//  Created by yiqin on 5/26/14.
//  Copyright (c) 2014 telerik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartSummary : NSObject {
    NSString *someProperty;
}

@property (nonatomic, retain) NSString *someProperty;

+ (id)sharedManager;

+(NSString *) getSomeData;
+(void) setSomeData:(NSString *)someData;

@end
