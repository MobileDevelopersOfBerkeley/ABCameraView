//
//  ViewController.swift
//  CameraCocoapod
//
//  Created by Mudit Mittal on 9/24/16.
//  Copyright © 2016 Mobile Developers of Berkeley. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var usePhoto: UIButton!
    @IBOutlet weak var takePhoto: UIButton!
    
    var buttons: [UIButton?] = []
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
        if let videoConnection = stillImageOutput?.connection(withMediaType: AVMediaTypeVideo) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection) {
              (sampleBuffer, error) in
              if (sampleBuffer != nil) {
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                let dataProvider = CGDataProvider(data: imageData as! CFData)
                let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
                let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
                    self.capturedImage.image = image
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        capturedImage.isHidden = true
        cancel.isHidden = true
        usePhoto.isHidden = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let screenSize = previewView.bounds.size
        if let touchPoint = touches.first {
            let x = touchPoint.location(in: previewView).y / screenSize.height
            let y = 1.0 - touchPoint.location(in: previewView).x / screenSize.width
            let focusPoint = CGPoint(x: x, y: y)
            
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
            let topLeftButton = UIButton(frame: CGRect(x: Int(capturedImage.bounds.minX + 20), y: Int(capturedImage.bounds.minY + 30), width: 26, height: 26))
            topLeftButton.setImage(UIImage(named: imageName), for: UIControlState.normal)
            self.view.addSubview(topLeftButton)
            buttons.append(topLeftButton)
            return topLeftButton
            
        case .topMiddle:
            let topMiddleButton = UIButton(frame: CGRect(x: Int((capturedImage.frame.size.width / 2) - 13), y: Int(capturedImage.bounds.minY + 30), width: 26, height: 26))
            topMiddleButton.setImage(UIImage(named: imageName), for: UIControlState.normal)
            self.view.addSubview(topMiddleButton)
            buttons.append(topMiddleButton)
            return topMiddleButton

        case .topRight:
            let topRightButton = UIButton(frame: CGRect(x: Int(capturedImage.bounds.maxX - 46) , y: Int(capturedImage.bounds.minY + 30), width: 26, height: 26))
            topRightButton.setImage(UIImage(named: imageName), for: UIControlState.normal)
            self.view.addSubview(topRightButton)
            buttons.append(topRightButton)
            return topRightButton
            
        case .middleLeft:
            let middleLeftButton = UIButton(frame: CGRect(x: Int(capturedImage.bounds.minX + 20), y: Int((capturedImage.frame.size.height / 2) - 13) , width: 26, height: 26))
            middleLeftButton.setImage(UIImage(named: imageName), for: UIControlState.normal)
            self.view.addSubview(middleLeftButton)
            buttons.append(middleLeftButton)
            return middleLeftButton
            
        case .middleRight:
            let middleRightButton = UIButton(frame: CGRect(x: Int(capturedImage.bounds.maxX - 46), y: Int((capturedImage.frame.size.height / 2) - 13) , width: 26, height: 26))
            middleRightButton.setImage(UIImage(named: imageName), for: UIControlState.normal)
            self.view.addSubview(middleRightButton)
            buttons.append(middleRightButton)
            return middleRightButton
            
        case .bottomLeft:
            let bottomLeftButton = UIButton(frame: CGRect(x: Int(capturedImage.bounds.minX + 20), y: Int(capturedImage.bounds.maxY - 56) , width: 26, height: 26))
            bottomLeftButton.setImage(UIImage(named: imageName), for: UIControlState.normal)
            self.view.addSubview(bottomLeftButton)
            buttons.append(bottomLeftButton)
            return bottomLeftButton
            
        case .bottomRight:
            let bottomRightButton = UIButton(frame: CGRect(x: Int(capturedImage.bounds.maxX - 46), y: Int(capturedImage.bounds.maxY - 56) , width: 26, height: 26))
            bottomRightButton.setImage(UIImage(named: imageName), for: UIControlState.normal)
            self.view.addSubview(bottomRightButton)
            buttons.append(bottomRightButton)
            return bottomRightButton
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer!.frame = previewView.bounds
        print(previewView.bounds)
        topMiddleButton = addButton(Position.topMiddle, imageName: "cancel-button")
        topRightButton = addButton(Position.topRight, imageName: "cancel-button")
        topLeftButton = addButton(Position.topLeft, imageName: "cancel-button")
        leftMiddleButton = addButton(Position.middleLeft, imageName: "cancel-button")
        rightMiddleButton = addButton(Position.middleRight, imageName: "cancel-button")
        bottomLeftButton = addButton(Position.bottomLeft, imageName: "cancel-button")
        bottomRightButton = addButton(Position.bottomRight, imageName: "cancel-button")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

