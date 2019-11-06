#import "SaveImage.h"
#import <Cordova/CDV.h>

@implementation SaveImage
@synthesize callbackId;

- (void)saveImageToGallery:(CDVInvokedUrlCommand*)command {
	[self.commandDelegate runInBackground:^{
	    self.callbackId = command.callbackId;

		NSString *imgAbsolutePath = [command.arguments objectAtIndex:0];
        NSString *orientation = [command.arguments objectAtIndex:1];

        NSLog(@"Image absolute path: %@", imgAbsolutePath);
        
        UIImage *image = [UIImage imageWithContentsOfFile:imgAbsolutePath];
        if (![orientation  isEqual: @"0"]){
            UIImageOrientation io;
            if([orientation  isEqual: @"90"]){
                io = UIImageOrientationRight;
               }else if([orientation  isEqual: @"180"]){
                io = UIImageOrientationDown;
            }else {
                io = UIImageOrientationLeft;
            }
            UIImage *i2 = [[UIImage alloc] initWithCGImage:image.CGImage scale:1.0 orientation:io];
            image = i2;
        }
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
	}];
}

- (void)dealloc {
	[callbackId release];
    [super dealloc];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    // Was there an error?
    if (error != NULL) {
        NSLog(@"SaveImage, error: %@",error);
		CDVPluginResult* result = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:error.description];
		[self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
    } else {
        // No errors

        // Show message image successfully saved
        NSLog(@"SaveImage, image saved");
		CDVPluginResult* result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsString:@"Image saved"];
		[self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
    }
}

@end
