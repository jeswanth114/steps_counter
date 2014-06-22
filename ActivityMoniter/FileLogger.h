//
//  FileLogger.h
//  Pedometer
//
//  Created by Jeswanth Reddy on 10/16/13.
//
//

#import <Foundation/Foundation.h>

@interface FileLogger : NSObject {
    NSFileHandle *logFile;
}
+ (FileLogger *)sharedInstance;
- (void)log:(NSString *)format, ...;
-(NSString*) displayContent;
- (void)removeFile;
- (id) init ;
-(void)create;
@end