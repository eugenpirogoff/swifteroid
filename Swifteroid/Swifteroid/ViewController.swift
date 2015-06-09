//
//  ViewController.swift
//  Swifteroid
//
//  Created by Eugen Pirogoff on 09/06/15.
//  Copyright (c) 2015 Eugen Pirogoff. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var recButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!

    let session = AVCaptureSession()
    var backCameraDevice : AVCaptureDevice!
    var frontCameraDevice : AVCaptureDevice!
    var output : AVCaptureStillImageOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateCamera()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recTouchDown(sender: AnyObject) {
        print("Exposure Started")
    }
    
    @IBAction func recTouchUp(sender: AnyObject) {
        println("Exposure Ended")
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
        
        let possibleCameraInput: AnyObject? = AVCaptureDeviceInput.deviceInputWithDevice(backCameraDevice, error: &error)
        
        if let backCameraInput = possibleCameraInput as? AVCaptureDeviceInput {
            if session.canAddInput(backCameraInput) {
                session.addInput(backCameraInput)
            }
        }
        
        var previewLayer = AVCaptureVideoPreviewLayer.layerWithSession(session) as! AVCaptureVideoPreviewLayer
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer.frame = imageView.bounds
        imageView.layer.addSublayer(previewLayer)
        session.sessionPreset = AVCaptureSessionPresetPhoto
        session.startRunning()
    }
    
}

