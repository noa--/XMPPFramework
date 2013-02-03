//
//  NSXMLElement+PrettyPrint.m
//  xmpptestproj
//
//  Created by Paul Melnikow on 2/2/13.
//  Copyright (c) 2013 Midstate Spring. All rights reserved.
//

// Inspired by https://bugs.freedesktop.org/show_bug.cgi?id=32819
// http://pastebin.com/rKH9UDEe

#import "NSXMLNode+PrettyPrint.h"

#define NSXMLNodePrettyPrintEnabled 1
#define UseSimplifiedOutput YES

#if NSXMLNodePrettyPrintEnabled

@implementation NSXMLElement (PrettyPrint)

+ (NSString *)_descriptionForNode:(NSXMLNode *) node indent:(NSString *) indent simplified:(BOOL) simplified {
	NSMutableString *result = [NSMutableString string];
    NSString *childIndent = [indent stringByAppendingString:@"    "];

    if (simplified) {
        
        if ([node isKindOfClass:[NSXMLElement class]]) {
            [result appendFormat:@"%@* %@", indent, node.name];
            for (NSXMLNode *attribute in [(NSXMLElement *) node attributes])
                [result appendFormat:@" %@='%@'", attribute.name, attribute.stringValue];
            for (NSXMLElement *child in node.children)
                [result appendFormat:@"\n%@", [self _descriptionForNode:child
                                                                 indent:childIndent
                                                             simplified:simplified]];
        }
        else if (node.stringValue.length)
            [result appendFormat:@"%@%@", indent, node.stringValue];
        
    } else {
        
        if ([node isKindOfClass:[NSXMLElement class]]) {
            [result appendFormat:@"%@<%@", indent, node.name];
            for (NSXMLNode *attribute in [(NSXMLElement *) node attributes])
                [result appendFormat:@" %@=\"%@\"", attribute.name, attribute.stringValue];
            
            if (node.childCount) {
                [result appendString:@">"];
                NSString *childIndent = [indent stringByAppendingString:@"    "];
                for (NSXMLElement *child in node.children)
                    [result appendFormat:@"\n%@", [self _descriptionForNode:child
                                                                     indent:childIndent
                                                                 simplified:simplified]];
                [result appendFormat:@"\n%@</%@>", indent, node.name];
            }
        }
        else if (node.stringValue.length)
            [result appendFormat:@"%@%@", indent, node.stringValue];
        else
            [result appendString:@"/>"];

    }
    
	return result;
}

- (NSString *)description
{
    return [self.class _descriptionForNode:self indent:@"" simplified:UseSimplifiedOutput];
}

@end

#endif
