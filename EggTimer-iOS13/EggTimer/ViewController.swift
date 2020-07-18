//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    
    // MARK: Members Variable
    let cookingTime: [String: Float] = ["Soft": 5,
                                      "Medium": 7,
                                      "Hard": 10]
    
    var secondsRemaining: Float = 60
    var secondsTotal: Float = 60

        
    var timer =  Timer()
        
    var player: AVAudioPlayer?

    
    // MARK: Outlets
    
    @IBOutlet var progressBar: UIProgressView!
    
    @IBOutlet weak var headingText: UILabel!
    
    
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @objc func updateTimer() {
        
        let remainderPercentage: Float = secondsRemaining / secondsTotal
        progressBar.progress = (1.0  -  remainderPercentage)
        
        if secondsRemaining > 0 {
            secondsRemaining-=1
            
            headingText.text = "How do you like your eggs?"
        }
        
        else {
        
            headingText.text = "Done"
            
            playSound()
            
            timer.invalidate()
        }
    }
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        // stop any previous timers running
        timer.invalidate()
                
        // read button title
        let hardness:String = sender.titleLabel!.text!
        
        // value from dict
        secondsRemaining = cookingTime[hardness]!
        secondsTotal = secondsRemaining
        
        
        timer =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer),
                                      userInfo: nil, repeats: true)
            
        
    }
    
    func playSound() {
        
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
}


