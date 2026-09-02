export ARCHS = arm64 arm64e

# iOS 16 and later use the rootless jailbreak layout on supported devices.
TARGET ?= iphone:clang:17.0:16.0
THEOS_PACKAGE_SCHEME ?= rootless
export TARGET THEOS_PACKAGE_SCHEME

export DEBUG = 0
export FINALPACKAGE = 1

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ADockX

ADockX_FILES = $(wildcard *.x) $(wildcard *.m) $(wildcard *.mm) $(wildcard *.xm)
ADockX_CFLAGS = -fobjc-arc
ADockX_LIBRARIES = rocketbootstrap sparkcolourpicker
ADockX_FRAMEWORKS = UIKit CoreGraphics CoreImage QuartzCore
ADockX_PRIVATE_FRAMEWORKS = AppSupport Preferences
ADockX_LDFLAGS = -Wl,-U,_showCopypastaWithNotification -Wl,-U,_flipLoupeEnableSwitch -Wl,-U,_loupeSwitchState

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += dockxprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
