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
    NSLog(@"%@", [handle availableData]);
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

@end
