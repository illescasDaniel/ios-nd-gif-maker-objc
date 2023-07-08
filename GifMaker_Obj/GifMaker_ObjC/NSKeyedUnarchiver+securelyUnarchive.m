//
//  NSKeyedArchiver+securelyUnarchive.m
//  GifMaker_ObjC
//
//  Created by Daniel Illescas Romero on 8/7/23.
//  Copyright © 2023 Gabrielle Miller-Messner. All rights reserved.
//

#import "NSKeyedUnarchiver+securelyUnarchive.h"

@implementation NSKeyedUnarchiver (securelyUnarchive)
+ (nullable id)securelyUnarchiveObjectOfClasses:(nullable NSSet<Class> *)classes withFile:(NSString *)path error:(NSError **)error {
	NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
	if (data != nil) {
		id obj = nil;
		NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:error];
		[unarchiver setRequiresSecureCoding:YES];
		obj = [unarchiver decodeTopLevelObjectOfClasses:classes forKey:NSKeyedArchiveRootObjectKey error:error];
		[unarchiver finishDecoding];
		return obj;
	} else {
		if (error != NULL) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileReadNoSuchFileError userInfo:nil];
		return nil;
	}
}

+ (nullable id)securelyUnarchiveObjectOfClasses:(nullable NSSet<Class> *)classes withFile:(NSString *)path {
	NSError *error;
	id result = [NSKeyedUnarchiver securelyUnarchiveObjectOfClasses:classes withFile:path error:&error];
	if (result == nil || error != nil) {
		NSLog(@"NSKeyedArchiver(securelyUnarchive) Error: %@", error);
		return [[NSMutableArray alloc] init];
	}
	return result;
}
@end
