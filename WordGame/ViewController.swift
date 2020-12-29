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
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(startGame))
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
    
    @objc func startGame() {
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
        
    func isPossible(word: String) -> Bool {
        // Remember that guard lets us check if the optional (title) exists and we return out of this scope if it doesn't (in this case by returning false...we could also throw an error or just do a plain return and exit the block)
        guard var tempWord = title?.lowercased() else {
            return false
        }
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        if word == title {
            return false
        }
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        let wordLength = word.utf16.count
        if wordLength < 3 {
            return false
        }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: wordLength)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    // FIXME: The functions don't work quite well; typing in gibberish calls the message for isPossible and typing a legit word that may be a person's name calls the message for isReal...gibberish should call isReal
    
    // FIXME: If we enter a three letter word in uppercase, that is accepted, we can enter the same word in lowercase and it will be accepted again
    
    func submit(_ answer: String) {
        // We're turning all answers into lowercase because all the starter words in our start.txt file are all lowercased; remember that String types are case sensitive so we do this in order ensure we're comparing fully lowercase strings with each other
        let lowerAnswer = answer.lowercased()
        let errorTitle: String
        let errorMessage: String
        // We're nesting our three word validation functions here, meaning that all three must return true for the usedWords.insert method (our main block of code) to actually happen
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)
                    // IndexPath is our rows in our table view, so here we are inserting new rows at IndexPath row 0 (to match the index location of our answer just inserted into our usedWords array at position 0) each time this function executes; remember it only executes if the three word validation functions all return true
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    return
                } else {
                    errorTitle = "Word not recognised"
                    errorMessage = "You can't just make up words, you know!! (Yeah, we know, ALL words are made up 😆). Your word also must be at least three letters."
                }
            } else {
                errorTitle = "Word used already"
                errorMessage = "Either you already used that word or you're just using the original word. Thought you'd sneak that by me, huh?"
            }
        } else {
            guard let title = title?.lowercased() else { return }
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from \(title)"
        }
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}
