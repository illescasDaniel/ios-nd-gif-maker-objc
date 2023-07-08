//
//  NSKeyedArchiver+NSKeyedArchiver_archiveRootSecurely.h
//  GifMaker_ObjC
//
//  Created by Daniel Illescas Romero on 8/7/23.
//  Copyright © 2023 Gabrielle Miller-Messner. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSKeyedArchiver (securelyArchive)
+ (BOOL)securelyArchiveRootObject:(id)rootObject toFile:(NSString *)path error:(NSError **)error;
+ (BOOL)securelyArchiveRootObject:(id)rootObject toFile:(NSString *)path;
@end

NS_ASSUME_NONNULL_END
