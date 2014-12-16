@interface UISearchField : UITextField
@end

#define SYS_VER_GREAT_OR_EQUAL(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:64] != NSOrderedAscending)

static NSString* SLtext = @"";

%group iOS8

%hook SBSearchField

-(void)setPlaceholder:(NSString*)text
{
	NSLog(@"setPlaceholder");

	if([SLtext length] !=0)
	{	
		NSLog(@"[CustomSpotlightText]Valid custom spotlight text.");	
		return %orig(SLtext);
	}
	else
	{
		NSLog(@"[CustomSpotlightText]No custom spotlight text.");
		return %orig(text);
	}
}

%end

%end

%group iOS7

static NSString* orig_placeholder = nil;
static BOOL runOnce = NO;

%hook SBSearchField

-(void)layoutSubviews{
	NSLog(@"runOnce %d",(long)runOnce);
	NSLog(@"placeholder: %@",[self placeholder]);

	%orig;

	if(!runOnce)
	{
		orig_placeholder = [[NSString alloc] initWithString:[self placeholder]];
		NSLog(@"CSLT Placeholder text has been set.");
		runOnce = YES;
	}

	if(runOnce)
	{
		if([SLtext length] !=0)
		{		
			[self setPlaceholder:SLtext];
		}
		else
		{
			[self setPlaceholder:orig_placeholder];
		}
	}
}

%end

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

    if([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
	{
		%init(iOS7);
	}
	else
		%init(iOS8);

    loadPrefs();
}