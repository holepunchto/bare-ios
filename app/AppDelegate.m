#import <BareKit/BareKit.h>

#import "AppDelegate.h"

#import "app.bundle.h"

@implementation AppDelegate {
  BareWorklet *worklet;
  BareIPC *ipc;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  worklet = [[BareWorklet alloc] init];

  [worklet start:@"/main.bundle"
          source:[NSData dataWithBytes:bundle length:bundle_len]];

  ipc = [[BareIPC alloc] initWithWorklet:worklet];

  [ipc read:NSUTF8StringEncoding
    completion:^(NSString *data) {
      NSLog(@"%@", data);
    }];

  [ipc write:@"Hello from iOS" encoding:NSUTF8StringEncoding];

  return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  [worklet suspend];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  [worklet resume];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  [ipc close];
  [worklet terminate];
}

@end
