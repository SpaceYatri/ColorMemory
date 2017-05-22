//
//  ColorMemoryLogic.swift
//  ColorMemory
//
//  Created by Sushant Tiwari on 22/05/17.
//  Copyright © 2017 Sushant Tiwari. All rights reserved.
//

import Foundation
import UIKit
//MARK: - Protocol
protocol ColorMemoryDelegate {
    func colorMemoryDidStart(_ instance: ColorMemoryGame)
    func colorMemoryCorrectPair()
    func colorMemoryIncorrectPair()
    func colorMemory(_ instance: ColorMemoryGame, showCards cards: [ColorCard])
    func colorMemory(_ instance: ColorMemoryGame, hideCards cards: [ColorCard])
    func colorMemoryDidEnd(_ instance: ColorMemoryGame)
}

/// Business logic of ColorMemory game is written in this class
class ColorMemoryGame {
    
    // MARK: - Properties
    
    static var defaultCardImages:[UIImage] = [
        UIImage(named: "colour1")!,
        UIImage(named: "colour2")!,
        UIImage(named: "colour3")!,
        UIImage(named: "colour4")!,
        UIImage(named: "colour5")!,
        UIImage(named: "colour6")!,
        UIImage(named: "colour7")!,
        UIImage(named: "colour8")!
    ];
    
    var cards:[ColorCard] = [ColorCard]()
    fileprivate var cardsShown:[ColorCard] = [ColorCard]()
    
    var delegate: ColorMemoryDelegate?

    var numberOfCards: Int {
        get {
            return cards.count
        }
    }
    
    // MARK: - Methods
    
    /**
     initializes variables to fire delegate to initiate the game
     
     - Parameter cardsData: array of images used for cards
     
     */
    func newGame(_ cardsData:[UIImage]) {
        cards = randomCards(cardsData)
        delegate?.colorMemoryDidStart(self)
    }
    
    /**
     resets properties and the game.
     */
    func resetGame() {
        cards.removeAll()
        cardsShown.removeAll()
    }
    
    /**
     business logic after a card is selected. For the second card, its been compared with the one before. When shownCards = total cards, game is finished.
     
     - Parameter card: ColorCard that is being selected.
     */
    func didSelectCard(_ card: ColorCard?) {
        guard let card = card else { return }
        
        delegate?.colorMemory(self, showCards: [card])
        
        if unpairedCardShown() {
            let unpaired = unpairedCard()!
            if card.equals(unpaired) {
                cardsShown.append(card)
                delegate?.colorMemoryCorrectPair()
            } else {
                let unpairedCard = cardsShown.removeLast()
                
                let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.delegate?.colorMemory(self, hideCards:[card, unpairedCard])
                }
                delegate?.colorMemoryIncorrectPair()
            }
        } else {
            cardsShown.append(card)
        }
        
        if cardsShown.count == cards.count {
            finishGame()
        }
    }
    
    /**
     returns the ColorCard from the array at Index = index.
     */
    func cardAtIndex(_ index: Int) -> ColorCard? {
        if cards.count > index {
            return cards[index]
        } else {
            return nil
        }
    }
    
    /**
     checks the index of the card in the array
     */
    func indexForCard(_ card: ColorCard) -> Int? {
        for index in 0...cards.count-1 {
            if card === cards[index] {
                return index
            }
        }
        return nil
    }
    
    fileprivate func finishGame() {
        delegate?.colorMemoryDidEnd(self)
    }
    
    fileprivate func unpairedCardShown() -> Bool {
        return cardsShown.count % 2 != 0
    }
    
    fileprivate func unpairedCard() -> ColorCard? {
        let unpairedCard = cardsShown.last
        return unpairedCard
    }
    
    /**
     Based on available images, creates a shuffled set of cards for the game.
     
     - Parameter cardsData: imageList for creating ColorCard pairs.
     
     - Returns: shuffled deck of n cards with n/2 pairs.
     */
    fileprivate func randomCards(_ cardsData:[UIImage]) -> [ColorCard] {
        var cards = [ColorCard]()
        for i in 0...cardsData.count-1 {
            let card = ColorCard.init(image: cardsData[i])
            cards.append(contentsOf: [card, ColorCard.init(card: card)])
        }
        cards.shuffle()
        return cards
    }
}

extension Array {
    /**
     shuffle the array elements
     */
    mutating func shuffle() {
        for _ in 1...self.count {
            self.sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
