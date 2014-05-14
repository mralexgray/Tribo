//
//  AZWebPreviewViewController.m
//  Tribo
//
//  Created by Alex Gray on 9/25/13.
//  Copyright (c) 2013 Opt-6 Products, LLC. All rights reserved.
//

#import "AZWebPreviewViewController.h"


@implementation AZWebPreviewViewController
@end
@implementation ACEView (AZACEView) 
//@dynamic URL, content;

//+ (instancetype) viewWithFrame:(NSR)r withContent:(id)stuff mode:(ACEMode)m { AZACEView *aceView = [self.alloc initWithFrame:r];
//- (void) awakeFromNib {
//}	

- (void) setURL:(NSURL*)URL {

//   NSString*mode =[self performString:@"stringByEvaluatingJavaScriptOnMainThreadFromString:"
//									withObject:$(@"editor.getModeForPath(%@);", URL.absoluteString)];
//	self.mode = [ACEModeNames modeFromString:mode];

//	XX(self.mode);
//	XX([ACEModeNames humanNameForMode:self.mode]);
	NSS* s = [NSS stringWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:nil];
//	XX([self string]);
	XX(self.frame);
	[self setStringValue: s];

}
//- (NSS*) evaluate:(NSS*)script {
//
//	return [self performString:@"stringByEvaluatingJavaScriptOnMainThreadFromString:" withObject:script];
//}
//- (ACEMode) mode {

//	return ACEModeHandlebars;
//	NSString *m = [self evaluate:@"editor.getSession().session.getMode();"];
//	XX(m);
//	return [ACEModeNames modeFromString:m];
//}
- (void) textDidChange:(NSNotification*)notification {
	NSLog(@"%s", __PRETTY_FUNCTION__);
}

//- (void) setContent:(id)x { //mode:(ACEMode)m { 
//	
//	AZBlockSelf(me);
//												   : [x ISKINDA:NSS.class] ? x : nil;
//  	
//	[x ISKINDA:NSURL.class]	? ^{
//		me.string = [NSS stringWithContentsOfURL:x encoding:NSUTF8StringEncoding error:nil];
//		me.mode   = [x path].pathExtension == 
//
//}(): 
//														   : [x ISKINDA:NSS.class] ? x : nil;
//	self.theme					= ACEThemeTomorrowNight;
//	self.showInvisibles 		= YES;
//}


//- (void) applicationDidFinishLaunching:(NSNotification*)aNotification {
//	NSString *htmlFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"HTML5" ofType:@"html"];
//	NSString *html = [NSString stringWithContentsOfFile:htmlFilePath encoding:NSUTF8StringEncoding error:nil];
//	[aceView setString:html];
//	//    [aceView setString:[NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://github.com/faceleg/ACEView"] encoding:NSUTF8StringEncoding
//	//                                                   error:nil]];
//	[aceView setDelegate:self];
//	[aceView setMode:ACEModeHTML];
//	[aceView setTheme:ACEThemeXcode];
//	[aceView setShowPrintMargin:NO];
//	[aceView setShowInvisibles:YES];
//}
//
//- (void) awakeFromNib {
//	[syntaxMode addItemsWithTitles:[ACEModeNames humanModeNames]];
//	[syntaxMode selectItemAtIndex:ACEModeHTML];
//	
//	[theme addItemsWithTitles:[ACEThemeNames humanThemeNames]];
//	[theme selectItemAtIndex:ACEThemeXcode];
//}
//
//- (IBAction) syntaxModeChanged:(id)sender {
//	[aceView setMode:[syntaxMode indexOfSelectedItem]];
//}
//
//- (IBAction) themeChanged:(id)sender {
//	[aceView setTheme:[theme indexOfSelectedItem]];
//}
//
//- (void) textDidChange:(NSNotification*)notification {
//	// Handle text changes
//	NSLog(@"%s", __PRETTY_FUNCTION__);
//}



//- (NSString*)defaultNibName {
//	return @"AZWebPreviewView";
//}
//
//- (NSString*)title {
//	return @"Preview";
//}
//
//- (void)awakeFromNib {
//    [self.tableView setTarget:self];
//    [self.tableView setDoubleAction:@selector(doubleClickRow:)];
//}
//
//- (NSA*)templates {
//    NSA*nameSort = @[[NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES]];
//    return [self.document.site.templateAssets sortedArrayUsingDescriptors:nameSort];
//}
//
//- (void)doubleClickRow:(NSOutlineView*)outlineView {
//    NSA*assets = [self.assets selectedObjects];
//    NSA*assetURLS = [assets valueForKey:@"URL"];
//    [assetURLS enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        NSA*singleFileArray = @[obj];
//        BOOL fileOpened = [[NSWorkspace sharedWorkspace] openURLs:singleFileArray withAppBundleIdentifier:nil options:NSWorkspaceLaunchAsync additionalEventParamDescriptor:nil launchIdentifiers:NULL];
//        if(!fileOpened){
//            [[NSWorkspace sharedWorkspace] openURLs:singleFileArray withAppBundleIdentifier:@"com.apple.TextEdit" options:NSWorkspaceLaunchAsync additionalEventParamDescriptor:nil launchIdentifiers:NULL];
//        }
//    }];
//}
//

@end


