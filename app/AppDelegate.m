#import "AppDelegate.h"
#import "Worker.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  Worker *worker = [[Worker alloc] init];

  [worker start];

  return YES;
}

@end
