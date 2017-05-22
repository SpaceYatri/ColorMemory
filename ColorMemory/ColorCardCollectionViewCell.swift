//
//  ColorCardCollectionViewCell.swift
//  ColorMemory
//
//  Created by Sushant Tiwari on 22/05/17.
//  Copyright © 2017 Sushant Tiwari. All rights reserved.
//

import UIKit

/// represents single cell from the game. Contains the card and its behaviour on touch/tap.
class ColorCardCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    //set the front image of the card based on ColorCard info. back image will be same for all.
    var card:ColorCard? {
        didSet {
            guard let card = card else { return }
            frontImageView.image = card.image
        }
    }
    
    fileprivate(set) var shown: Bool = false
    
    // MARK: - Methods
    
    /**
     Based on available images, creates a shuffled set of cards for the game.
     
     - Parameter show: determines whether card should be revealed or hides.
     - Parameter animated: determines whether revalation/hidden should be done with animation or not
    */
    func showCard(_ show: Bool, animted: Bool) {
        frontImageView.isHidden = false
        backImageView.isHidden = false
        shown = show
        
        if animted {
            if show {
                UIView.transition(from: backImageView,
                                  to: frontImageView,
                                  duration: 0.3,
                                  options: [.transitionFlipFromRight, .showHideTransitionViews],
                                  completion: nil)
            } else {
                UIView.transition(from: frontImageView,
                                  to: backImageView,
                                  duration: 0.3,
                                  options: [.transitionFlipFromLeft, .showHideTransitionViews],
                                  completion:  nil)
            }
        } else {
            if show {
                bringSubview(toFront: frontImageView)
                backImageView.isHidden = true
            } else {
                bringSubview(toFront: backImageView)
                frontImageView.isHidden = true
            }
        }
    }
    
    
}
