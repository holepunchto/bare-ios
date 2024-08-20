#import <BareKit/BareKit.h>

#import "AppDelegate.h"

@implementation AppDelegate {
  BareWorklet *worklet;
  BareIPC *ipc;
  BareRPC *rpc;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSURL *url = [[NSBundle mainBundle] URLForResource:@"app" withExtension:@"bundle"];

  worklet = [[BareWorklet alloc] init];

  [worklet start:[url path]];

  ipc = [[BareIPC alloc] initWithWorklet:worklet];

  BareRPCRequestHandler requestHandler = ^(BareRPCIncomingRequest *req, NSError *error) {
    if ([req.command isEqualToString:@"ping"]) {
      CFShow([req dataWithEncoding:NSUTF8StringEncoding]);

      [req reply:@"Pong from iOS" encoding:NSUTF8StringEncoding];
    }
  };

  rpc = [[BareRPC alloc] initWithIPC:ipc requestHandler:requestHandler];

  BareRPCOutgoingRequest *req = [rpc request:@"ping"];

  [req send:@"Ping from iOS" encoding:NSUTF8StringEncoding];

  [req reply:NSUTF8StringEncoding
    completion:^(NSString *data, NSError *error) {
      CFShow(data);
    }];

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
