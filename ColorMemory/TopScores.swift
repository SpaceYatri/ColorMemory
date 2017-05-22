//
//  HighScores.swift
//  ColorMemory
//
//  Created by Sushant Tiwari on 22/05/17.
//  Copyright © 2017 Sushant Tiwari. All rights reserved.
//

import UIKit

/**
 function for comparing optional variables of same type
 */
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

/// Manages top score list. Saves top 10 scoring players.
class TopScores {
    static let sharedInstance = TopScores()
    
    func getTopScores() -> [Dictionary<String,String>] {
        return userDefaults().array(forKey: kTopScoresKey) as? [Dictionary<String,String>] ?? []
    }
    
    func saveTopScore(_ name: String, score: String) {
        var scores = getTopScores()
        let entry = ["name": name, "score": score]
        scores.append(entry)
        
        var sortedScores = scores.sorted { (score1, score2) -> Bool in
            let s1:String = score1["score"]!
            let s2:String = score2["score"]!
            return Double(s2) < Double(s1)
        }
        
        if sortedScores.count > 10 {
            sortedScores.removeLast()
        }
        
        userDefaults().set(sortedScores, forKey: kTopScoresKey)
    }
    
    fileprivate func userDefaults() -> UserDefaults {
        return UserDefaults.standard
    }
    
    /**
     Calculate ranking of the current score by fetching the already saved list of top 10 scores and comparing it. 
     
     - Parameter score: score for which ranking needs to be calculated.
     
     - Returns: current ranking for that score.
     */
    func calculateRankings(forScore score: String) -> String {
        let scores = getTopScores()
        if scores.count == 0 {
            return "1"
        }
        for (index, element) in scores.enumerated() {
            if Double(element["score"]!) < Double(score) {
                return "\(index + 1)"
            }
        }
        return "NIL"
    }
}
