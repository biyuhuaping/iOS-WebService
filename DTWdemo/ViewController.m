//
//  ViewController.m
//  DTWdemo
//
//  Created by JYDMAC on 14-6-20.
//  Copyright (c) 2014年 zhoubo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//查询按钮
- (IBAction)queryBtn:(id)sender{
    if (_textField.text.length == 0) {
        return;
    }
    //封装soap请求消息
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
                             "<SOAP-ENV:Envelope \n"
                             "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" \n"
                             "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" \n"
                             "xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" \n"
                             "SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" \n"
                             "xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"> \n"
                             "<SOAP-ENV:Body> \n"
                             
                             //======这里把 getMobileCodeInfo 换成 要条用的函数名 =====
                             "<getMobileCodeInfo xmlns=\"http://WebXml.com.cn/\">\n"
                             
                             //这里把mobileCode、userID等,换成自己要提交的参数
                             "<mobileCode>%@</mobileCode>\n"
                             "<userID></userID>\n"
                             
                             "</getMobileCodeInfo>\n"
                             //=================
                             
                             "</SOAP-ENV:Body> \n"
                             "</SOAP-ENV:Envelope>",_textField.text];
    
    NSLog(@"%@",soapMessage);
    //请求发送到的路径，换成自己的服务地址
    NSURL *url = [NSURL URLWithString:@"http://webservice.webxml.com.cn/WebServices/MobileCodeWS.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    //以下对请求信息添加属性前四句是必有的，第五句是soap信息。
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://WebXml.com.cn/getMobileCodeInfo" forHTTPHeaderField:@"SOAPAction"];//这里要换成自己的路径
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //请求
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    //如果连接已经建好，则初始化data
    if(theConnection) {
        _webData = [NSMutableData data];
    }else {
        NSLog(@"theConnection is NULL");
    }
}

//接收到响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[_webData setLength:0];
}

//接收到数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[_webData appendData:data];
}

//如果电脑没有连接网络，则出现此信息（不是网络服务器不通）
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	_label.text = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
}

//连接完成 加载数据
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"3 DONE. Received Bytes: %d", [_webData length]);
	NSString *theXML = [[NSString alloc] initWithBytes: [_webData mutableBytes] length:[_webData length] encoding:NSUTF8StringEncoding];
	NSLog(@"theXML:%@",theXML);
    
    
	NSLog(@"Data has been loaded");
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:_webData];
	[parser setDelegate:self];
    [parser parse];
}

//解析文件
- (void)parserDidStartDocument:(NSXMLParser *)parser {
	
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	_currentElement = elementName;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	//字符串中去除特殊符号 去除两端空格和回车
    NSString *fixedString = [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"===:%@",fixedString);

    if ([_currentElement isEqualToString:@"getMobileCodeInfoResult"])//这里换成函数返回值的字段
    {
        _label.text = fixedString;
        UIAlertView  *view = [[UIAlertView alloc] initWithTitle:@"调用wcf成功！" message:fixedString delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil] ;
        [view show];
    }
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
}

@end
