//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Павел on 6/20/20.
//  Copyright © 2020 Павел. All rights reserved.
//

import Foundation



class EmojiMemoryGame: ObservableObject{
    
    @Published private var game: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    private static func createMemoryGame() -> MemoryGame<String> {
        let emojis: Array<String> = ["🤪 ","😛", "😏", "😜"]
        return MemoryGame<String>(numberOfPairsCards: 4){pairIndex in
            return emojis[pairIndex]
        }
    }
    
    var cards: Array<MemoryGame<String>.Card>{
        game.cards
    }
    
    func choose(card: MemoryGame<String>.Card){
        game.choose(card: card)
    }
    
    func resetGame(){
        game = EmojiMemoryGame.createMemoryGame()
    }
    
    var score: Int{
        return game.score
    }
}
