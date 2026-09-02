#if defined(THEOS_PACKAGE_SCHEME_ROOTHIDE)
#import <roothide.h>
#define DX_ROOT_PATH_NS(path) jbroot(path)
#else
#import <rootless.h>
#define DX_ROOT_PATH_NS(path) ROOT_PATH_NS(path)
#endif

#define copyLogDylib DX_ROOT_PATH_NS(@"/Library/MobileSubstrate/DynamicLibraries/CopyLog.dylib")
#define translomaticDylib DX_ROOT_PATH_NS(@"/Library/MobileSubstrate/DynamicLibraries/Translomatic.dylib")
#define wasabiDylib DX_ROOT_PATH_NS(@"/Library/MobileSubstrate/DynamicLibraries/Wasabi.dylib")
#define pasitheaDylib DX_ROOT_PATH_NS(@"/Library/MobileSubstrate/DynamicLibraries/Pasithea2.dylib")
#define copypastaDylib DX_ROOT_PATH_NS(@"/Library/MobileSubstrate/DynamicLibraries/Copypasta.dylib")
#define loupeDylib DX_ROOT_PATH_NS(@"/Library/MobileSubstrate/DynamicLibraries/Loupe.dylib")
#define tranzloDylib DX_ROOT_PATH_NS(@"/Library/MobileSubstrate/DynamicLibraries/Tranzlo.dylib")

@interface DXShortcutsGenerator : NSObject
@property (nonatomic, assign) BOOL copyLogDylibExist;
@property (nonatomic, assign) BOOL translomaticDylibExist;
@property (nonatomic, assign) BOOL wasabiDylibExist;
@property (nonatomic, assign) BOOL pasitheaDylibExist;
@property (nonatomic, assign) BOOL copypastaDylibExist;
@property (nonatomic, assign) BOOL loupeDylibExist;
@property (nonatomic, assign) BOOL tranzloDylibExist;
+(void)load;
+(instancetype)sharedInstance;
-(instancetype)init;
-(NSArray *)imageNameArrayForiOS:(NSInteger)iosVersion;
-(NSArray *)selectorNameForLongPress:(BOOL)longPress;
-(NSArray *)labelName;
-(NSArray *)shortenedlabelName;
-(BOOL)dylibExist:(NSString *)dylibPath manager:(NSFileManager *)fileManager;
-(NSArray *)thirdPartyImageNameArray:(NSArray *)array foriOS:(NSInteger)iosVersion;
-(NSArray *)thirdPartySelectorNameArray:(NSArray *)array longPress:(BOOL)longPress;
-(NSArray *)thirdPartyLabelNameArray:(NSArray *)array;
-(NSArray *)thirdPartyShortenedLabelNameArray:(NSArray *)array;
-(NSArray *)keyboardTypeLabel;
-(NSArray *)keyboardTypeData;
@end
