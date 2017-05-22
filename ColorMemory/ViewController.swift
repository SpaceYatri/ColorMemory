//
//  ViewController.swift
//  ColorMemory
//
//  Created by Sushant Tiwari on 22/05/17.
//  Copyright © 2017 Sushant Tiwari. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ColorMemoryDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreCardView: UIView!
    fileprivate var activeCards: [IndexPath] = []
    let colorMemoryGame = ColorMemoryGame()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreCardView.layer.cornerRadius = 4
        colorMemoryGame.delegate = self
        setupNewGame()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Methods
    
    func resetGame() {
        colorMemoryGame.resetGame()
        setupNewGame()
    }
    
    func setupNewGame() {
        let cardsData:[UIImage] = ColorMemoryGame.defaultCardImages
        scoreLabel.text = "0"
        colorMemoryGame.newGame(cardsData)
    }
    
    func savePlayerScore(_ name: String) {
        HighScores.sharedInstance.saveTopScore(name, score: scoreLabel.text!)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorMemoryGame.numberOfCards > 0 ? colorMemoryGame.numberOfCards : 16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCard", for: indexPath) as! ColorCardCollectionViewCell
        cell.showCard(false, animted: false)
        
        guard let card = colorMemoryGame.cardAtIndex(indexPath.item) else { return cell }
        cell.card = card
        cell.isHidden = false
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ColorCardCollectionViewCell
        if cell.shown { return }
        activeCards.append(indexPath)
        colorMemoryGame.didSelectCard(cell.card)
        
        collectionView.deselectItem(at: indexPath, animated:true)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth: CGFloat = collectionView.frame.width / 4.0 - 15.0
        let itemHeight = (itemWidth * 190) / 152
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = (collectionView.frame.height - (4 * 190 * (collectionView.frame.width / 4.0 - 15.0) / 152) ) / 5
        return UIEdgeInsetsMake(inset, 10, inset, 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let inset = (collectionView.frame.height - (4 * 190 * (collectionView.frame.width / 4.0 - 15.0) / 152) ) / 5
        return inset
    }
    
    // MARK: - MemoryGameDelegate
    
    func colorMemoryDidStart(_ game: ColorMemoryGame) {
        collectionView.reloadData()
        collectionView.isUserInteractionEnabled = true
    }
    
    func colorMemory(_ game: ColorMemoryGame, showCards cards: [ColorCard]) {
        for card in cards {
            guard let index = colorMemoryGame.indexForCard(card) else { continue }
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section:0)) as! ColorCardCollectionViewCell
            cell.showCard(true, animted: true)
        }
    }
    
    func colorMemory(_ game: ColorMemoryGame, hideCards cards: [ColorCard]) {
        for card in cards {
            guard let index = colorMemoryGame.indexForCard(card) else { continue }
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section:0)) as! ColorCardCollectionViewCell
            cell.showCard(false, animted: true)
        }
    }
    
    
    func colorMemoryDidEnd(_ game: ColorMemoryGame) {
        let alertController = UIAlertController(
            title: "Save Score",
            message: "You finished the game with a score of " + scoreLabel.text!,
            preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save Score", style: .default) {
            [unowned self] (_) in
            if let playerNameField = alertController.textFields?.first  {
                if let playerName = playerNameField.text {
                    self.savePlayerScore(playerName)
                    self.resetGame()
                }
            }
        }
        saveAction.isEnabled = false
        alertController.addAction(saveAction)
        
        alertController.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("Your name", comment: "your name")
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                saveAction.isEnabled = textField.text != ""
            }
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: "dismiss"), style: .cancel) { [weak self] (action) in
            self?.resetGame()
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true) { }
    }
    
    func colorMemoryCorrectPair() {
        guard let score = Int(scoreLabel.text!) else {
            return
        }
        
        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        let index0 = self.activeCards[0]
        let index1 = self.activeCards[1]
        self.activeCards.removeAll()
        DispatchQueue.main.asyncAfter(deadline: delayTime) { [weak self] in
            self?.collectionView.cellForItem(at: index0)?.isHidden = true
            self?.collectionView.cellForItem(at: index1)?.isHidden = true
        }
        scoreLabel.text = "\(score + 2)"
    }
    
    func colorMemoryIncorrectPair() {
        guard let score = Int(scoreLabel.text!) else {
            return
        }
        self.activeCards.removeAll()
        scoreLabel.text = "\(score - 1)"
    }
    
}

