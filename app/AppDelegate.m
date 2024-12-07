#import <BareKit/BareKit.h>

#import "AppDelegate.h"

@implementation AppDelegate {
  BareWorklet *worklet;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSURL *url = [[NSBundle mainBundle] URLForResource:@"app" withExtension:@"bundle"];

  worklet = [[BareWorklet alloc] initWithConfiguration:nil];

  [worklet start:[url path] source:nil arguments:nil];

  return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  [worklet suspend];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  [worklet resume];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  [worklet terminate];
}

@end
