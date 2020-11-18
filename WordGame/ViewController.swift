//
//  ViewController.swift
//  WordGame
//
//  Created by Rob Ranf on 11/13/20.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()
    
    // By using try? in our startWords function we are basically
    // turning this function into a function
    // that returns an optional and saying call this code and
    // if it throws an error, just send back nil instead vs try!
    // which force unwraps the return causing a crash if it errors
    // e.g. in this instance in case startWordsURL returns nil
    override func viewDidLoad() {
        super.viewDidLoad()
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
    }
}
