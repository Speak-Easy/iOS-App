//
//  ViewController.swift
//  Reviewify MVP
//
//  Created by Bryce Langlotz on 2/24/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, TesseractDelegate {
    
    @IBOutlet var takePictureButton: UIButton!
    
    var scanResult:String!
    var tesseract:Tesseract!
    var camFocus:CameraFocus!
    var session: AVCaptureSession!
    var captureDevice: AVCaptureDevice?
    var processedScanResultDict:[String:AnyObject]!
    var stillImageOutput: AVCaptureStillImageOutput!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        stillImageOutput = AVCaptureStillImageOutput()
        
        tesseract = Tesseract()
        tesseract.language = "eng"
        tesseract.delegate = self
        
        takePictureButton.backgroundColor = UIColor.algorithmsGreen()
        takePictureButton.layer.cornerRadius = 3.0
        
        self.title = "Scanner"
        
        self.configureCamera()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func imageToText(image: UIImage) -> String {
        tesseract.image = image
        tesseract.recognize()
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
            println(captureDevice!.localizedName)
            println(captureDevice!.modelID)
        } else {
            println("Missing Camera")
            return false
        }
        
        // init device input
        var error: NSErrorPointer = nil
        var deviceInput: AVCaptureInput = AVCaptureDeviceInput.deviceInputWithDevice(captureDevice, error: error) as! AVCaptureInput
        
        // init session
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetPhoto
        session.addInput(deviceInput as AVCaptureInput)
        if session.canAddOutput(stillImageOutput) {
            session.addOutput(stillImageOutput)
        }
        
        // layer for preview
        var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.layerWithSession(self.session) as! AVCaptureVideoPreviewLayer
        var bounds = self.view.bounds
        bounds.size = CGSizeMake(4/3 * bounds.size.width, bounds.size.height)
        previewLayer.frame = bounds
        self.view.layer.insertSublayer(previewLayer, below: takePictureButton.layer)
        
        self.session.startRunning()
        
        return true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /*
        var touch: UITouch = event.allTouches()?.anyObject() as UITouch
        var touchPoint:CGPoint = touch.locationInView(touch.view)
        self.focus(touchPoint)
        
        // If a camFocus is already on the screen remove it
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
*/
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
        var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Processing"
        
        self.view.userInteractionEnabled = false
        
        var videoConnection:AVCaptureConnection!
        for connection:AVCaptureConnection in (self.stillImageOutput.connections as! [AVCaptureConnection]) {
            for port:AVCaptureInputPort in (connection.inputPorts as! [AVCaptureInputPort]) {
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
        

        //////////////////////////
        // DEMO WITH SCREENSHOT //
        //////////////////////////
        #if (arch(i386) || arch(x86_64)) && os(iOS)
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), {
            var demoBlackAndWhite = UIImage(named: "Screen Shot 2015-04-09 at 11.47.50 AM.png")!.blackAndWhite()
            self.scanResult = self.imageToText(demoBlackAndWhite)
            
            self.processedScanResultDict = self.processReceiptText(self.scanResult)
            
            dispatch_async(dispatch_get_main_queue(), {
                hud.hide(true)
                self.view.userInteractionEnabled = true
                
                self.performSegueWithIdentifier("StartReviewSegueIdentifier", sender: self)
            });
        });
        //////////////////////////
        // DEMO WITH SCREENSHOT //
        //////////////////////////
            
        ////////////////
        // REAL THING //
        ////////////////
        #else
        self.stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (imageSampleBuffer, error) -> Void in

            /*
            var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageSampleBuffer)
            var imageDataAsUIImage = UIImage(data: imageData)
            var pngImageData = UIImagePNGRepresentation(imageDataAsUIImage)
            var blackAndWhitePngImage = UIImage(data: pngImageData)!.blackAndWhite()
            self.scanResult = self.imageToText(blackAndWhitePngImage.imageRotatedByDegrees(90.0))
            */
            
            // DEMO ON PHONE
            var demoBlackAndWhite = UIImage(named: "Screen Shot 2015-04-09 at 11.47.50 AM.png")!.blackAndWhite()
            self.scanResult = self.imageToText(demoBlackAndWhite)
            
            self.processedScanResultDict = self.processReceiptText(self.scanResult)
            
            hud.hide(true)
            self.view.userInteractionEnabled = true
            
            self.performSegueWithIdentifier("StartReviewSegueIdentifier", sender: self)
        })
        #endif
        ////////////////
        // REAL THING //
        ////////////////
    }
    
    func processReceiptText(text: String) -> [String:AnyObject] {
        var result:[String:AnyObject] = [:]
        
        var trimmedWhiteSpace = text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        println("Trimmed White Space: \n\(trimmedWhiteSpace)")
        
        var lineArray:[String] = trimmedWhiteSpace.componentsSeparatedByString("\n")
        var itemLines = [String]()
        var total = ""
        var location = ""
        var endsInPriceRegex = Regex(pattern: "\\d{1,6}(\\.\\d{2})$")
        
        for line in lineArray {
            var endsInPrice = endsInPriceRegex.test(line)
            if endsInPrice && line.lowercaseString.rangeOfString("total") != nil {
                total = line
            }
            else if endsInPrice {
                itemLines.append(line)
            }
            else if line.lowercaseString.rangeOfString("welcome to") != nil {
                var components = line.componentsSeparatedByString(" ")
                location = components[components.count - 1]
            }
        }
        result["location"] = location
        result["item_lines"] = itemLines
        result["total"] = total
        
        println(result)
        
        return result
    }
    
    // MARK: Button Methods
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "StartReviewSegueIdentifier" {
            var destinationViewController = segue.destinationViewController as! PurchasedItemListTableViewController
            destinationViewController.totalLine
                = self.processedScanResultDict["total"] as! String
            destinationViewController.itemList = self.processedScanResultDict["item_lines"] as! [String]
            destinationViewController.location = self.processedScanResultDict["location"] as! String
        }
    }
}

