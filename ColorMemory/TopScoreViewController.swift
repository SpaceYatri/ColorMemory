//
//  TopScoreViewController.swift
//  ColorMemory
//
//  Created by Sushant Tiwari on 22/05/17.
//  Copyright © 2017 Sushant Tiwari. All rights reserved.
//

import UIKit

class TopScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    var scores: Array<Dictionary<String,String>> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        scores = TopScores.sharedInstance.getTopScores()
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return scores.count == 0 ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    func canRotate() -> Void {}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "highScoreCell", for: indexPath) as! HighScoreTableViewCell
        
        let score = scores[indexPath.row]
        let name = score["name"]!
        
        cell.playerNameLabel.text = String(format: "%d. %@", indexPath.row+1, name)
        cell.playerScoreLabel.text = score["score"]!
        
        return cell
    }
    
    @IBAction func closeWindow(_ sender: UIButton) {
        self.dismiss(animated: true) { () -> Void in
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
