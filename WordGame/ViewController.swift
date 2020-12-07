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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        startGame()
        }
    
    func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {[weak self, weak ac] _ in guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        // We're turning all answers into lowercase because all the starter words in our start.txt file are all lowercased; remember that String types are case sensitive so we do this in order ensure we're comparing fully lowercase strings with each other
        let lowerAnswer = answer.lowercased()
        // We're nesting our three word validation functions here, meaning that all three must return true for the usedWords.insert method (our main block of code) to actually happen
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)
                    // IndexPath is our rows in our table view, so here we are inserting new rows at IndexPath row 0 (to match the index location of our answer just inserted into our usedWords array at position 0) each time this function executes; remember it only executes if the three word validation functions all return true
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    func isPossible(word: String) -> Bool {
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return true
    }
    
    func isReal(word: String) -> Bool {
        return true
    }
    
}
