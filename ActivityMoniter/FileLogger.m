//
//  FileLogger.m
//  Pedometer
//
//  Created by Jeswanth Reddy on 10/16/13.
//
//

#import "FileLogger.h"

@implementation FileLogger


- (id) init {
    if (self == [super init]) {
        [self create];
           }
    
    return self;
}

-(void)create
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"application.log"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath])
        [fileManager createFileAtPath:filePath
                             contents:nil
                           attributes:nil];
    logFile = [NSFileHandle fileHandleForWritingAtPath:filePath];
    [logFile seekToEndOfFile];

}

- (void)log:(NSString *)format, ... {
    va_list ap;
    va_start(ap, format);
    
    NSString *message = [[NSString alloc] initWithFormat:format arguments:ap];
   // NSLog(@"%@",message);
    [logFile writeData:[[message stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [logFile synchronizeFile];
    
}

-(NSString*) displayContent{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/application.log",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    //use simple alert from my library (see previous post for details)
    return content;
    
}
- (void)removeFile
{
    // you need to write a function to get to that directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:documentsDirectory])
    {
        NSError *error;
        if (![fileManager removeItemAtPath:documentsDirectory error:&error])
        {
            NSLog(@"Error removing file: %@", error);
        };
    }
}


+ (FileLogger *)sharedInstance {
    static FileLogger *instance = nil;
    if (instance == nil) instance = [[FileLogger alloc] init];
    return instance;
}


@end