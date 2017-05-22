//
//  HighScores.swift
//  ColorMemory
//
//  Created by Sushant Tiwari on 22/05/17.
//  Copyright © 2017 Sushant Tiwari. All rights reserved.
//

import UIKit

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

let kTopScoresKey = "topScoresKey"

class HighScores {
    static let sharedInstance = HighScores()
    
    func getTopScores() -> [Dictionary<String,String>] {
        return userDefaults().array(forKey: kTopScoresKey) as? [Dictionary<String,String>] ?? []
    }
    
    func saveTopScore(_ name: String, score: String) {
        var scores = getTopScores()
        let entry = ["name": name, "score": score]
        scores.append(entry)
        
        var sortedScores = scores.sorted { (entry1, entry2) -> Bool in
            let n1:String = entry1["score"]!
            let n2:String = entry2["score"]!
            return Double(n2) < Double(n1)
        }
        
        if sortedScores.count > 10 {
            sortedScores.removeLast()
        }
        
        userDefaults().set(sortedScores, forKey: kTopScoresKey)
    }
    
    fileprivate func userDefaults() -> UserDefaults {
        return UserDefaults.standard
    }
}
