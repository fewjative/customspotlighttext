@interface UISearchField : UITextField
@end

#define SYS_VER_GREAT_OR_EQUAL(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:64] != NSOrderedAscending)

static NSString* SLtext = @"";
static NSString* orig_placeholder = nil;
static BOOL runOnce = NO;

%hook SBSearchField

-(void)layoutSubviews{

	%orig;

	if(!runOnce)
	{
		orig_placeholder = [[NSString alloc] initWithString:[self placeholder]];
		NSLog(@"[CSLT]Original placeholder text has been set.");
		runOnce = YES;
	}

	if(runOnce)
	{
		if([SLtext length] !=0 && ![SLtext isEqualToString:@""])
		{
			NSLog(@"[CSLT]Setting custom text.");
			[self setPlaceholder:SLtext];
		}
		else
		{
			NSLog(@"[CSLT]Setting original placeholder.");
			[self setPlaceholder:orig_placeholder];
		}
	}
}

%end

static void loadPrefs() 
{
    NSLog(@"Loading CustomSpotlightText prefs");
    CFPreferencesAppSynchronize(CFSTR("com.joshdoctors.customspotlighttext"));

    SLtext = (NSString*)CFPreferencesCopyAppValue(CFSTR("SLtext"), CFSTR("com.joshdoctors.customspotlighttext")) ?: @"";
    [SLtext retain];
    NSLog(@"Custom Text: %@",SLtext);
}

%ctor 
{
	NSLog(@"Loading CustomSpotlightText"); 
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                NULL,
                                (CFNotificationCallback)loadPrefs,
                                CFSTR("com.joshdoctors.customspotlighttext/settingschanged"),
                                NULL,
                                CFNotificationSuspensionBehaviorDeliverImmediately);
    loadPrefs();
}