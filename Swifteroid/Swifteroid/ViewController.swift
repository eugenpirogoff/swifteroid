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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}

