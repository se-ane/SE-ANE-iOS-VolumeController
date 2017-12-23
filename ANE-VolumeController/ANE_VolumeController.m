//
//  ANE_VolumeController.m
//  ANE-VolumeController
//
//  Created by Thanh Pham Van on 11/13/17.
//  Copyright © 2017 Thanh Pham Van. All rights reserved.
//

#import "ANE_VolumeController.h"
#import "FlashRuntimeExtensions.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>


@implementation ANE_VolumeController

FREContext eventContext;
/**
 * Lấy ra giá trị Volume của điện thoại bằng cách truy cập vào thông số của giao diện Volume Slider
 */
float getVolumeLevel() {
    MPVolumeView *slide = [MPVolumeView new];
    UISlider *volumeViewSlider;

    for (UIView *view in [slide subviews]) {
        if ([[[view class] description] isEqualToString:@"MPVolumeSlider"]) {
            volumeViewSlider = (UISlider *) view;
        }
    }

    float val = [volumeViewSlider value];

    return val;
}

void dispathVolumeEvent(float volume) {
    if (eventContext == NULL) {
        return;
    }

    NSNumber *numVolume = @(volume);
    NSString *strVolume = [numVolume stringValue];
    NSString *eventName = @"volumeChanged";

    const uint8_t* volumeCode = (const uint8_t*) [strVolume UTF8String];
    const uint8_t * eventCode = (const uint8_t*) [eventName UTF8String];
    FREDispatchStatusEventAsync(eventContext, eventCode, volumeCode);
}

void volumeListenerCallback(void *inClientData, AudioSessionPropertyID inID, UInt32 inDataSize, const void *inData) {
    const float *volumePointer = inData;
    float volume = *volumePointer;

    dispathVolumeEvent(volume);
}

FREObject init(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]){
    eventContext = ctx;

    // Lắng nghe sự thay đổi của giá trị Volume của hệ thống

    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    AudioSessionSetActive(YES);
    AudioSessionAddPropertyListener(kAudioSessionProperty_CurrentHardwareOutputVolume, volumeListenerCallback, NULL);

    // Tiếp tục và gửi lại giá trị Volume của hệ thống

    float curVolume = getVolumeLevel();
    dispathVolumeEvent(curVolume);

    return NULL;
}

FREObject setVolume(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    double newVolume;

    FREGetObjectAsDouble(argv[0], &newVolume);

    [[MPMusicPlayerController applicationMusicPlayer] setVolume:(float) newVolume];

    return NULL;
}

/**
 * Mặc dù chúng ta đã có hàm lấy giá trị Volume hiện tại của hệ thống.
 * Tuy nhiên, với kiểu trả về là một primitive value, không thể tương thích với AS3 ANE.
 * FREObject là AS3 Object trên C.
 * Do đó, @getCurrentVolume chỉ mang tính chất chuyển đổi từ primitive value sang FREObject.
 * @return Double-FREObject.
 */
FREObject getCurrentVolume(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    float curVolume = getVolumeLevel();
    
    FREObject volumeLevelAsFREObj;
    FRENewObjectFromDouble((double) curVolume, &volumeLevelAsFREObj);
    
    return volumeLevelAsFREObj;
}

void VolExtContextInitializer(void* extData
                              , const uint8_t* ctxType
                              , FREContext ctx
                              , uint32_t* numFunctionsToTest
                              , const FRENamedFunction** functionsToSet){
    *numFunctionsToTest = 3;

    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * *numFunctionsToTest);
    
    /**
    * Để phần thư viện iOS này có thể giao tiếp với interface viết bằng AS3,
    * lưu ý rằng, phải khai báo trên một FRENamedFunction.
    * Mỗi một FRENamedFunction chứa 2 giá trị cần lưu ý.
    * @name là tên của hàm sẽ được sử dụng trong AS3 interface.
    * @function là con trỏ vào hàm tương ứng trên Objective-C.
    */

    func[0].name = (const uint8_t*) "init";
    func[0].functionData = NULL;
    func[0].function = &init;

    func[1].name = (const uint8_t*) "setVolume";
    func[1].functionData = NULL;
    func[1].function = &setVolume;
    
    func[2].name = (const uint8_t*) "getCurrentVolume";
    func[2].functionData = NULL;
    func[2].function = &getCurrentVolume;

    *functionsToSet = func;
}

void VolumeExtensionInitializer(void** exDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) {
    *exDataToSet = NULL;
    *ctxInitializerToSet = &VolExtContextInitializer;
}

@end
