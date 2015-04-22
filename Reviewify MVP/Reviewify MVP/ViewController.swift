//
//  ViewController.swift
//  Reviewify MVP
//
//  Created by Bryce Langlotz on 2/24/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var scanResult:String!
    var camFocus:CameraFocus!
    var session: AVCaptureSession!
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var QRCode:String?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureCamera()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        qrCodeFrameView?.frame = CGRectZero
        captureSession?.startRunning()
        QRCode = nil
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let user = PFUser.currentUser() {
            println("Logged In")
        }
        else {
            performSegueWithIdentifier("ShowLogInSegueIdentifier", sender: self)
        }
    }
    
    @IBAction func showMyAccountDetails(sender:AnyObject!) {
        performSegueWithIdentifier("ShowLogInSegueIdentifier", sender: self)
    }
    
    @IBAction func showNearbyRestaurants(sender: AnyObject) {
        performSegueWithIdentifier("PeekSegueIdentifier", sender: self)
    }
    
    func configureCamera() -> Bool {
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        var error:NSError?
        let input: AnyObject! = AVCaptureDeviceInput.deviceInputWithDevice(captureDevice, error: &error)
        
        if (error != nil) {
            // If any error occurs, simply log the description of it and don't continue any more.
            println("\(error?.localizedDescription)")
            return false
        }
        
        // Initialize the captureSession object.
        captureSession = AVCaptureSession()
        
        // Set the input device on the capture session.
        captureSession?.addInput(input as! AVCaptureInput)
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        var bounds = self.view.bounds
        bounds.size = CGSizeMake(4/3 * bounds.size.width, bounds.size.height)
        videoPreviewLayer?.frame = bounds
        view.layer.addSublayer(videoPreviewLayer)
        
        captureSession?.startRunning()
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
        
        return true
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            println("No QR Code is Detected!")
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                QRCode = metadataObj.stringValue
                captureSession?.stopRunning()
                performSegueWithIdentifier("StartReviewSegueIdentifier", sender: self)
            }
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch: UITouch = event.allTouches()!.first as! UITouch
        var touchPoint:CGPoint = touch.locationInView(touch.view)
        focus()
        
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
    }
    
    func focus() {
        
    }
    
    // MARK: Button Methods
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "StartReviewSegueIdentifier" {
            var destinationViewController = segue.destinationViewController as! RewardsDetailsTableViewController
            destinationViewController.QRCode = QRCode!
        }
        
        if segue.identifier == "PeekSegueIdentifier" {
            println("Show Nearby")
        }
    }
}

