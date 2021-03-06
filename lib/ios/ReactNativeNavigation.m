#import "ReactNativeNavigation.h"

#import <React/RCTUIManager.h>

#import "RNNBridgeManager.h"
#import "RNNSplashScreen.h"

@interface ReactNativeNavigation()

@property (nonatomic, strong) RNNBridgeManager *bridgeManager;

@end

@implementation ReactNativeNavigation

# pragma mark - public API

+(void)bootstrap:(NSURL *)jsCodeLocation launchOptions:(NSDictionary *)launchOptions {
	[[ReactNativeNavigation sharedInstance] bootstrap:jsCodeLocation launchOptions:launchOptions];
}

+(void)bootstrap:(NSURL *)jsCodeLocation launchOptions:(NSDictionary *)launchOptions bridgeManagerDelegate:(id<RNNBridgeManagerDelegate>)delegate {
	[[ReactNativeNavigation sharedInstance] bootstrap:jsCodeLocation launchOptions:launchOptions bridgeManagerDelegate:delegate];
}

+ (void)registerExternalComponent:(NSString *)name callback:(RNNExternalViewCreator)callback {
	[[ReactNativeNavigation sharedInstance].bridgeManager registerExternalComponent:name callback:callback];
}

+ (RCTBridge *)getBridge {
	return [[ReactNativeNavigation sharedInstance].bridgeManager bridge];
}

+ (UIViewController *)findViewController:(NSString *)componentId {
    RNNStore *store = [[ReactNativeNavigation sharedInstance].bridgeManager store];
    return [store findComponentForId:componentId];
}

# pragma mark - instance

+ (instancetype) sharedInstance {
	static ReactNativeNavigation *instance = nil;
	static dispatch_once_t onceToken = 0;
	dispatch_once(&onceToken,^{
		if (instance == nil) {
			instance = [[ReactNativeNavigation alloc] init];
		}
	});
	
	return instance;
}

-(void)bootstrap:(NSURL *)jsCodeLocation launchOptions:(NSDictionary *)launchOptions {
	[self bootstrap:jsCodeLocation launchOptions:launchOptions bridgeManagerDelegate:nil];
}

-(void)bootstrap:(NSURL *)jsCodeLocation launchOptions:(NSDictionary *)launchOptions bridgeManagerDelegate:(id<RNNBridgeManagerDelegate>)delegate {
	UIWindow* mainWindow = [self initializeKeyWindow];
	
	self.bridgeManager = [[RNNBridgeManager alloc] initWithJsCodeLocation:jsCodeLocation launchOptions:launchOptions bridgeManagerDelegate:delegate mainWindow:mainWindow];
	[RNNSplashScreen showOnWindow:mainWindow];
}

- (UIWindow *)initializeKeyWindow {
	UIWindow* keyWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	keyWindow.backgroundColor = [UIColor whiteColor];
	UIApplication.sharedApplication.delegate.window = keyWindow;
	
	return keyWindow;
}

@end
