//
//  Gif.m
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 3/4/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import "Gif.h"
#import "UIImage+animatedGIF.h"

@implementation Gif

+ (BOOL)supportsSecureCoding {
	return YES;
}

-(instancetype)initWithGifURL: (NSURL*)url videoURL:(NSURL*)videoURL caption:(NSString*)caption {

	self = [super init];

	if(self){
		self.url = url;
		self.caption = caption;
		self.videoURL = videoURL;
		self.gifImage = [UIImage animatedImageWithAnimatedGIFURL:url];
	}

	return self;
}

-(instancetype)initWithName:(NSString*)name {

	self = [super init];

	if (self) {
		self.gifImage = [UIImage animatedImageWithAnimatedGIFName:name];
	}

	return self;
}

-(instancetype)initWithCoder:(NSCoder *)decoder{

	self = [super init];

	// Unarchive the data, one property at a time
	self.url = [decoder decodeObjectOfClass:[NSURL class] forKey:@"gifURL"];
	self.caption = [decoder decodeObjectOfClass:[NSString class] forKey:@"caption"];
	self.videoURL = [decoder decodeObjectOfClass:[NSURL class] forKey:@"videoURL"];
	self.gifImage = [decoder decodeObjectOfClass:[UIImage class] forKey:@"gifImage"];
	self.gifData = [decoder decodeObjectOfClass:[NSData class] forKey:@"gifData"];

	return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:self.url forKey: @"gifURL"];
	[coder encodeObject:self.caption forKey: @"caption"];
	[coder encodeObject:self.videoURL forKey: @"videoURL"];
	[coder encodeObject:self.gifImage forKey: @"gifImage"];
	[coder encodeObject: self.gifData forKey:@"gifData"];
}

@end
