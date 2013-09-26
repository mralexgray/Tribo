//
//  Tribo Authentication Tool
//
//  Created by Carter Allen on 2/29/12.
//  Copyright (c) 2012 Opt-6 Products, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>
#import "TBConstants.h"
#import <AtoZ/AtoZ.h>

static NSString * const TBAuthenticationSSHServiceName = @"SSH";

NSString * 					fetchPasswordFromKeychain (void);
NSString * fetchPassphraseForIdentityFromKeychain (NSString *identityPath);
NSString *         promptForPassphraseForIdentity (NSString *identityPath);
void           addPassphraseForIdentityToKeychain (NSString *identityPath, NSString *password);

int main(int argc, const char * argv[]) {		@autoreleasepool {
		
		if (AZPROCINFO.arguments.count >= 2 && 
			[AZPROCINFO.arguments[1] rangeOfString:@"(yes/no)"].location != NSNotFound) 	return printf("YES"), 0;
		NSString *password 		= fetchPasswordFromKeychain();
		if (password && password.length) return printf("%s", password.UTF8String), 0;
		NSString *identityPath 	= AZPROCINFO.environment[TBSiteIdentityFileEnvironmentKey];
		NSString *passphrase 	= 	fetchPassphraseForIdentityFromKeychain(identityPath)
										?:	        promptForPassphraseForIdentity(identityPath);
		return !passphrase ? 1 : printf("%s", [passphrase UTF8String]), 0;
	}
    return 1;
}
NSString * fetchPasswordFromKeychain(void) {
	NSD *metadata = [AZPROCINFO environment];
	char *passwordBuffer = NULL;
	UInt32 passwordLength = 0;
	NSString *serverName = [metadata objectForKey:TBSiteServerKey];
	NSString *accountName = [metadata objectForKey:TBSiteUserNameKey];
	UInt16 port = (UInt16)[[metadata objectForKey:TBSitePortKey] integerValue];
	OSStatus returnStatus = SecKeychainFindInternetPassword(NULL, (UInt32)serverName.length, [serverName UTF8String], 0, NULL, (UInt32)accountName.length, [accountName UTF8String], 0, "", port, kSecProtocolTypeSSH, kSecAuthenticationTypeDefault, &passwordLength, (void **)&passwordBuffer, NULL);
	if (returnStatus != noErr)
		return nil;
	NSString *password = [[NSString alloc] initWithBytes:passwordBuffer length:passwordLength encoding: NSUTF8StringEncoding];
	SecKeychainItemFreeContent(NULL, passwordBuffer);
	return password;
}

NSString * fetchPassphraseForIdentityFromKeychain(NSString *identityPath) {
	
	NSString *serviceName = TBAuthenticationSSHServiceName;
	UInt32 passwordLength = 0;
	char *password = nil;
	SecKeychainItemRef item = nil;
	OSStatus returnStatus = SecKeychainFindGenericPassword(NULL, (UInt32)serviceName.length, [serviceName UTF8String], (UInt32)identityPath.length, [identityPath UTF8String], &passwordLength, (void **)&password, &item);
	if (returnStatus != noErr)	return nil;
	else if (!item)  				return SecKeychainItemFreeContent(NULL, password), nil;
	NSString *passwordString = [NSString.alloc initWithBytes:password length:passwordLength encoding:NSUTF8StringEncoding];
	return SecKeychainItemFreeContent(NULL, password), passwordString;
}
NSString * promptForPassphraseForIdentity(NSString *identityPath) {
	
	CFDictionaryRef notificationOptions = (__bridge CFDictionaryRef)[NSD dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Tribo needs the passphrase for %@, an SSH private key.", identityPath], kCFUserNotificationAlertHeaderKey, @"", kCFUserNotificationTextFieldTitlesKey, @"Add to Keychain", kCFUserNotificationCheckBoxTitlesKey, @"Cancel", kCFUserNotificationAlternateButtonTitleKey, nil];
	CFUserNotificationRef notification = CFUserNotificationCreate(kCFAllocatorDefault, 0, kCFUserNotificationPlainAlertLevel|CFUserNotificationSecureTextField(0), NULL, notificationOptions);
	
	CFOptionFlags responseFlags = (CFOptionFlags)0;
	CFUserNotificationReceiveResponse(notification, 0, &responseFlags);
	int button = responseFlags & 0x3;
	if (button == kCFUserNotificationAlternateResponse) return CFRelease(notification), nil;
	NSString *passphrase = [(__bridge NSString*)CFUserNotificationGetResponseValue(notification, kCFUserNotificationTextFieldValuesKey,0) copy];
	CFRelease(notification);
	if (responseFlags & CFUserNotificationCheckBoxChecked(0)) addPassphraseForIdentityToKeychain(identityPath, passphrase);
	return passphrase;
}
void addPassphraseForIdentityToKeychain(NSString *identityPath, NSString *passphrase) {
	
	NSString *serviceName = TBAuthenticationSSHServiceName;
	SecKeychainAddGenericPassword(NULL, (UInt32)serviceName.length, serviceName.UTF8String, (UInt32)identityPath.length, 
													identityPath.UTF8String, (UInt32)passphrase.length, [passphrase UTF8String], NULL);
}
