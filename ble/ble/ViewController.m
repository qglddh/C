//
//  ViewController.m
//  ble
//
//  Created by Alin on 15/11/11.
//  Copyright © 2015年 Alin. All rights reserved.
//

#import "ViewController.h"
#import "RKCentralManager.h"
#import "RKPeripheral.h"
#import "NSData+Hex.h"

@interface ViewController ()

@property (nonatomic,strong) RKCentralManager * otaCentral;
@property (nonatomic,strong) RKPeripheral *otaPeripheral;
@property (nonatomic,strong) CBService * otaService;
@property (nonatomic,strong) CBCharacteristic *otaIdentifyNotifyCharacter;
@property (nonatomic,strong) CBCharacteristic *otaIdentifyWriteCharacter;
@property (nonatomic,strong) CBCharacteristic *otaBlockNotifyCharacter;
@property (nonatomic,strong) CBCharacteristic *otaBlockWriteCharacter;

@property (nonatomic,retain) NSMutableData *otaUpdataFrame;
@property (nonatomic,retain) NSData *otaUpdataValue;
@property (nonatomic,retain) NSMutableData *otaUpdataSequence;

@property (nonatomic, strong) dispatch_source_t timerSource;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation ViewController

dispatch_source_t _timer;

bool otaType;

double circleAdd = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnForDiscoverPeripheral.enabled = YES;
    self.btnForConnectPeripheral.enabled = NO;
    self.btnForDiscoverService.enabled = NO;
    self.btnForIdentify.enabled = NO;
    self.btnForDiscoverOtaChar.enabled = NO;
    
    self.otaUpdataFrame = [[NSMutableData alloc]init];

    uint64_t interval = 15 * NSEC_PER_MSEC;
    //创建一个专门执行timer回调的GCD队列
    dispatch_queue_t queue = dispatch_queue_create("my queue", 0);
    //创建Timer
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //使用dispatch_source_set_timer函数设置timer参数
    dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
    
    //创建出CAShapeLayer
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = CGRectMake(0, 0, 200, 200);//设置shapeLayer的尺寸和位置
    self.shapeLayer.position = self.view.center;
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;//填充颜色为ClearColor
    
    //设置线条的宽度和颜色
    self.shapeLayer.lineWidth = 1.0f;
    self.shapeLayer.strokeColor = [UIColor redColor].CGColor;
    
    //创建出圆形贝塞尔曲线
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 200, 200)];
    
    //让贝塞尔曲线与CAShapeLayer产生联系
    self.shapeLayer.path = circlePath.CGPath;
    
    self.shapeLayer.strokeStart = 0;
    self.shapeLayer.strokeEnd = 0;
    
    //添加并显示
    [self.view.layer addSublayer:self.shapeLayer];
}

- (IBAction)init:(id)sender {

}


- (IBAction)discoverPeripheral:(id)sender {
    NSDictionary *opts = nil;
    self.otaCentral = [[RKCentralManager alloc]initWithQueue:nil options:opts];
    
    //    __weak RKCentralManager *wp = self.central;
    __weak ViewController *wp = self;
    
    if (self.otaCentral.state != CBCentralManagerStatePoweredOn) {
        self.otaCentral.onStateChanged = ^(NSError *error){
            [wp.otaCentral scanForPeripheralsWithServices:nil options:nil onUpdated:^(RKPeripheral *peripheral) {
                //                NSLog(@"%@",peripheral.peripheral.name);
                wp.btnForDiscoverPeripheral.enabled = YES;
                wp.btnForConnectPeripheral.enabled = YES;
            }];
        };
    }
}

- (IBAction)connectPeripheral:(id)sender {
    if (self.otaCentral.peripherals.count > 0) {
        [self.otaCentral connectPeripheral:self.otaCentral.peripherals[0] options:nil onFinished:^(RKPeripheral *peripheral, NSError *error) {
            self.otaPeripheral = peripheral;
            NSLog(@"connect-------%@",peripheral.name);
            self.btnForDiscoverService.enabled = YES;
        } onDisconnected:^(RKPeripheral *peripheral, NSError *error) {
            NSLog(@"disconnect call back");
            self.btnForDiscoverPeripheral.enabled = YES;
            self.btnForConnectPeripheral.enabled = NO;
            self.btnForDiscoverService.enabled = NO;
            self.btnForIdentify.enabled = NO;
            self.btnForDiscoverOtaChar.enabled = NO;
        }];
    }
}
- (IBAction)discoverService:(id)sender {
    [self.otaPeripheral discoverServices:nil onFinish:^(NSError *error) {
        for (CBService *service in self.otaPeripheral.services) {
            if ([service.UUID isEqual:[CBUUID UUIDWithString:@"F000FFC0-0451-4000-B000-000000000000"]]) {
                self.otaService = service;
                self.btnForDiscoverOtaChar.enabled = YES;
            }
        }
    }];
}

- (IBAction)discoverCharForOta:(id)sender {
    __weak ViewController *wp = self;
    [self.otaPeripheral discoverCharacteristics:nil forService:self.otaService onFinish:^(CBService *service, NSError *error) {
        for (CBCharacteristic *character in service.characteristics) {
            if ([character.UUID isEqual:[CBUUID UUIDWithString:@"F000FFC1-0451-4000-B000-000000000000"]]) {
                self.otaIdentifyNotifyCharacter = character;
                self.otaIdentifyWriteCharacter = character;
                NSLog(@"char %@",self.otaIdentifyNotifyCharacter);
                [self.otaPeripheral setNotifyValue:YES forCharacteristic:self.otaIdentifyNotifyCharacter onUpdated:^(CBCharacteristic *characteristic, NSError *error) {
                    wp.textFileForIdentifyOtaReceive.text = [character.value hexadecimalString];
                    NSLog(@"Identify----receive%@",character.value);
                    
                    NSData *data = [characteristic value];

                    
                    if ([NSData dataGetBitIndex:1 data:data]) {
                        //receive B and send A
                        otaType = true;
                        NSString *path = [[NSBundle mainBundle]pathForResource:@"11-13-a" ofType:@"bin"];
                        //获取文件数据
                        wp.otaUpdataValue = [NSData dataWithContentsOfFile:path];
                    }
                    else{
                        //receive A and send B
                        otaType = false;
                        //获取文件路径
                        NSString *path = [[NSBundle mainBundle]pathForResource:@"11-13-b" ofType:@"bin"];
                        //获取文件数据
                        wp.otaUpdataValue = [NSData dataWithContentsOfFile:path];
                    }
//                    NSLog(@"char %@",character);
                }];
            }
            else if ([character.UUID isEqual:[CBUUID UUIDWithString:@"F000FFC2-0451-4000-B000-000000000000"]])
            {
                self.otaBlockNotifyCharacter = character;
                self.otaBlockWriteCharacter = character;
                [self.otaPeripheral setNotifyValue:YES forCharacteristic:self.otaBlockNotifyCharacter onUpdated:^(CBCharacteristic *characteristic, NSError *error) {
                    NSString *str = [character.value hexadecimalString];
                    wp.textFileForBlockOtaReceive.text = str;

                    NSLog(@"----------------------------%@",str);
                }];
            }
        }
    }];
}

- (void)otaWriteOneFrame
{

}
- (IBAction)IdentifywriteValueForOta:(id)sender {
    CBCharacteristicWriteType type =CBCharacteristicWriteWithoutResponse;
//    NSData * data = [NSData  dataWithHexString:self.textFileForIdentifyOtaWrite.text];
    NSData *data;
    if (otaType == true) {
        //send A
        data  = [NSData dataWithHexString:@"0000007C"];
    }
    else{
        //send B
        data  = [NSData dataWithHexString:@"0100007C"];
    }
    
    NSLog(@"write---%@",data);
    [self.otaPeripheral writeValue:data forCharacteristic:self.otaIdentifyWriteCharacter type:type onFinish:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"write success");
    }];
}

- (IBAction)BlockwriteValueForOta:(id)sender {
    CBCharacteristicWriteType type =CBCharacteristicWriteWithoutResponse;
    NSData * data = [NSData  dataWithHexString:self.textFileForBlockOtaWrite.text];
    NSLog(@"BlockOtaWrite---%@",data);
    [self.otaPeripheral writeValue:data forCharacteristic:self.otaBlockWriteCharacter type:type onFinish:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"write success");
    }];
}

#pragma mark write interface
- (void)writeCharacterValue:(CBCharacteristic*)character type:(CBCharacteristicWriteType)type data:(NSData*)value
{
    //write identify
    if (character == self.otaIdentifyWriteCharacter) {
        [self.otaPeripheral writeValue:value forCharacteristic:self.otaIdentifyWriteCharacter type:CBCharacteristicWriteWithoutResponse onFinish:^(CBCharacteristic *characteristic, NSError *error) {
           //when finish
        }];
    }
    //write block
    else if (character == self.otaBlockWriteCharacter){
        [self.otaPeripheral writeValue:value forCharacteristic:self.otaBlockWriteCharacter type:CBCharacteristicWriteWithoutResponse onFinish:^(CBCharacteristic *characteristic, NSError *error) {
            //when finish
        }];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)updateCircle:(double)add
{
//    if (self.shapeLayer.strokeEnd > 1 && self.shapeLayer.strokeStart < 1) {
//        self.shapeLayer.strokeStart += add;
//    }else if(self.shapeLayer.strokeStart == 0){
//        self.shapeLayer.strokeEnd += add;
//    }
//    
//    if (self.shapeLayer.strokeEnd == 0) {
//        self.shapeLayer.strokeStart = 0;
//    }
//    
//    if (self.shapeLayer.strokeStart == self.shapeLayer.strokeEnd) {
//        self.shapeLayer.strokeEnd = 0;
//    }
}
- (IBAction)readBinaryFile:(id)sender {
    
    //设置回调
    static unsigned int i = 0;
    dispatch_source_set_event_handler(_timer, ^()
    {
//        NSLog(@"Timer %@", [NSThread currentThread]);
//        circleAdd += 1.000/7936000;
        circleAdd += 1.000/14500000;
        dispatch_sync(dispatch_get_main_queue(), ^(){
            if (self.shapeLayer.strokeEnd > 1 && self.shapeLayer.strokeStart < 1) {
                self.shapeLayer.strokeStart += circleAdd;
            }else if(self.shapeLayer.strokeStart == 0){
                self.shapeLayer.strokeEnd += circleAdd;
            }
            
            if (self.shapeLayer.strokeEnd == 0) {
                self.shapeLayer.strokeStart = 0;
            }
            
            if (self.shapeLayer.strokeStart == self.shapeLayer.strokeEnd) {
                self.shapeLayer.strokeEnd = 0;
            }
        });
        
      char dataSequence[20];
      dataSequence[0] = i & 0xff;
      dataSequence[1] = (i>>8) & 0xff;
     
      NSData *dataValue = [self.otaUpdataValue subdataWithRange:NSMakeRange(i*16,16)];
     
      [self.otaUpdataFrame appendBytes:dataSequence length:2];
      [self.otaUpdataFrame appendData:dataValue];
     
      NSMutableData *data;
      data = self.otaUpdataFrame;
      CBCharacteristicWriteType type =CBCharacteristicWriteWithoutResponse;
      [self.otaPeripheral writeValue:data forCharacteristic:self.otaBlockWriteCharacter type:type onFinish:^(CBCharacteristic *characteristic, NSError *error) {
          NSLog(@"write success");
      }];
     
      NSLog(@"%@",self.otaUpdataFrame);
     
      [self.otaUpdataFrame resetBytesInRange:NSMakeRange(0, 18)];
      [self.otaUpdataFrame setLength:0];
      
      i++;
        
        if (i == 7936) {
            dispatch_suspend(_timer);
            i = 0;
        }
    });
    //dispatch_source默认是Suspended状态，通过dispatch_resume函数开始它
    if (i == 0) {
        dispatch_resume(_timer);
    }
}

- (IBAction)errorCode:(id)sender {
    NSData *data  = [NSData dataWithHexString:@"ffffffff"];
    CBCharacteristicWriteType type =CBCharacteristicWriteWithoutResponse;
    
    [self.otaPeripheral writeValue:data forCharacteristic:self.otaIdentifyWriteCharacter type:type onFinish:^(CBCharacteristic *characteristic, NSError *error) {

    }];
}

- (IBAction)startQueue:(id)sender {
    dispatch_resume(_timer);
}
@end










