@interface UISearchField : UITextField
@end

%hook SBSearchHeader

-(id)initWithFrame:(CGRect)frame{
	%log; id r = %orig; NSLog(@"initWithFrame : %@",r);
	UISearchField *sf = MSHookIvar<UISearchField *>(self,"_searchField");
	UITextField *tf = (UITextField*)sf;
	tf.placeholder = @"Custom Text";

	return r;
}

%end