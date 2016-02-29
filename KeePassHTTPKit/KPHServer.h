//
//  KPHServer.h
//  KeePassHttp-ObjC
//
//  Created by James Hurst on 2014-09-21.
//  Copyright (c) 2014 James Hurst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPHDelegate.h"

@interface KPHServer : NSObject

@property (nonatomic, weak) id<KPHDelegate> delegate;
@property (readonly) BOOL isRunning;

- (BOOL)start;
- (BOOL)startWithPort:(NSUInteger)port bindToLocalhost:(BOOL)localhost error:(NSError *__autoreleasing *)error;
- (void)stop;

@end
