//
//  DataInputOutputStream.h
//  Minecraft
//
//  Created by Alex Roth on 11-08-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface DataInputOutputStream : NSObject <NSStreamDelegate> {

NSInputStream *inputStream;
NSOutputStream *outputStream;

}
-(BOOL)connectToHost:(NSString*)hostname:(int)port;
- (void)writeInt:(uint32_t)send;
-(uint32_t)readInt;
- (void)writeShort:(short)send;
-(short)readShort;
- (void)writeByte:(uint8_t)send;
-(uint8_t)readByte;
- (void)writeLong:(long)send;
-(long)readLong;
-(double)readDouble;
- (unichar)readChar;
- (void)writeChar:(unichar)tosend;
-(NSString*)readString;
-(boolean_t)readBool;
-(void)writeBool:(boolean_t)value;
-(void)writeDouble:(double)sendDouble;
-(void)writeFloat:(float)sendFloat;
-(void)writeString:(NSString*)tosendstring;
-(float)readFloat;
//TODO: writeStringUTF16
//TODO:read/writeStringUTF8

@end


