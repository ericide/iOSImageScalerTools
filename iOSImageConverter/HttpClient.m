#define ACCEPTABLE_CONTENT_MIMETYPES [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain",@"text/html", nil]

#import "HttpClient.h"
#import "Base64.h"
static HttpClient *_sharedMangaer=nil;

@implementation HttpClient


+(HttpClient *)manager
{
    if (!_sharedMangaer) {
        _sharedMangaer=[[HttpClient alloc]init];
    }
    return _sharedMangaer;
}

- (id)init
{
    self = [super init];
    if(self)
    {
    }
    return self;
}

-(void)requestWithBaseURL:(NSString *)url
                     para:(NSDictionary *)parameters
               httpMethod:(HttpMethod)httpMethod
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes =
    ACCEPTABLE_CONTENT_MIMETYPES;
    if (httpMethod==HttpMethodPost) {
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
          success(operation,responseObject);
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          failure(operation,error);
      }];
    }else if (httpMethod==HttpMethodGet)
    {
        [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
             success(operation,responseObject);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failure(operation,error);
         }];
    }
}


@end
