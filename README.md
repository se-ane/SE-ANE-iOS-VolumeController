# SE-ANE-iOS-VolumeController

## What ?

Repo này là một phần trong project [SE-ANE-VolumeController](https://github.com/NganNTK/SE-AIRNativeExtension).

## Why ?

ActionScript không có khả năng truy cập sâu vào các API trong iOS/Android, do đó một project Adobe AIR thường kèm theo các ANE (AIR Native Extension). Các ANE được xây dựng bằng:

* Interface và share logic viết bằng ActionScript.
* Java Android Library và Objective-C Cocoa Touch Library.

## What you need

* Xcode (kể cả không dùng Xcode như IDE chính, chúng ta vẫn cần Build Tools và Compiler kèm theo Xcode), trong trường hợp này, phiên bản Xcode 8.3 được khuyến khích.
* [Adobe AIR SDK](http://www.adobe.com/devnet/air/air-sdk-download.html) for MacOSX.
* Optional: AppCode

## Notice

Apple đã ngừng phát triển cũng như lên kế hoạch ngừng hỗ trợ Objective-C trong việc xây dựng các ứng dụng trên MacOS và iOS. Adobe chưa có động thái gì trong việc hỗ trợ Swift (tại thời điểm viết, Swift đã có phiên bản ổn định Swift 4). Cộng đồng GitHub cũng đang phát triển một phương pháp thay thế, có thể thấy tại [repo này](https://github.com/tuarua/Swift-IOS-ANE), với bản chất là phần lớn các method được viết bằng Swift 3 (yêu cầu Xcode 8.3), và xây dựng một interface bằng Objective-C.

Chưa rõ khả năng phát triển ANE trên Android bằng ngôn ngữ Kotlin, nhưng, do phần lớn Kotlin được thiết kế để tương thích tối đa với hệ sinh thái Java (với Scala, điều này không dễ dàng), việc phát triển ANE bằng Kotlin thay Java là điều nên được khuyến khích.

## Wiki

// TODO

## Contributors

@NganNTK as Tech Leader/Android Developer

@LaNT as AS3 Developer

@ThanhPV as iOS Developer
