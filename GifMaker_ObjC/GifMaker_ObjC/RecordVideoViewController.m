//
//  RecordVideoViewController.m
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 3/1/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import "RecordVideoViewController.h"
@import MobileCoreServices;
@import Regift;
@import AVFoundation;
#import "AppDelegate.h"
#import "RecordVideoViewController+AllowEditing.h"
#import "GifEditorViewController.h"

@interface RecordVideoViewController()

@property (nonatomic) NSURL *videoURL;
@property (nonatomic) NSURL *gifURL;
@property (weak, nonatomic) IBOutlet UIImageView *previousGifImageView;

@end

static int const kFrameCount = 16;
static const float kDelayTime = 0.2;
static const int kLoopCount = 0; // 0 means loop forever

@implementation RecordVideoViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if(appDelegate.gifs.count > 0) {
        NSUInteger count = appDelegate.gifs.count;
        self.previousGifImageView.image = appDelegate.gifs[count-1].gifImage;
    } else {
        Gif *firstLaunchGif = [[Gif alloc] initWithName:@"tinaFeyHiFive"];
        self.previousGifImageView.image = firstLaunchGif.gifImage;
    }    
}

# pragma mark - Video Recording Methods
- (IBAction)launchCamera:(id)sender {
    [self startCameraFromViewController:self];
}

- (BOOL)startCameraFromViewController:(UIViewController*)viewController {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        return false;
    } else {
        
        UIImagePickerController *cameraController = [[UIImagePickerController alloc] init];
        cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraController.mediaTypes = @[(NSString *) kUTTypeMovie];
        cameraController.allowsEditing = true;
        cameraController.delegate = self;
        
        [self presentViewController:cameraController animated:TRUE completion:nil];
        return true;
    }
}

-(void)video:(NSString *)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(id)info {
    NSString *title = @"Success";
    NSString *message = @"Video was saved";
    
    if (error != nil) {
        title = @"Error";
        message = @"Video failed to save";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:TRUE completion:nil];
}

# pragma mark - UIImagePickerController Delegate methods

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

# pragma mark - Gif Conversion and Display methods

-(void)convertVideoToGif {
    Regift *regift = [[Regift alloc] initWithSourceFileURL:self.videoURL frameCount:kFrameCount delayTime:kDelayTime loopCount:kLoopCount];
    self.gifURL = [regift createGif];
    [self saveGif];
}

-(void)saveGif {
    Gif *newGif = [[Gif alloc] initWithUrl:self.gifURL caption:@"default"];
    [self displayGif:newGif];
}

-(void)displayGif:(Gif*)gif {
   GifEditorViewController *gifEditorVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GifEditorViewController"];
    gifEditorVC.gif = gif;
    
    [self dismissViewControllerAnimated:TRUE completion:nil];
    [self.navigationController pushViewController:gifEditorVC animated:true];


}

// Allows Editing
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    CFStringRef mediaType = (__bridge CFStringRef)([info objectForKey:UIImagePickerControllerMediaType]);
    //[self dismissViewControllerAnimated:TRUE completion:nil];
    
    // Handle a movie capture
    if (mediaType == kUTTypeMovie) {
        
        NSURL *rawVideoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        // Get start and end points from trimmed video
        NSNumber *start = [info objectForKey:@"_UIImagePickerControllerVideoEditingStart"];
        NSNumber *end = [info objectForKey:@"_UIImagePickerControllerVideoEditingEnd"];

        // If start and end are nil then clipping was not used.
        if (start != nil) {
            int startMilliseconds = ([start doubleValue] * 1000);
            int endMilliseconds = ([end doubleValue] * 1000);
        
            // Use AVFoundation to trim the video
            AVURLAsset *videoAsset = [AVURLAsset URLAssetWithURL:rawVideoURL options:nil];
            NSString *outputURL = [RecordVideoViewController createPath];
            AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:AVAssetExportPresetHighestQuality];
            AVAssetExportSession *trimmedSession = [RecordVideoViewController configureExportSession:exportSession outputURL:outputURL startMilliseconds:startMilliseconds endMilliseconds:endMilliseconds];

            // Export trimmed video
            [trimmedSession exportAsynchronouslyWithCompletionHandler:^{
                switch (trimmedSession.status) {
                    case AVAssetExportSessionStatusCompleted:
                        // Custom method to import the Exported Video
                        self.videoURL = trimmedSession.outputURL;
                        [self convertVideoToGif];
                        break;
                    case AVAssetExportSessionStatusFailed:
                        //
                        NSLog(@"Failed:%@",trimmedSession.error);
                        break;
                    case AVAssetExportSessionStatusCancelled:
                        //
                        NSLog(@"Canceled:%@",trimmedSession.error);
                        break;
                    default:
                        break;
                }
            }];

            // If video was not trimmed, use the entire video.
        } else {
            self.videoURL = rawVideoURL;
            [self convertVideoToGif];
        }
    }
}




@end
