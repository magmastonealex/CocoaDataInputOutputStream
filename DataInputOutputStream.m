//
//  DataInputOutputStream.m
//  Minecraft
//
//  Created by Alex Roth on 11-08-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataInputOutputStream.h"
@implementation DataInputOutputStream

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
-(BOOL)connectToHost:(NSString*)hostname:(int)port{
CFReadStreamRef readStream = NULL;
CFWriteStreamRef writeStream = NULL;
CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (CFStringRef)hostname, 25565, &readStream, &writeStream);
if (readStream && writeStream) {
    //Breakpoint here reached
    NSLog(@"OK!");
    inputStream = (NSInputStream *)readStream;
    [inputStream retain];
    [inputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    
    outputStream = (NSOutputStream *)writeStream;
    [outputStream retain];
    [outputStream setDelegate:self];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream open];
    NSLog(@"Done!");
}
    return TRUE;
}
- (void)writeInt:(uint32_t)send{
    NSMutableData * toSendData = [[NSMutableData alloc] initWithCapacity:4];
    uint32_t newSend = htonl(send);
    [toSendData appendBytes:&newSend length:4];
    [outputStream write:[toSendData bytes] maxLength:4];
    [toSendData release];
}

-(boolean_t)readBool{
    uint8_t thebool;
    [inputStream read:&thebool maxLength:1];
    if(thebool == 0x01){
        return TRUE;
    }
    return FALSE;
}
-(void)writeBool:(boolean_t)value{
    uint8_t thebool;
    if(value){
        
        thebool = 0x01;
        [outputStream write:&thebool maxLength:1];
        return;
    }
    thebool = 0x00;
    [outputStream write:&thebool maxLength:1];
}

-(void)writeDouble:(double)sendDouble{
    
    double x = sendDouble;
        const union { double f; uint64_t i; } xUnion = { .f = x };
    uint64_t tosend = xUnion.i;
    
    uint64_t netInt = CFSwapInt64HostToBig(tosend);    // use this for big endian
    
    [outputStream write:(uint8_t*)&netInt maxLength:sizeof(netInt)];
    
}

-(void)writeFloat:(float)sendFloat{
    float x = sendFloat;
    const union { float f; uint32_t i; } xUnion = { .f = x };
    NSMutableData * toSendData = [[NSMutableData alloc] initWithCapacity:4];
    uint32_t newSend = htonl(xUnion.i);
    [toSendData appendBytes:&newSend length:4];
    [outputStream write:[toSendData bytes] maxLength:4];
    [toSendData release];
}

-(float)readFloat{
    uint8_t bytes[4];
    [inputStream read:bytes maxLength:4];
    //  long tmp = [self readLong];
    //  unsigned long long bitPattern = [self readLong];
    //  uint64_t templong = (bytes[0] << 56) | (bytes[1] << 48) | (bytes[2] << 40) | (bytes[3] << 32) | (bytes[4] << 24) | (bytes[5] << 16) | (bytes[6] << 8) | (bytes[7]) ;
    //
    
    // templong = ntohl(templong);
    //NSLog(@"%llu", templong);
    // double myInt = *(double*)&templong;
    uint8_t dstbytes[4];

    dstbytes[0] = bytes[3];
    dstbytes[1] = bytes[2];
    dstbytes[2] = bytes[1];
    dstbytes[3] = bytes[0];
    
    float myInt =  *((float*) dstbytes);
    return myInt;
}


-(double)readDouble{
    NSLog(@"Started reading double...");
    uint8_t bytes[8];
    [inputStream read:bytes maxLength:8];
  //  long tmp = [self readLong];
  //  unsigned long long bitPattern = [self readLong];
  //  uint64_t templong = (bytes[0] << 56) | (bytes[1] << 48) | (bytes[2] << 40) | (bytes[3] << 32) | (bytes[4] << 24) | (bytes[5] << 16) | (bytes[6] << 8) | (bytes[7]) ;
   //
    
   // templong = ntohl(templong);
    //NSLog(@"%llu", templong);
   // double myInt = *(double*)&templong;
    uint8_t dstbytes[8];
    dstbytes[0] = bytes[7];
    dstbytes[1] = bytes[6];
    dstbytes[2] = bytes[5];
    dstbytes[3] = bytes[4];
    dstbytes[4] = bytes[3];
    dstbytes[5] = bytes[2];
    dstbytes[6] = bytes[1];
    dstbytes[7] = bytes[0];
    
    double myInt =  *((double*) dstbytes);
   // myInt = 831748.89371;
   // memcpy(&myInt, &bitPattern, sizeof myInt);
    //uint64_t a = [self readLong];
  
       // double d;
      //  unsigned char *src = (unsigned char *)&a;
      //  unsigned char *dst = (unsigned char *)&d;
        
      //  dst[0] = src[7];
      //  dst[1] = src[6];
      //  dst[2] = src[5];
      //  dst[3] = src[4];
      //  dst[4] = src[3];
      //  dst[5] = src[2];
     //   dst[6] = src[1];
     //   dst[7] = src[0];
  //  uint8_t dst[8];
// dst[0] = buffer[7];
 //   dst[1] = buffer[6];
 //    dst[2] = buffer[5];
 //    dst[3] = buffer[4];
 //    dst[4] = buffer[3];
 //    dst[5] = buffer[2];
 //    dst[6] = buffer[1];
 //    dst[7] = buffer[0];
 //   double myInt = (double)&tmp;//(tmp << 56) | (tmp << 48) | (tmp << 40) | (tmp << 32) | (tmp << 24) | (tmp << 16) | (tmp << 8) | (tmp) ;
    NSLog(@"double: %f", myInt);
    return myInt;
}

-(uint32_t)readInt{
    uint8_t bytes[4];
    [inputStream read:bytes maxLength:4];
    uint32_t myInt = (bytes[0] << 24) | (bytes[1] << 16) | (bytes[2] << 8) | (bytes[3]);
    // convert from (n)etwork endianness to (h)ost endianness (may be a no-op)
    // ntohl is defined in <arpa/inet.h>
    //myInt = ntohl(myInt);
    return myInt;
}
- (void)writeShort:(short)send{
    NSLog(@"%d", send);
    send = CFSwapInt16HostToBig((uint16_t) send);
    NSMutableData* dataToSend = [[NSMutableData alloc] initWithCapacity:2];
    [dataToSend appendBytes:&send length:2];
    NSLog(@"%d", send);
    [outputStream write:[dataToSend bytes] maxLength:2];
    [dataToSend release];
    
}

-(short)readShort{
    uint8_t bytes[2];
    [inputStream read:bytes maxLength:2];
    short myInt = (bytes[0] << 8) | (bytes[1]);
    // convert from (n)etwork endianness to (h)ost endianness (may be a no-op)
    // ntohl is defined in <arpa/inet.h>
    //myInt = ntohl(myInt);
    return myInt;
}

- (void)writeLong:(long)send{
    //NSLog(@"%ld", send);
    // long newsend = CFSwapInt64HostToBig((long) send);
    //     NSLog(@"WHAT?");
    //  }
    //  char* toasend = (char*) &newsend;
    // NSMutableData* dataToSend = [[NSMutableData alloc] initWithCapacity:8];
    //     NSLog(@"%ld", newsend);
    //  [dataToSend appendBytes:&toasend length:8];
    //
    //  [outputStream write:[dataToSend bytes] maxLength:8];
    //  NSLog(@"Done writing");
    uint64_t netInt = CFSwapInt64HostToBig(send);    // use this for big endian
    
    [outputStream write:(uint8_t*)&netInt maxLength:sizeof(netInt)];
    
}
-(long)readLong{
    uint8_t bytes[8];
    [inputStream read:bytes maxLength:8];
    long myInt = (bytes[0] << 56) | (bytes[1] << 48) | (bytes[2] << 40) | (bytes[3] << 32) | (bytes[4] << 24) | (bytes[5] << 16) | (bytes[6] << 8) | (bytes[7]) ;
    // convert from (n)etwork endianness to (h)ost endianness (may be a no-op)
    // ntohl is defined in <arpa/inet.h>
    //myInt = ntohl(myInt);
    return myInt;
}

- (unichar)readChar{
    unichar thechar = (unichar)[self readShort];
    return thechar;
}

-(void)writeChar:(unichar)tosend{
    tosend = htons(tosend);
    NSMutableData *thedata = [[NSMutableData alloc] initWithCapacity:2];
    [thedata appendBytes:&tosend length:2];
    [outputStream write:[thedata bytes] maxLength:2];
    [thedata release];
}

-(NSString *)readString{
    
    short stringlength = [self readShort];
    NSMutableString *addString = [[NSMutableString alloc] initWithCapacity:stringlength];
    for(int j = 0; j < stringlength; j++){
        [addString appendFormat:@"%c", [self readChar]];
    }
    return (NSString*)addString;
}
-(void)writeString:(NSString*)tosendstring{
    short lengthToSend = [tosendstring length];
    [self writeShort:lengthToSend];
    for(int j = 0; j < lengthToSend; j++){
        [self writeChar:(unichar)[tosendstring characterAtIndex:j]];
    }
}
- (void)writeByte:(uint8_t)send{
    // send = htons(send);
    [outputStream write:&send maxLength:1];
}
-(uint8_t)readByte{
    uint8_t bytes;
    [inputStream read:&bytes maxLength:1];
    return bytes;
}
- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
    
    switch(eventCode) {
        case NSStreamEventOpenCompleted:
        {
            NSLog(@"Done Opening!");
            break;
        }
        case NSStreamEventErrorOccurred: {
            NSLog(@"Error");
        }
        case NSStreamEventHasBytesAvailable:{
            
        }
    }
}

@end
