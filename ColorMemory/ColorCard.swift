//
//  ColorCard.swift
//  ColorMemory
//
//  Created by Sushant Tiwari on 22/05/17.
//  Copyright © 2017 Sushant Tiwari. All rights reserved.
//

import UIKit

class ColorCard: NSObject {
    
    // MARK: - Properties
    var uid:UUID = UUID.init()
    var shown:Bool = false
    var image:UIImage
    
    // MARK: - Init
    init(image:UIImage) {
        self.image = image
    }
    
    init(card:ColorCard) {
        self.uid = (card.uid as NSUUID).copy() as! UUID
        self.shown = card.shown
        self.image = card.image.copy() as! UIImage
    }
    
    // MARK: - Methods    
    func equals(_ card: ColorCard) -> Bool {
        return (card.uid == uid)
    }
}
