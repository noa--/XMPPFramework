#import "XMPPMessageArchivingCoreDataStorageObject.h"


@interface XMPPMessageArchivingCoreDataStorageObject ()

@property(nonatomic,strong) XMPPMessage * primitiveMessage;
@property(nonatomic,strong) NSString * primitiveMessageStr;

@property(nonatomic,strong) XMPPJID * primitiveBareJid;
@property(nonatomic,strong) NSString * primitiveBareJidStr;

@end

@implementation XMPPMessageArchivingCoreDataStorageObject

@dynamic message, primitiveMessage;
@dynamic messageStr, primitiveMessageStr;
@dynamic bareJid, primitiveBareJid;
@dynamic bareJidStr, primitiveBareJidStr;
@dynamic outgoing;
@dynamic thread;
@dynamic streamBareJidStr;

#pragma mark Transient message

- (XMPPMessage *)message
{
	// Create and cache on demand
	
	[self willAccessValueForKey:@"message"];
	XMPPMessage *message = self.primitiveMessage;
	[self didAccessValueForKey:@"message"];
	
	if (message == nil)
	{
		NSString *messageStr = self.messageStr;
		if (messageStr)
		{
			NSXMLElement *element = [[NSXMLElement alloc] initWithXMLString:messageStr error:nil];
			message = [XMPPMessage messageFromElement:element];
			self.primitiveMessage = message;
		}
    }
	
    return message;
}

- (void)setMessage:(XMPPMessage *)message
{
	[self willChangeValueForKey:@"message"];
	[self willChangeValueForKey:@"messageStr"];
	
	self.primitiveMessage = message;
	self.primitiveMessageStr = [message compactXMLString];
	
	[self didChangeValueForKey:@"message"];
	[self didChangeValueForKey:@"messageStr"];
}

- (void)setMessageStr:(NSString *)messageStr
{
	[self willChangeValueForKey:@"message"];
	[self willChangeValueForKey:@"messageStr"];
	
	NSXMLElement *element = [[NSXMLElement alloc] initWithXMLString:messageStr error:nil];
	self.primitiveMessage = [XMPPMessage messageFromElement:element];
	self.primitiveMessageStr = messageStr;
	
	[self didChangeValueForKey:@"message"];
	[self didChangeValueForKey:@"messageStr"];
}

#pragma mark Transient bareJid

- (XMPPJID *)bareJid
{
	// Create and cache on demand
	
	[self willAccessValueForKey:@"bareJid"];
	XMPPJID *tmp = self.primitiveBareJid;
	[self didAccessValueForKey:@"bareJid"];
	
	if (tmp == nil)
	{
		NSString *bareJidStr = self.bareJidStr;
		if (bareJidStr)
		{
			tmp = [XMPPJID jidWithString:bareJidStr];
			self.primitiveBareJid = tmp;
		}
	}
	
	return tmp;
}

- (void)setBareJid:(XMPPJID *)bareJid
{
	[self willChangeValueForKey:@"bareJid"];
	[self willChangeValueForKey:@"bareJidStr"];
	
	self.primitiveBareJid = bareJid;
	self.primitiveBareJidStr = [bareJid bare];
	
	[self didChangeValueForKey:@"bareJid"];
	[self didChangeValueForKey:@"bareJidStr"];
}

- (void)setBareJidStr:(NSString *)bareJidStr
{
	[self willChangeValueForKey:@"bareJid"];
	[self willChangeValueForKey:@"bareJidStr"];
	
	self.primitiveBareJid = [XMPPJID jidWithString:bareJidStr];
	self.primitiveBareJidStr = bareJidStr;
	
	[self didChangeValueForKey:@"bareJid"];
	[self didChangeValueForKey:@"bareJidStr"];
}

@end
