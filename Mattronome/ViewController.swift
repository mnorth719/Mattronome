//
//  ViewController.swift
//  Mattronome
//
//  Created by Matt  North on 1/29/17.
//  Copyright © 2017 mmn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var beatCountLabel: UILabel!
    fileprivate var metronome: Metronome?
    fileprivate var metronomeLogger: MetronomeLogger?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let timeSig = TimeSignature(beatsPerMeasure: 4, notesPerBeat: 1)
        let speed = MusicSpeed(timeSignature: timeSig, beatsPerMinute: 120)
        metronome = Metronome()
        metronome?.speed = speed
        metronome?.metronomeListener = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func countingButtonPressed(_ sender: AnyObject) {
        guard let metronome = metronome else {
            return
        }
        
        if metronome.isCounting {
            metronome.stopCounting()
        } else {
            metronome.startCounting()
        }
    }
    
    fileprivate func updateBeat(countString: String) {
        beatCountLabel.text = countString
    }
    
}

extension ViewController: MetronomeListener {
    func metronomeDidCount(beat: Int, atSpeed: MusicSpeed) {
        print("beat: \(beat)")
        updateBeat(countString: String(beat))
    }
}


