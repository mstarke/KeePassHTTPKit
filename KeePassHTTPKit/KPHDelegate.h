//
//  KPHDelegate.h
//  KeePassHttp-ObjC
//
//  Created by James Hurst on 2014-09-22.
//  Copyright (c) 2014 James Hurst. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class KPHServer;
@class KPHResponseEntry;

@protocol KPHDelegate <NSObject>

@required
- (NSString *)server:(KPHServer *)server labelForKey:(NSString *)key;
- (NSString *)server:(KPHServer *)server keyForLabel:(NSString *)label;
- (NSArray<KPHResponseEntry *> *)server:(KPHServer *)server entriesForURL:(NSString *)url;
- (NSArray<KPHResponseEntry *> *)allEntriesForServer:(KPHServer *)server;
- (void)server:(KPHServer *)server setUsername:(NSString *)username andPassword:(NSString *)password forURL:(NSString *)url withUUID:(NSString *)uuid;
- (NSString *)clientHashForServer:(KPHServer *)server;
- (NSString *)generatePasswordForServer:(KPHServer *)server;

NS_ASSUME_NONNULL_END

@end
