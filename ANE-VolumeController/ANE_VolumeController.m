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

    // Listen to changes to system volume

    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    AudioSessionSetActive(YES);
    AudioSessionAddPropertyListener(kAudioSessionProperty_CurrentHardwareOutputVolume, volumeListenerCallback, NULL);

    // Go ahead and send back current system volume

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

void VolExtContextInitializer(void* extData
                              , const uint8_t* ctxType
                              , FREContext ctx
                              , uint32_t* numFunctionsToTest
                              , const FRENamedFunction** functionsToSet){
    *numFunctionsToTest = 2;

    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * *numFunctionsToTest);

    func[0].name = (const uint8_t*) "init";
    func[0].functionData = NULL;
    func[0].function = &init;

    func[1].name = (const uint8_t*) "setVolume";
    func[1].functionData = NULL;
    func[1].function = &setVolume;

    *functionsToSet = func;
}

void VolumeExtensionInitializer(void** exDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) {
    *exDataToSet = NULL;
    *ctxInitializerToSet = &VolExtContextInitializer;
}

@end
