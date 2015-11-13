//
//  ViewController.h
//  ble
//
//  Created by Alin on 15/11/11.
//  Copyright © 2015年 Alin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


- (IBAction)discoverPeripheral:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnForDiscoverPeripheral;

- (IBAction)connectPeripheral:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnForConnectPeripheral;

- (IBAction)discoverService:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnForDiscoverService;

- (IBAction)discoverCharForOta:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnForDiscoverOtaChar;


- (IBAction)discoverIdentify:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnForIdentify;

- (IBAction)IdentifywriteValueForOta:(id)sender;
- (IBAction)BlockwriteValueForOta:(id)sender;

//@property (weak, nonatomic) IBOutlet UITextField *textFileForIdentifyOtaWrite;
//- (IBAction)receiveValueForOta:(id)sender;
//@property (weak, nonatomic) IBOutlet UITextField *textFileForIdentifyOtaReceive;
@property (weak, nonatomic) IBOutlet UITextField *textFileForIdentifyOtaWrite;
@property (weak, nonatomic) IBOutlet UITextField *textFileForIdentifyOtaReceive;
@property (weak, nonatomic) IBOutlet UITextField *textFileForBlockOtaWrite;
@property (weak, nonatomic) IBOutlet UITextField *textFileForBlockOtaReceive;

- (IBAction)readBinaryFile:(id)sender;

- (IBAction)errorCode:(id)sender;

- (IBAction)startQueue:(id)sender;

@end

