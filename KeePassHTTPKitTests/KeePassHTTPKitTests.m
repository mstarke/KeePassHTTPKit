//
//  KeePassHTTPKitTests.m
//  KeePassHTTPKitTests
//
//  Created by Michael Starke on 16/11/15.
//  Copyright © 2015 HicknHack Software GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KeePassHTTPKit.h"

@interface KeePassHTTPKitTests : XCTestCase

@end

@implementation KeePassHTTPKitTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test {
  KPHServer *server = [[KPHServer alloc] init];
  [server start];
  //XCTFail(@"No tests implemented!");
}

@end
