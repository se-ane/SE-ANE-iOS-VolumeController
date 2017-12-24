# ANE-iOS-VolumeController Wiki

## Thiết lập môi trường

Yêu cầu:

* Xcode 8.3 trở lên.
* Adobe AIR SDK.

[Latest build: Release 1.0 2017-12-24](https://github.com/se-ane/SE-ANE-iOS-VolumeController/tree/master/release)

## Build from source

Sử dụng Xcode để build. Apple không hỗ trợ compile Objective-C Cocoa Touch Libraries trên Windows hay Linux.
Architectures: arm64, armv7
Build Active Architectures Only: **No**

## Developments

Các AS3 Object được thể hiện trong Objective-C bằng **FREObject**. Do đó I/O của thư viện đến AS3 Lib cần phải thông qua 2 giá trị. Xem thêm tại [Transferring data with AIR Native Extensions for iOS](http://www.adobe.com/devnet/air/articles/transferring-data-ane-ios-pt1.html).
* [**FREContext**](https://help.adobe.com/en_US/air/extensions/WSb464b1207c184b14-2c95362d12937e5c13e-7fff.html)
* [**FREObject**](https://help.adobe.com/en_US/air/extensions/WSb464b1207c184b14-2c95362d12937e5c13e-7ffe.html)

Các hàm được export cần phải khai báo trong mảng FRENamedFunction của hàm ContextInitializer.

```objective-c
void ContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
  *numFunctionsToTest = 3;

  FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * *numFunctionsToTest);

  func[0].name = (const uint8_t*) "init";
  func[0].functionData = NULL;
  func[0].function = &init;
  
  *functionsToSet = func;
}
```
