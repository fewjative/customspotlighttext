@interface UISearchField : UITextField
@end

static NSString* SLtext = @"";
static NSString* orig_placeholder = nil;
static BOOL runOnce = NO;

%hook SBSearchHeader

-(id)initWithFrame:(CGRect)frame{

	id r = %orig;

	UISearchField *sf = MSHookIvar<UISearchField *>(self,"_searchField");
	UITextField *tf = (UITextField*)sf;

	if(!runOnce)
	{
		orig_placeholder = [[NSString alloc] initWithString:tf.placeholder];
		NSLog(@"PLACEHOLDER: %@",orig_placeholder);
		runOnce = YES;
	}

	

	if([SLtext length] !=0)
	{	
		tf.placeholder = [[NSString alloc] initWithString:SLtext];
	}

	return r;
}

-(void)layoutSubviews{
	%log;
	%orig;

	UISearchField *sf = MSHookIvar<UISearchField *>(self,"_searchField");
	UITextField *tf = (UITextField*)sf;

	if([SLtext length] !=0)
	{		
		tf.placeholder = [[NSString alloc] initWithString:SLtext];
	}
	else
	{
		NSLog(@"NOTEXT");
		tf.placeholder = [[NSString alloc] initWithString:orig_placeholder];
	}

}

%end

static void loadPrefs() 
{
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.joshdoctors.customspotlighttext.plist"];

    if(prefs)
    {
        SLtext = ( [prefs objectForKey:@"SLtext"] ? [prefs objectForKey:@"SLtext"] : SLtext );
        [SLtext retain];
    }
    [prefs release];
}

%ctor 
{
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.joshdoctors.customspotlighttext/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    loadPrefs();
}