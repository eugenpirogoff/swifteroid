//
//  SwifteroidController.swift
//  Swifteroid
//
//  Created by Eugen Pirogoff on 10/06/15.
//  Copyright (c) 2015 Eugen Pirogoff. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class SwifteroidController {
    
    let session = AVCaptureSession()
    var backCameraDevice : AVCaptureDevice!
    var frontCameraDevice : AVCaptureDevice!
    var output : AVCaptureStillImageOutput!
    
    var previewLayer:AVCaptureVideoPreviewLayer!
    var stillCameraOutput:AVCaptureStillImageOutput!

    var sessionQueue:dispatch_queue_t = dispatch_queue_create("me.pirogoff.swifteroid.session_access_queue", DISPATCH_QUEUE_SERIAL)
    
    init(){
        configurateCamera()
        configureStillImageCameraOutput()
    }
    
    func configurateCamera(){
        let availableCameraDevices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        
        for device in availableCameraDevices as! [AVCaptureDevice] {
            if device.position == .Back {
                backCameraDevice = device
            }
            else if device.position == .Front {
                frontCameraDevice = device
            }
        }
        
        var error:NSError?
        
        let possibleCameraInput: AnyObject?
        do {
            possibleCameraInput = try AVCaptureDeviceInput(device: backCameraDevice)
        } catch var error1 as NSError {
            error = error1
            possibleCameraInput = nil
        }
        if let backCameraInput = possibleCameraInput as? AVCaptureDeviceInput {
            if self.session.canAddInput(backCameraInput) {
                self.session.addInput(backCameraInput)
            }
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        session.sessionPreset = AVCaptureSessionPresetPhoto
        session.startRunning()
    }
    
    func captureSingleStillImage(exposure : NSTimeInterval, completionHandler handler: ((image:UIImage, metadata:NSDictionary) -> Void)) {
        dispatch_async(sessionQueue) { () -> Void in
            
            let connection = self.stillCameraOutput.connectionWithMediaType(AVMediaTypeVideo)
            connection.videoOrientation = AVCaptureVideoOrientation(rawValue: UIDevice.currentDevice().orientation.rawValue)!

            let exp = Float(exposure)
            let settings = [-exp, 0.0, exp].map {
                (bias:Float) -> AVCaptureAutoExposureBracketedStillImageSettings in
                AVCaptureAutoExposureBracketedStillImageSettings.autoExposureSettingsWithExposureTargetBias(bias)
            }
            
            self.stillCameraOutput.captureStillImageBracketAsynchronouslyFromConnection(connection, withSettingsArray: settings, completionHandler: {
                (sampleBuffer, captureSettings, error) -> Void in
                
                if error == nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    
                    let metadata:NSDictionary = CMCopyDictionaryOfAttachments(nil, sampleBuffer, CMAttachmentMode(kCMAttachmentMode_ShouldPropagate))!.takeUnretainedValue()
                    
                    if let image = UIImage(data: imageData) {
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            handler(image: image, metadata:metadata)
                        }
                    }
                }
                else {
                    NSLog("error while capturing still image: \(error)")
                }
            })
            
        }
    }
    
    func configureStillImageCameraOutput() {
        performConfiguration { () -> Void in
            self.stillCameraOutput = AVCaptureStillImageOutput()
            self.stillCameraOutput.outputSettings = [
                AVVideoCodecKey  : AVVideoCodecJPEG,
                AVVideoQualityKey: 0.9
            ]
            
            if self.session.canAddOutput(self.stillCameraOutput) {
                self.session.addOutput(self.stillCameraOutput)
            }
        }
    }
    
    func performConfiguration(block: (() -> Void)) {
        dispatch_async(sessionQueue) { () -> Void in
            block()
        }
    }
    
}