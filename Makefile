ARCHS = armv7 arm64
include theos/makefiles/common.mk

TWEAK_NAME = CustomSpotlightText
CustomSpotlightText_FILES = Tweak.xm
CustomSpotlightText_FRAMEWORKS = UIKit
CustomSpotlightText_CFLAGS = -Wno-error

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += cslt
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard"
