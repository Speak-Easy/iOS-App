//
//  ChargingViewController.swift
//  SpeakEasy
//
//  Created by Bryce Langlotz on 5/4/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit
import AVFoundation

class ChargingViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var deal: PFObject!
    
    var scanResult:String!
    var session: AVCaptureSession!
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var QRCode:String?
    var cost:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cost = deal["cost"] as! Int
        self.configureCamera()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        qrCodeFrameView?.frame = CGRectZero
        captureSession?.startRunning()
        QRCode = nil
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
                self.captureSession?.stopRunning()
                
                var splitQRCode = QRCode!.componentsSeparatedByString(" ")
                
                if splitQRCode.count == 2 {
                    var username = splitQRCode[0]
                    var points = splitQRCode[1]
                    
                    if points.toInt() == cost {
                        // Charge User
                        self.view.userInteractionEnabled = false
                        var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.labelText = "Charging"
                        PFCloud.chargeUser(username, numberOfPoints: points.toInt(), block: { (results, error) -> Void in
                            if let error = error {
                                println(error.description)
                                if let alertMessage = error.userInfo?["error"] as? String {
                                    self.showAlert(alertMessage)
                                }
                            }
                            if let chargedAmount = results as? Int {
                                self.showAlert("User Charged \(chargedAmount)")
                                self.navigationController?.popToRootViewControllerAnimated(true)
                            }
                            hud.hide(true)
                        })
                    }
                    else {
                        showAlert("The cost entered by the user does not match the deal cost!")
                    }
                }
                else {
                    showAlert("The customer must enter the deal's cost!")
                }
            }
        }
    }
    
    func showAlert(message:String!) {
        var alertView = UIAlertView(title: message, message: nil, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
