//
//  KPHHandler.m
//  KeePassHttp-ObjC
//
//  Created by James Hurst on 2014-09-22.
//  Copyright (c) 2014 James Hurst. All rights reserved.
//

#import "KPHHandler.h"
#import "KPHAESConfig.h"
#import "KPHUtils.h"
#import "NSData+Cryptor.h"

@interface KPHHandler ()
@property (weak) KPHServer *server;
@end

@implementation KPHHandler

- (NSString *)delegateLabelForKey:(NSString *)key {
  return [self.server.delegate server:self.server labelForKey:key];
}

- (NSString *)delegateKeyForLabel:(NSString *)label {
  return [self.server.delegate server:self.server keyForLabel:label];
}

- (NSArray *)delegateEntriesForURL:(NSString *)url {
  return [self.server.delegate server:self.server entriesForURL:url];
}

- (NSArray *)delegateAllEntries {
  return [self.server.delegate allEntriesForServer:self.server];
}

- (void)delegateSetUsername:(NSString *)username andPassword:(NSString *)password forURL:(NSString *)url withUUID:(NSString *)uuid {
  [self.server.delegate server:self.server setUsername:username andPassword:password forURL:url withUUID:uuid];
}

- (NSString *)delegateGeneratePassword {
  return [self.server.delegate generatePasswordForServer:self.server];
}

- (BOOL)testRequestVerifier:(KPHRequest *)request withAES:(KPHAESConfig *)aes {
  BOOL success = NO;
  
  CCCryptorRef cryptor = NULL;
  CCCryptorStatus status = CCCryptorCreate(kCCDecrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding, aes.key.bytes, aes.key.length, aes.IV.bytes, &cryptor);
  if (status == kCCSuccess)
  {
    NSData *encrypted;
    if(@available(macOS 10.9, *)) {
     encrypted = [[NSData alloc] initWithBase64EncodedString:request.Verifier options:0];
    }
    else {
     encrypted = [[NSData alloc] initWithBase64Encoding:request.Verifier];
    }
    NSData *decrypted = [encrypted runCryptor:cryptor];
    
    success = [[[NSString alloc] initWithData:decrypted encoding:NSUTF8StringEncoding] isEqualToString:request.Nonce];
    
    CCCryptorRelease(cryptor);
  }
  
  return success;
}

- (void)setResponseVerifier:(KPHResponse *)response {
  KPHAESConfig *aes = [KPHAESConfig aesWithKey:[self delegateKeyForLabel:response.Id] base64key:YES];
  if(@available(macOS 10.9, *)) {
    response.Nonce = [aes.IV base64EncodedStringWithOptions:0];
  }
  else {
    response.Nonce = [aes.IV base64Encoding];
  }
  response.Verifier = [KPHUtils performOpertaion:kCCEncrypt withAES:aes onString:response.Nonce base64input:NO base64output:YES];
}

- (BOOL)verifyRequest:(KPHRequest *)request {
  return [self verifyRequest:request withKey:[self delegateKeyForLabel:request.Id]];
}

- (BOOL)verifyRequest:(KPHRequest *)request withKey:(NSString *)key {
  if (!key) {
    return NO;
  }
  
  if (![self testRequestVerifier:request withAES:[KPHAESConfig aesWithKey:key base64key:YES IV:request.Nonce base64IV:YES]])
  {
    return NO;
  }
  return YES;
}

- (NSArray *)copyEntries:(NSArray *)entries {
  NSArray *copies = [[NSArray alloc] initWithArray:entries copyItems:YES];
  
  for (NSUInteger i = 0; i < entries.count; i++) {
    ((KPHResponseEntry *)copies[i]).url =  ((KPHResponseEntry *)entries[i]).url;
  }
  
  return copies;
}

- (NSArray *)entriesForURL:(NSURL *)url {
  /* if we got no scheme, host is nil as well so fall back to the full url string */
  NSString *search = url.host ? url.host : url.absoluteString;
  NSArray *entries = nil;
  while (!entries || entries.count == 0) {
    entries = [self delegateEntriesForURL:search];
    NSRange dot = [search rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    if (dot.location == NSNotFound || dot.location + 1 >= search.length) {
      break;
    }
    
    search = [search substringFromIndex:dot.location + 1];
  }
  
  return [self copyEntries:entries];
}

- (void)handle:(KPHRequest *)request response:(KPHResponse *)response server:(KPHServer *)server {
  self.server = server;
}

@end
