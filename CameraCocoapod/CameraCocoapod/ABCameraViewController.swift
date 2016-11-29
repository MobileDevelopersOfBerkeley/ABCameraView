//
//  ABCameraViewController.swift
//  CameraCocoapod
//
//  Created by Mudit Mittal on 9/24/16.
//  Copyright © 2016 Mobile Developers of Berkeley. All rights reserved.
//

import UIKit
import AVFoundation

class ABCameraViewController: UIViewController {

    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var usePhoto: UIButton!
    @IBOutlet weak var takePhoto: UIButton!
    
    var buttons: [UIButton?] = []
    var camera = true
    var flash = false
    var topLeftButton: UIButton?
    var topMiddleButton: UIButton?
    var topRightButton: UIButton?
    var leftMiddleButton: UIButton?
    var rightMiddleButton: UIButton?
    var bottomLeftButton: UIButton?
    var bottomRightButton: UIButton?
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?

    
    @IBAction func deleteImage(_ sender: AnyObject) {
        capturedImage.isHidden = true
        cancel.isHidden = true
        usePhoto.isHidden = true
        takePhoto.isHidden = false
        for button in self.buttons {
            button?.isHidden = false
        }
        
    }
    
    @IBAction func didPressTakePhoto(_ sender: AnyObject) {
        toggleFlash()
        sleep(1)
        toggleFlash()
        if let videoConnection = stillImageOutput?.connection(withMediaType: AVMediaTypeVideo) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection) {
              (sampleBuffer, error) in
              if (sampleBuffer != nil) {
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                let dataProvider = CGDataProvider(data: imageData as! CFData)
                let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
                if (self.camera == true) {
                    let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
                    self.capturedImage.image = image
                } else {
                    let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: .leftMirrored)
                    self.capturedImage.image = image
                }
                }
                self.capturedImage.isHidden = false
                self.cancel.isHidden = false
                self.takePhoto.isHidden = true
                self.usePhoto.isHidden = false
                for button in self.buttons {
                    button?.isHidden = true
                }
            }
        }
    }
    
    func changeCamera(sender: AnyObject?) {
        camera = !camera
        reloadCamera()
        previewLayer!.frame = previewView.bounds
    }
    
    func reloadCamera() {
        captureSession?.stopRunning()
        captureSession = AVCaptureSession()
        previewLayer?.removeFromSuperlayer()
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        var captureDevice: AVCaptureDevice! = nil
        if (camera == false) {
            let videoDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
            for device in videoDevices!{
                let device = device as! AVCaptureDevice
                if device.position == AVCaptureDevicePosition.front {
                    captureDevice = device
                    break
                }
            }
        } else {
            captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        }
        var error : NSError?
        var input : AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
        } catch let err as NSError {
            error = err
            input = nil
        }
        if error == nil && captureSession!.canAddInput(input) {
            captureSession!.addInput(input)
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            if captureSession!.canAddOutput(stillImageOutput) {
                captureSession!.addOutput(stillImageOutput)
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
                previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                previewView.layer.addSublayer(previewLayer!)
                captureSession!.startRunning()
            }
        }
    }
    
    func turnFlashOn(sender: UIButton) {
        flash = !flash
        if (flash == true) {
            sender.setImage(UIImage(named: "flash-on-button"), for: UIControlState.normal)
        } else {
            sender.setImage(UIImage(named: "flash-off-button"), for: UIControlState.normal)
        }
       
    }
    
    func toggleFlash() {
        if (camera == true) {
            let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            if (device?.hasTorch)! {
                do {
                    try device?.lockForConfiguration()
                    if (flash == true) {
                        device?.flashMode = .on
                    } else {
                        device?.flashMode = .off
                    }
                    if (device?.torchMode == AVCaptureTorchMode.on) {
                        device?.torchMode = AVCaptureTorchMode.off
                    }
                    device?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        capturedImage.isHidden = true
        cancel.isHidden = true
        usePhoto.isHidden = true
        reloadCamera()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let screenSize = previewView.bounds.size
        if let touchPoint = touches.first {
            let x = touchPoint.location(in: previewView).y / screenSize.height
            let y = 1.0 - touchPoint.location(in: previewView).x / screenSize.width
            let focusPoint = CGPoint(x: x, y: y)
            if (camera == true) {
                if let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) {
                    do {
                        try device.lockForConfiguration()
                        
                        device.focusPointOfInterest = focusPoint
                        device.focusMode = .autoFocus
                        device.exposurePointOfInterest = focusPoint
                        device.exposureMode = AVCaptureExposureMode.continuousAutoExposure
                        device.unlockForConfiguration()
                    }
                    catch {
                    }
                }
            }
        }
    }
    
    enum Position {
        case topLeft
        case topMiddle
        case topRight
        case middleLeft
        case middleRight
        case bottomLeft
        case bottomRight
    }
    
    
    public func  addButton(_ position: Position, imageName: String) -> UIButton {
        
        switch position {
        case .topLeft:
            let topLeftButton = UIButton(frame: CGRect(x: Int(capturedImage.bounds.minX + 20), y: Int(capturedImage.bounds.minY + 30), width: 34, height: 34))
            topLeftButton.setImage(UIImage(named: imageName), for: UIControlState.normal)
            topLeftButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            self.view.addSubview(topLeftButton)
            buttons.append(topLeftButton)
            return topLeftButton
            
        case .topMiddle:
            let topMiddleButton = UIButton(frame: CGRect(x: Int((capturedImage.frame.size.width / 2) - 17), y: Int(capturedImage.bounds.minY + 30), width: 34, height: 34))
            topMiddleButton.setImage(UIImage(named: imageName), for: UIControlState.normal)
            self.view.addSubview(topMiddleButton)
            topMiddleButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            buttons.append(topMiddleButton)
            return topMiddleButton

        case .topRight:
            let topRightButton = UIButton(frame: CGRect(x: Int(capturedImage.bounds.maxX - 54) , y: Int(capturedImage.bounds.minY + 30), width: 34, height: 34))
            topRightButton.setImage(UIImage(named: imageName), for: UIControlState.normal)
            topRightButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            self.view.addSubview(topRightButton)
            buttons.append(topRightButton)
            return topRightButton
            
        case .middleLeft:
            let middleLeftButton = UIButton(frame: CGRect(x: Int(capturedImage.bounds.minX + 20), y: Int((capturedImage.frame.size.height / 2) - 17) , width: 34, height: 34))
            middleLeftButton.setImage(UIImage(named: imageName), for: UIControlState.normal)
            middleLeftButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            self.view.addSubview(middleLeftButton)
            buttons.append(middleLeftButton)
            return middleLeftButton
            
        case .middleRight:
            let middleRightButton = UIButton(frame: CGRect(x: Int(capturedImage.bounds.maxX - 54), y: Int((capturedImage.frame.size.height / 2) - 17) , width: 34, height: 34))
            middleRightButton.setImage(UIImage(named: imageName), for: UIControlState.normal)
            middleRightButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            self.view.addSubview(middleRightButton)
            buttons.append(middleRightButton)
            return middleRightButton
            
        case .bottomLeft:
            let bottomLeftButton = UIButton(frame: CGRect(x: Int(capturedImage.bounds.minX + 20), y: Int(capturedImage.bounds.maxY - 64) , width: 34, height: 34))
            bottomLeftButton.setImage(UIImage(named: imageName), for: UIControlState.normal)
            bottomLeftButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            self.view.addSubview(bottomLeftButton)
            buttons.append(bottomLeftButton)
            return bottomLeftButton
            
        case .bottomRight:
            let bottomRightButton = UIButton(frame: CGRect(x: Int(capturedImage.bounds.maxX - 54), y: Int(capturedImage.bounds.maxY - 64) , width: 34, height: 34))
            bottomRightButton.setImage(UIImage(named: imageName), for: UIControlState.normal)
            bottomRightButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            self.view.addSubview(bottomRightButton)
            buttons.append(bottomRightButton)
            return bottomRightButton
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer!.frame = previewView.bounds
        
        // How to add a button
        //topMiddleButton = addButton(Position.topMiddle, imageName: "cancel-button")
        
        // If user wants to add a Flash Button:
        //topRightButton = addButton(Position.topRight, imageName: "flash-button")
        // topRightButton.addTarget(self, action: "flashToggle:", for: UIControlEvents.touchUpInside)
        
        // If user wants to add a Switch Camera Button:
        //bottomRightButton = addButton(Position.topRight, imageName: "flash-button")
        // bottomRightButton.addTarget(self, action: "switchCamera:", for: UIControlEvents.touchUpInside)
        
        topLeftButton = addButton(Position.topLeft, imageName: "flash-off-button")
        topLeftButton?.addTarget(self, action: #selector(turnFlashOn), for: UIControlEvents.touchUpInside)
        topRightButton = addButton(Position.topRight, imageName: "switch-camera-button")
        topRightButton?.addTarget(self, action: #selector(changeCamera), for: UIControlEvents.touchUpInside)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

