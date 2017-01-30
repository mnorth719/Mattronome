//
//  Music.swift
//  Mattronome
//
//  Created by Matt  North on 1/29/17.
//  Copyright © 2017 mmn. All rights reserved.
//

import Foundation


public struct TimeSignature {
    var beatsPerMeasure: Int
    var notesPerBeat: Int
}

public struct MusicSpeed {
    var timeSignature: TimeSignature
    var beatsPerMinute: Int
}
