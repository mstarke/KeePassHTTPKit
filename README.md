# KeePassHTTPKit

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

An Objective-C implementation of the KeePassHttp protocol.

Copyright (c) 2014 James Hurt <br>
Copyright (c) 2015-2016 Michael Starke, HicknHack Software GmbH

## Dependencies

[JSONModel](https://github.com/icanzilb/JSONModel) (submodule)
[GCDWebServer](https://github.com/swisspol/GCDWebServer)

## Installation

* Clone the repository
```bash
git clone https://github.com/MacPass/KeePassHTTPKit
cd KeePassHTTPKit
git submodule init
git submodule update
```
* Install [Carthage](https://github.com/Carthage/Carthage#installing-carthage)
* Fetch and build dependencies
```bash
carthage bootstrap
```

## Usage
```objectivec
#import <KeePassHTTPKit/KeePassHTTPKit.h>

@interface ServerDelegate : NSObject <KPHDelegate>
- (NSString *)server:(KPHServer *)server labelForKey:(NSString *)key;
- (NSString *)server:(KPHServer *)server keyForLabel:(NSString *)label;
- (NSArray<KPHResponseEntry *> *)server:(KPHServer *)server entriesForURL:(NSString *)url;
- (NSArray<KPHResponseEntry *> *)allEntriesForServer:(KPHServer *)server;
- (void)server:(KPHServer *)server setUsername:(NSString *)username andPassword:(NSString *)password forURL:(NSString *)url withUUID:(NSString *)uuid;
- (NSString *)clientHashForServer:(KPHServer *)server;
- (NSString *)generatePasswordForServer:(KPHServer *)server;
@end

@interface Server : NSObject
@property (strong) KPHServer *server;
@property (strong) ServerDelegate *delegate;
- (void)startServer;
@end

@implementation Server
- (void)startServer {
	self.server = [[KPHServer alloc] init];
	self.delegate = [[ServerDelegate alloc] init];
	server.delegate = delgate;
	[server start];
}
@end
```

## License
The MIT License (MIT)

Copyright (c) 2014 James Hurst<br>
Copyright (c) 2015-2016 Michael Starke, HicknHack Software GmbH

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.


