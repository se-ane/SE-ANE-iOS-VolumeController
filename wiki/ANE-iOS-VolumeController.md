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

Nếu khi build ANE gặp một trong các lỗi sau:

>Error: Apple App Store allows only universal applications. "libIOSVolumeLib.a" is not a universal binary. Please change build settings in Xcode project to "Standard Architecture" to create universal library/framework.

>[exec] Error: libVolumeLibiOS.a are required to have universal iOS libraries. Please contact the ANE developer(s) to get the same.

Do năm 2015, Apple yêu cầu toàn bộ các ứng dụng trên App Store phải support arm64. Nếu gặp lỗi trên, xin hãy đảm bảo 2 thông số trên trong Build Options là chính xác.

Tham khảo thêm tại [64-bit requirements for iOS apps](http://easynativeextensions.com/making-your-ios-apps-universal/).

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
