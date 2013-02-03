//
//  NSXMLElement+PrettyPrint.m
//  xmpptestproj
//
//  Created by Paul Melnikow on 2/2/13.
//  Copyright (c) 2013 Midstate Spring. All rights reserved.
//

#import "NSXMLNode+PrettyPrint.h"

#define NSXMLNodePrettyPrintEnabled 1
#define UseAsterisks 0

#if NSXMLNodePrettyPrintEnabled

@implementation NSXMLElement (PrettyPrint)

+ (NSString *)node:(NSXMLNode *) node descriptionWithIndent:(NSString *)indent {
    
	NSMutableString *s = [NSMutableString string];
    
    if ([node isKindOfClass:[NSXMLElement class]]) {
#if UseAsterisks
        [s appendFormat:@"%@* %@", indent, node.name];
#else
        [s appendFormat:@"%@<%@", indent, node.name];
#endif
        for (NSXMLNode *attribute in [(NSXMLElement *) node attributes]) {
#if UseAsterisks
            [s appendFormat:@" %@='%@'", attribute.name, attribute.stringValue];
#else
            [s appendFormat:@" %@=\"%@\"", attribute.name, attribute.stringValue];
#endif
        }
    
        if (node.childCount) {
#if UseAsterisks
//            [s appendString:@"\n"];
#else
            [s appendString:@">"];
#endif
            
#if UseAsterisks
            NSString *childIndent = [indent stringByAppendingString:@"   "];
#else
            NSString *childIndent = [indent stringByAppendingString:@"    "];
#endif
            
            for (NSXMLElement *child in node.children)
                [s appendFormat:@"\n%@", [self node:child descriptionWithIndent:childIndent]];
            
#if !UseAsterisks
            [s appendFormat:@"\n%@</%@>", indent, node.name];
#endif
        }
    }
	else if (node.stringValue.length) {
		[s appendFormat:@"%@%@", indent, node.stringValue];
	}
#if !UseAsterisks
	else [s appendString:@"/>"];
#endif
    
	return s;
}

- (NSString *)description
{
    NSLog(@"original: %@", [super description]);
    NSLog(@"mine: %@", [self.class node:self descriptionWithIndent:@""]);
    return @"foo";
}

@end

#endif
