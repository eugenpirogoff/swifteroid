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
    
    var swifteroid : SwifteroidController!
    var startExposureDate : NSDate?
    var lastPhoto : UIImage?
    var exposure : NSTimeInterval = NSTimeInterval(0.0)
    var updateTimer : NSTimer?
    
    @IBOutlet weak var recButton: UIButton!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var exposureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swifteroid = SwifteroidController()
        let previewLayer = swifteroid.previewLayer
        previewLayer.frame = previewView.bounds
        previewView.layer.addSublayer(previewLayer)
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.00001, target: self, selector: Selector("updateExposureLabel"), userInfo: nil, repeats: true)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func savePreviewPhoto(sender: AnyObject) {
        if let image = lastPhoto {
            savePreviewdPhoto(image)
            print("", appendNewline: false)
        } else {
            print("No Phot to Save! \n", appendNewline: false)
        }
        clearPreview()
        lastPhoto = nil
    }
    
    @IBAction func deletePreviewPhoto(sender: AnyObject) {
        clearPreview()
        lastPhoto = nil
    }
    
    @IBAction func recTouchDown(sender: AnyObject) {
        startExposureDate = NSDate()
    }
    
    @IBAction func recTouchUp(sender: AnyObject) {
        if let started = startExposureDate {
            let now = NSDate()
            exposure = now.timeIntervalSinceDate(started)
        } else {
            exposure = 1.0
        }
        
        swifteroid.captureSingleStillImage(exposure) { (image, metadata) -> Void in
            self.lastPhoto = image
            self.previewPhoto(image)
        }
    }
    
    func previewPhoto(newPhoto: UIImage){
        self.lastPhoto = newPhoto
        let imageView = UIImageView(image: newPhoto)
        imageView.contentMode = .ScaleAspectFill
        imageView.frame = self.photoView.bounds
        self.photoView.addSubview(imageView)
    }
    
    func savePreviewdPhoto(image : UIImage){
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func clearPreview(){
        for view in photoView.subviews {
            view.removeFromSuperview()
        }
    }
    
    func updateExposureLabel(){
        if let date = startExposureDate {
            exposureLabel.text = NSDate().timeIntervalSinceDate(date).description
        }
    }
}

