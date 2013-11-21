//
//  CCPWorkspaceManager.m
//
//  Copyright (c) 2013 Delisa Mason. http://delisa.me
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.

#import "CCPWorkspaceManager.h"

#import "CCPProject.h"

static NSString *PODFILE = @"Podfile";

@implementation CCPWorkspaceManager

+ (CCPProject *)defaultWorkspace
{
	id workspace = [self workspaceForKeyWindow];
    
	id contextManager = [workspace valueForKey:@"_runContextManager"];
	for (id scheme in[contextManager valueForKey:@"runContexts"]) {
		NSString *schemeName = [scheme valueForKey:@"name"];
		if (![schemeName hasPrefix:@"Pods-"]) {
            NSString *path = [self directoryPathForWorkspace:workspace];
			return [[CCPProject alloc] initWithName:schemeName path:path];
		}
	}
    
	return nil;
}

+ (NSArray *)installedPodNamesInCurrentWorkspace
{
	NSMutableArray *names = [NSMutableArray new];
	id workspace = [self workspaceForKeyWindow];
    
	id contextManager = [workspace valueForKey:@"_runContextManager"];
	for (id scheme in[contextManager valueForKey:@"runContexts"]) {
		NSString *schemeName = [scheme valueForKey:@"name"];
		if ([schemeName hasPrefix:@"Pods-"]) {
			[names addObject:[schemeName stringByReplacingOccurrencesOfString:@"Pods-" withString:@""]];
		}
	}
	return names;
}

+ (NSString *)currentWorkspaceDirectoryPath
{
    return [self directoryPathForWorkspace:[self workspaceForKeyWindow]];
}

+ (NSString *)directoryPathForWorkspace:(id)workspace
{
    NSString *workspacePath = [[workspace valueForKey:@"representingFilePath"] valueForKey:@"_pathString"];
	return [workspacePath stringByDeletingLastPathComponent];
}

#pragma mark - Private

+ (id)workspaceForKeyWindow
{
    return [self workspaceForWindow:[NSApp keyWindow]];
}

+ (id)workspaceForWindow:(NSWindow *)window
{
    NSArray *workspaceWindowControllers = [NSClassFromString(@"IDEWorkspaceWindowController") valueForKey:@"workspaceWindowControllers"];

	for (id controller in workspaceWindowControllers) {
		if ([[controller valueForKey:@"window"] isEqual:window]) {
			return [controller valueForKey:@"_workspace"];
		}
	}
	return nil;
}

@end
