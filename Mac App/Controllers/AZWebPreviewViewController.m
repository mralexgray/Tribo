//
//  AZWebPreviewViewController.m
//  Tribo
//
//  Created by Alex Gray on 9/25/13.
//  Copyright (c) 2013 Opt-6 Products, LLC. All rights reserved.
//

#import "AZWebPreviewViewController.h"

@interface AZWebPreviewViewController ()

@end

@implementation AZWebPreviewViewController


//- (NSString *)defaultNibName {
//	return @"AZWebPreviewView";
//}
//
//- (NSString *)title {
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
//- (void)doubleClickRow:(NSOutlineView *)outlineView {
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


