#import <BareKit/BareKit.h>

#import "AppDelegate.h"

#import "main.bundle.h"

@implementation AppDelegate {
  BareWorklet *_worklet;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  _worklet = [[BareWorklet alloc] init];

  [_worklet start:@"/main.bundle"
           source:[NSData dataWithBytes:bundle length:bundle_len]];

  _worklet.incoming.readabilityHandler = ^(NSFileHandle *handle) {
    NSData *data = handle.availableData;

    if (data.length == 0) {
      _worklet.incoming.readabilityHandler = nil;
      return;
    }

    NSLog(@"%.*s", (int) data.length, (char *) data.bytes);
  };

  [_worklet.outgoing writeData:[[NSData alloc]
                                 initWithBytes:"Hello from iOS"
                                        length:14]];

  return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  [_worklet suspend];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  [_worklet resume];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  [_worklet terminate];
}

@end
