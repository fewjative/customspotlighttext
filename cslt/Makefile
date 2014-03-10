ARCHS = armv7 arm64
include theos/makefiles/common.mk

BUNDLE_NAME = CustomSpotlightText
CustomSpotlightText_FILES = CustomSpotlightText.mm
CustomSpotlightText_INSTALL_PATH = /Library/PreferenceBundles
CustomSpotlightText_FRAMEWORKS = UIKit
CustomSpotlightText_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/CustomSpotlightText.plist$(ECHO_END)

include $(THEOS_MAKE_PATH)/aggregate.mk
