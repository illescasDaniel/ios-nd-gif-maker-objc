//
//  AppDelegate.h
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 3/1/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

@import UIKit;
#import "Gif.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) NSMutableArray<Gif *> *gifs;
//@property (nonatomic) BOOL welcomeViewSeen;

@end

