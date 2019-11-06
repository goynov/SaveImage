#import "SaveImage.h"
#import <Cordova/CDV.h>

@implementation SaveImage
@synthesize callbackId;

- (void)saveImageToGallery:(CDVInvokedUrlCommand*)command {
	[self.commandDelegate runInBackground:^{
	    self.callbackId = command.callbackId;

		NSString *imgAbsolutePath = [command.arguments objectAtIndex:0];
        NSNumber *orientation = [command.arguments objectAtIndex:1];

        NSLog(@"Image absolute path: %@", imgAbsolutePath);
        
        UIImage *i0 = [UIImage imageWithContentsOfFile:imgAbsolutePath];
        
        UIImageOrientation io;
        switch(orientation.intValue){
            case 90: io = UIImageOrientationRight; break;
            case 180: io = UIImageOrientationDown; break;
            case 270: io = UIImageOrientationLeft; break;
            default: io = UIImageOrientationUp;
        }
        UIImage *image = [[UIImage alloc] initWithCGImage:i0.CGImage scale:1.0 orientation:io];
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
