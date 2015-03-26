//
//  ViewController.swift
//  Reviewify MVP
//
//  Created by Bryce Langlotz on 2/24/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit
import AVFoundation

class CameraFocus: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 4.0
        self.layer.borderColor = UIColor.whiteColor().CGColor
        
        var selectionAnimation = CABasicAnimation(keyPath: "borderColor")
        selectionAnimation.toValue = UIColor.blueColor().CGColor
        selectionAnimation.repeatCount = 8
        self.layer.addAnimation(selectionAnimation, forKey: "selectionAnimation")
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController, TesseractDelegate {
    
    @IBOutlet var takePictureButton: UIButton!

    required init(coder aDecoder: NSCoder) {
        stillImageOutput = AVCaptureStillImageOutput()
        var outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
        stillImageOutput.outputSettings = outputSettings
        super.init(coder: aDecoder)
    }

    var stillImageOutput: AVCaptureStillImageOutput
    var session: AVCaptureSession!
    var tesseract:Tesseract!
    var captureDevice: AVCaptureDevice?
    var camFocus:CameraFocus!
    var scanResult:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tesseract = Tesseract()
        tesseract.language = "eng"
        tesseract.delegate = self
        
        takePictureButton.backgroundColor = UIColor.algorithmsGreen()
        takePictureButton.layer.cornerRadius = 3.0
        
        self.navigationController?.navigationBarHidden = true
        
        
        self.configureCamera()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageToText(image: UIImage) -> String {
        tesseract.image = image
        tesseract.recognize()
        println("Text from image:\n\(tesseract.recognizedText)\n")
        return tesseract.recognizedText
    }
    
    
    func configureCamera() -> Bool {
        // init camera device
        var devices: NSArray = AVCaptureDevice.devices()
        
        // find back camera
        for device: AnyObject in devices {
            if device.position == AVCaptureDevicePosition.Back {
                captureDevice = device as? AVCaptureDevice
            }
        }
        
        if captureDevice != nil {
            // Debug
            println(captureDevice!.localizedName)
            println(captureDevice!.modelID)
        } else {
            println("Missing Camera")
            return false
        }
        
        // init device input
        var error: NSErrorPointer = nil
        var deviceInput: AVCaptureInput = AVCaptureDeviceInput.deviceInputWithDevice(captureDevice, error: error) as AVCaptureInput
        
        // init session
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetPhoto
        session.addInput(deviceInput as AVCaptureInput)
        
        if session.canAddOutput(stillImageOutput) {
            session.addOutput(stillImageOutput)
        }
        
        // layer for preview
        var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.layerWithSession(self.session) as AVCaptureVideoPreviewLayer
        var bounds = self.view.bounds
        bounds.size = CGSizeMake(4/3 * bounds.size.width, bounds.size.height)
        previewLayer.frame = bounds
        self.view.layer.insertSublayer(previewLayer, below: takePictureButton.layer)
        
        self.session.startRunning()
        
        return true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var touch: UITouch = event.allTouches()?.anyObject() as UITouch
        var touchPoint:CGPoint = touch.locationInView(touch.view)
        self.focus(touchPoint)
        
        if camFocus != nil {
            camFocus.removeFromSuperview()
            camFocus = nil
        }
        if touch.view.isKindOfClass(UIView) {
            camFocus = CameraFocus(frame: CGRectMake(touchPoint.x - 40.0, touchPoint.y - 40.0, 80.0, 80.0))
            self.view.addSubview(camFocus!)
            camFocus?.setNeedsDisplay()
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(1.5)
            camFocus.alpha = 0.0
            UIView.commitAnimations()
        }
    }
    
    func focus(aPoint:CGPoint) {
        if let device = captureDevice {
            if (device.focusPointOfInterestSupported && device.isFocusModeSupported(AVCaptureFocusMode.AutoFocus)) {
                var screenRect:CGRect = UIScreen.mainScreen().bounds
                var screenWidth = screenRect.size.width
                var screenHeight = screenRect.size.height
                var focusX = aPoint.x / screenWidth
                var focusY = aPoint.y / screenHeight
                if device.lockForConfiguration(nil) {
                    device.focusPointOfInterest = CGPointMake(focusX, focusY)
                    device.focusMode = AVCaptureFocusMode.AutoFocus
                    if device.isExposureModeSupported(AVCaptureExposureMode.AutoExpose) {
                        device.exposureMode = AVCaptureExposureMode.AutoExpose
                    }
                    device.unlockForConfiguration()
                }
            }
        }
    }
    
    @IBAction func takePicture() {
        
        var videoConnection:AVCaptureConnection!
        for connection:AVCaptureConnection in (self.stillImageOutput.connections as [AVCaptureConnection]) {
            for port:AVCaptureInputPort in (connection.inputPorts as [AVCaptureInputPort]) {
                if port.mediaType == AVMediaTypeVideo {
                    videoConnection = connection
                    break
                }
            }
            if videoConnection != nil {
                videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
                break
            }
        }
        
        videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
        
        self.stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (imageSampleBuffer, error) -> Void in
            var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageSampleBuffer)
            var image = UIImage(data: imageData)
            var png = UIImagePNGRepresentation(image)
            var blackAndWhite = UIImage(data: png)!.blackAndWhite()
            self.scanResult = self.imageToText(blackAndWhite.imageRotatedByDegrees(90.0))
            // Demo
            // var demoBlackAndWhite = UIImage(named: "Screen Shot 2015-03-19 at 9.52.02 PM.png")!.blackAndWhite()
            // self.imageToText(demoBlackAndWhite)
        })
    }
    
    // MARK: Button Methods
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "BeginReviewSegueIdentifier" {
            var destinationViewController = segue.destinationViewController as ReviewViewController
            destinationViewController.restaurant = "PKs"
            destinationViewController.title = "Edit Segue Settings"
        }
    }
}

