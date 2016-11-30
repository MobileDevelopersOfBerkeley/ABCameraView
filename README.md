# ABCameraView
Implementing this camera is as easy as ABC.

This is a full-screen camera view controller that allows you to customize what buttons you want to include and the location of each of them.

Included are functions for flash, switching the camera between front and back, and focusing the camera. Alongside these are default button images for Flash and Switch Camera.

However, you also have the option of adding your own custom button images if desired, as well as your own buttons with custom functions. 

This dependency skips the hassle of AVFoundation, and allows you to implement capturing a photo in a clean and simple way! 

## Installation with CocoaPods

Install ABCameraView with: [CocoaPods](http://cocoapods.org)

### Podfile

```ruby
pod 'ABCameraView'
```

## How to use
To use it you just add a ViewController of class ABCameraViewController to your storyboard to use.

To add a button, use the addButton function with the position and image you want to use
(in this example, we are adding the flash button):
```swift
topLeftFlashButton = addButton(Position.topLeft, imageName: "flash-off-button")
```

For the position parameter, select your desired position of the following:

```swift
Position.topLeft
Position.topMiddle
Position.topRight
Position.middleLeft
Position.middleRight
Position.bottomLeft
Position.bottomRight
```

To add a target to your button (in this example, we are calling the 'turnFlashOn' action):
```swift
topLeftFlashButton?.addTarget(self, action: #selector(turnFlashOn), for: UIControlEvents.touchUpInside)
```

If you want to use the default switch camera button, call the 'changeCamera' action:
```swift
topRightSwitchButton = addButton(Position.topRight, imageName: "switch-camera-button")
topRightSwitchButton?.addTarget(self, action: #selector(changeCamera), for: UIControlEvents.touchUpInside)
```

The captured image view is in the 'capturedImage' variable.

## Support

Supports iOS 8 and above. Xcode 7.0 is required to build the latest code written in Swift 3.0.

