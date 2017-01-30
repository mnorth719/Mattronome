//
//  InterfaceController.swift
//  WatchMattronome Extension
//
//  Created by Matt  North on 1/29/17.
//  Copyright © 2017 mmn. All rights reserved.
//

import WatchKit
import Foundation



class InterfaceController: WKInterfaceController {
    
    //MARK: - Outlets
    let backgroundImage = UIImage(named: "circle")
    @IBOutlet var mainGroup: WKInterfaceGroup!
    @IBOutlet var countButton: WKInterfaceButton!
    
    //MARK: - VARS
    
    fileprivate var metronome: Metronome?
    
    //MARK: - Boiler Plate
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        updateCountLabel(withString: "Go!")
        
        // Configure interface objects here.
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        let timeSig = TimeSignature(beatsPerMeasure: 4, notesPerBeat: 1)
        let speed = MusicSpeed(timeSignature: timeSig, beatsPerMinute: 120)
        metronome = Metronome()
        metronome?.speed = speed
        metronome?.metronomeListener = self

    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        metronome?.stopCounting()
        metronome = nil
        updateCountLabel(withString: "Go!")
    }
    
    //MARK: - PULSE
    
    fileprivate func pulse(withVibration: Bool) {
        //vibrate watch
        //TODO: wrap around setting
        if withVibration {
            WKInterfaceDevice.current().play(.click)
        }
        
        if let backgroundImage = backgroundImage {
            animate(withDuration: 0.2) { [weak self] in
                self?.mainGroup.setBackgroundImage(backgroundImage.maskWithColor(color: UIColor.white))
            }
            
            let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: {[weak self] (Timer) in
                self?.animate(withDuration: 0.2) { [weak self] in
                    self?.mainGroup.setBackgroundImage(backgroundImage)
                }
            })
        }
    }
    
    fileprivate func updateCountLabel(withString: String) {
        countButton.setTitle(withString)
    }
    
    @IBAction func countButtonPushed() {
        guard let metronome = metronome else {
            return
        }
        
        pulse(withVibration: true)
        if metronome.isCounting {
            metronome.stopCounting()
        } else {
            metronome.startCounting()
        }
    }
}

extension InterfaceController: MetronomeListener {
    func metronomeDidCount(beat: Int, atSpeed: MusicSpeed) {
        pulse(withVibration: true)
        updateCountLabel(withString: String(beat))
        print("\(beat)")
    }
}

extension UIImage {
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
}
