CocoaDataInputOutputStream
==========================

Interfacing Objective-C/Cocoa apps with Java's DataInput/DataOutput streams.


Example
--------

```
DataInputOutputStream* DIOS = [[DataInputOutputStream alloc] init];
[DIOS connectToHost:@"localhost" port:2999];

[DIOS writeInt:39943];
NSLog(@"%d", [DIOS readByte]);

```

Be forewarned, read methods block! This library was written for an app with a hard-set protocol, with very constantly moving, fixed-length data!

The available methods are:
```
-(BOOL)connectToHost:(NSString*)hostname port:(int)port;
-(void)writeInt:(uint32_t)send;
-(uint32_t)readInt;
-(void)writeShort:(short)send;
-(short)readShort;
-(void)writeByte:(uint8_t)send;
-(uint8_t)readByte;
-(void)writeLong:(long)send;
-(long)readLong;
-(double)readDouble;
-(unichar)readChar;
-(void)writeChar:(unichar)tosend;
-(NSString*)readString;
-(boolean_t)readBool;
-(void)writeBool:(boolean_t)value;
-(void)writeDouble:(double)sendDouble;
-(void)writeFloat:(float)sendFloat;
-(float)readFloat;

-(void)writeString:(NSString*)tosendstring;

```