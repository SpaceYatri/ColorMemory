//
//  ColorCardCollectionViewCell.swift
//  ColorMemory
//
//  Created by Sushant Tiwari on 22/05/17.
//  Copyright © 2017 Sushant Tiwari. All rights reserved.
//

import UIKit

class ColorCardCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:ColorCard? {
        didSet {
            guard let card = card else { return }
            frontImageView.image = card.image
        }
    }
    
    fileprivate(set) var shown: Bool = false
    
    // MARK: - Methods
    
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
