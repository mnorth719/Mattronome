//
//  MetronomeLogger.swift
//  Mattronome
//
//  Created by Matt  North on 1/29/17.
//  Copyright © 2017 mmn. All rights reserved.
//

import Foundation

class MetronomeLogger: MetronomeListener {
    var metronome: Metronome
    init(withMetronome: Metronome) {
        metronome = withMetronome
    }
    
    func metronomeDidCount(beat: Int, atSpeed: MusicSpeed) {
        print("metronome fired at beat: \(beat) and speed: \(atSpeed.description())")
    }
}

extension MusicSpeed {
    func description() -> String {
        return "\(beatsPerMinute) BPM"
    }
}
