//
//  AppDelegate.m
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 3/1/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import "AppDelegate.h"
#import "Gif.h"
#import "NSKeyedArchiver+securelyArchive.h"
#import "NSKeyedUnarchiver+securelyUnarchive.h"

#define GIFURL [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"savedGifs"]

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	NSSet *classes = [NSSet setWithObjects:[NSMutableArray class], [Gif class], nil];
	NSMutableArray *retrievedGifs = [NSKeyedUnarchiver securelyUnarchiveObjectOfClasses:classes withFile:GIFURL];
	self.gifs = retrievedGifs;

	self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];

	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

	UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"CollectionNav"];
	self.window.rootViewController = viewController;

	[self.window makeKeyAndVisible];

	return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	[NSKeyedArchiver securelyArchiveRootObject:self.gifs toFile:GIFURL];
}

@end
