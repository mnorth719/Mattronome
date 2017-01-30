//
//  metronome.swift
//  Mattronome
//
//  Created by Matt  North on 1/29/17.
//  Copyright © 2017 mmn. All rights reserved.
//

import Foundation

public protocol MetronomeListener {
    func metronomeDidCount(beat: Int, atSpeed: MusicSpeed)
}

public class Metronome {
    open var speed: MusicSpeed?
    open var metronomeListener: MetronomeListener?
    open var isCounting: Bool {
        return beatTimer != nil
    }
    
    fileprivate var currentBeat: Int = 1
    fileprivate var beatTimer: Timer?
    
    public func startCounting() {
        //speed cannot be nil to begin counting.
        guard let speed = speed else {
            return
        }
        
        beatTimer?.invalidate()
        beatTimer = nil
        beatTimer = Timer.scheduledTimer(withTimeInterval: (1.0 / speed.beatsPerSecond()), repeats: true, block: {[weak self] (Timer) in
            self?.incrementBeat()
        })
    }
    
    public func stopCounting() {
        beatTimer?.invalidate()
        beatTimer = nil
    }
    
    private func incrementBeat() {
        guard let speed = speed else {
            return
        }
        
        if speed.timeSignature.isFinal(beat: currentBeat) {
            currentBeat = 1
        } else {
            currentBeat += 1
        }
        
        if let metronomeListener = metronomeListener {
            metronomeListener.metronomeDidCount(beat: currentBeat, atSpeed: speed)
        }
    }
}

extension TimeSignature {
    func isFinal(beat: Int) -> Bool {
        return beat == beatsPerMeasure
    }
}

extension MusicSpeed {
    func beatsPerSecond() -> Double {
        if beatsPerMinute <= 0 {
            return 0
        }
        
        let beatsPerMinuteAsDouble = Double(beatsPerMinute)
        return beatsPerMinuteAsDouble / 60.0
    }
}
