//
//  ViewController.swift
//  FirstDemo
//
//  Created by Stanly Shiyanovskiy on 17.06.2022.
//

import UIKit

class ViewController: UIViewController {

    func numberOfVowels(in string: String) -> Int {
        let vowels: [Character] = [
            "a", "e", "i", "o", "u",
            "A", "E", "I", "O", "U",
        ]
        var numberOfVowels = 0
        for character in string {
            if vowels.contains(character) {
                numberOfVowels += 1
            }
        }
        
        return string
            .map { $0 }
            .reduce(0) { $0 + (vowels.contains($1) ? 1 : 0) }
    }
    
    func makeHeadline(from string: String) -> String {
        let words = string.components(separatedBy: " ")
        return words.map { $0.capitalized }.joined(separator: " ")
    }
}

