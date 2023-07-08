//
//  NSKeyedArchiver+securelyUnarchive.h
//  GifMaker_ObjC
//
//  Created by Daniel Illescas Romero on 8/7/23.
//  Copyright © 2023 Gabrielle Miller-Messner. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSKeyedUnarchiver (securelyUnarchive)
+ (nullable id)securelyUnarchiveObjectOfClasses:(nullable NSSet<Class> *)classes withFile:(NSString *)path error:(NSError **)error;
+ (nullable id)securelyUnarchiveObjectOfClasses:(nullable NSSet<Class> *)classes withFile:(NSString *)path;
@end

NS_ASSUME_NONNULL_END
