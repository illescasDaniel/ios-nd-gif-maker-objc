//
//  NSKeyedArchiver+NSKeyedArchiver_archiveRootSecurely.m
//  GifMaker_ObjC
//
//  Created by Daniel Illescas Romero on 8/7/23.
//  Copyright © 2023 Gabrielle Miller-Messner. All rights reserved.
//

#import "NSKeyedArchiver+securelyArchive.h"

@implementation NSKeyedArchiver (securelyArchive)
+ (BOOL)securelyArchiveRootObject:(id)rootObject toFile:(NSString *)path error:(NSError **)error {
	NSData* data = [NSKeyedArchiver archivedDataWithRootObject:rootObject requiringSecureCoding:true error:error];
	if (data != nil) {
		NSURL *url = [NSURL fileURLWithPath:path];
		if ([data writeToURL:url options:NSDataWritingAtomic error:error]) {
			return true;
		} else {
			if (error != NULL) {
				*error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteUnknownError userInfo:nil];
			}
			return false;
		}
	} else {
		return false;
	}
}

+ (BOOL)securelyArchiveRootObject:(id)rootObject toFile:(NSString *)path {
	NSError *error;
	BOOL didArchiveCorrectly = [NSKeyedArchiver securelyArchiveRootObject:rootObject toFile:path error:&error];
	if (didArchiveCorrectly && error != nil) {
		NSLog(@"NSKeyedArchiver(securelyArchive) Error: %@", error);
		return false;
	} else {
		return true;
	}
}
@end
