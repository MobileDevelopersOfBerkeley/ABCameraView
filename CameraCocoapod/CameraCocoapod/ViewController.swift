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
    
  
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    @IBAction func deleteImage(_ sender: AnyObject) {
        capturedImage.isHidden = true
        cancel.isHidden = true
        usePhoto.isHidden = true
        takePhoto.isHidden = false
        
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
        case topLeft(String)
        case topMiddle(String)
        case topRight(String)
        case middleLeft(String)
        case middleRight(String)
        case bottomLeft(String)
        case bottomRight(String)
    }
    
    
    public func addButton(_ position: Position) {
        
        switch position {
        case .topLeft(let imageName):
            topLeftButton.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
            
        case .topMiddle(let imageName):
            topMiddleButton.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
            
        case .topRight(let imageName):
            topRightButton.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
            
        case .middleLeft(let imageName):
            middleLeftButton.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
            
        case .middleRight(let imageName):
            middleRightButton.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
            
        case .bottomLeft(let imageName):
            bottomLeftButton.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
            
        case .bottomRight(let imageName):
            bottomRightButton.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        }
        
    }
    
//    let newImage = Position.topLeft("newimage")
//    addButton(newImage)
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer!.frame = previewView.bounds
        print(previewView.bounds)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

