#import "common.h"
#import "DXPrefsManager.h"

static void reloadPrefs(CFNotificationCenterRef center, void *observer, CFStringRef name,
                        const void *object, CFDictionaryRef userInfo) {
    [(__bridge DXPrefsManager *)observer reload];
}

@implementation DXPrefsManager

+ (void)load {
    @autoreleasepool {
        NSArray *args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
        if (args.count == 0) return;

        NSString *executablePath = args[0];
        NSString *processName = executablePath.lastPathComponent;
        BOOL isSpringBoardProcess = [processName isEqualToString:@"SpringBoard"];
        BOOL isApplicationProcess = [executablePath rangeOfString:@"/Application"].location != NSNotFound;
        if (isSpringBoardProcess || isApplicationProcess) [DXPrefsManager sharedInstance];
    }
}

+ (instancetype)sharedInstance {
    static dispatch_once_t predicate;
    static DXPrefsManager *manager;
    dispatch_once(&predicate, ^{ manager = [[self alloc] init]; });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                         (__bridge const void *)self, &reloadPrefs,
                                         (CFStringRef)kPrefsChangedIdentifier, NULL, 0);
        self.prefs = [self readPrefs];
    }
    return self;
}

- (NSDictionary *)readPrefsFromSandbox:(BOOL)isSandbox {
    return [self readPrefs];
}

- (NSDictionary *)readPrefs {
    return [NSDictionary dictionaryWithContentsOfFile:kPrefsPath] ?: @{};
}

- (void)writePrefs:(NSDictionary *)dictionary fromSandbox:(BOOL)isSandbox {
    [self writePrefs:dictionary];
}

- (void)writePrefs:(NSDictionary *)dictionary {
    if (![dictionary writeToFile:kPrefsPath atomically:YES]) return;
    self.prefs = dictionary;
    [self postChangedNotification];
}

- (void)setValue:(id)value forKey:(NSString *)key fromSandbox:(BOOL)isSandbox {
    [self setValue:value forKey:key];
}

- (void)setValue:(id)value forKey:(NSString *)key {
    NSMutableDictionary *dictionary = [[self readPrefs] mutableCopy];
    if (value) dictionary[key] = value;
    else [dictionary removeObjectForKey:key];
    [self writePrefs:dictionary];
}

- (id)getValueForKey:(NSString *)key fromSandbox:(BOOL)isSandbox {
    return [self getValueForKey:key];
}

- (id)getValueForKey:(NSString *)key {
    return [self readPrefs][key];
}

- (void)removeKey:(NSString *)key fromSandbox:(BOOL)isSandbox {
    [self removeKey:key];
}

- (void)removeKey:(NSString *)key {
    [self setValue:nil forKey:key];
}

- (void)postChangedNotification {
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                                          (CFStringRef)kPrefsChangedIdentifier, NULL, NULL, YES);
}

- (void)reload {
    self.prefs = [self readPrefs];
}

- (void)dealloc {
    CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                        (__bridge const void *)self,
                                        (CFStringRef)kPrefsChangedIdentifier, NULL);
}

@end
