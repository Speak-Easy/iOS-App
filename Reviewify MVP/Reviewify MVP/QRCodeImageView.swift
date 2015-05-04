//
//  QRCodeView.swift
//  Speakeasy
//
//  Created by Bryce Langlotz on 5/3/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit

class QRCodeImageView: UIImageView {
    
    private var string:String!
    
    var qrCodeString:String! {
        get {
            return self.string
        }
        set (newValue) {
            var error:NSError?
            
            self.string = newValue
            
            var writer:ZXMultiFormatWriter = ZXMultiFormatWriter()
            var sideLength = Int32(self.frame.size.width)
            var result = writer.encode(string, format: kBarcodeFormatQRCode, width: sideLength, height: sideLength, error: &error)
            
            if let error = error {
                println(error.localizedDescription)
            }
            else {
                var image = UIImage(CGImage: ZXImage(matrix: result).cgimage)
                self.image = image
            }

        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
