//
//  MemoryGame.swift
//  Memorize
//
//  Created by Павел on 6/20/20.
//  Copyright © 2020 Павел. All rights reserved.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    var score = 0
    var seenCards = Set<Int>()
    
    private var indexOfFaceUpCard: Int? {
        get{ cards.indices.filter { cards[$0].isFaceUp}.only}
        set{
            for index in cards.indices{
                cards[index].isFaceUp = index == newValue
        }
    }
    }
    
    
    
    init(numberOfPairsCards: Int, cardContent: (Int) -> CardContent){
        cards = Array<Card>()
        
        for pairIndex in 0..<numberOfPairsCards{
            let content = cardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    
   mutating func choose(card: Card){
        print(card)
    if let chosenIndex: Int = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched{
        if let potentialMatchIndex = indexOfFaceUpCard{
            
            if cards[chosenIndex].content == cards[potentialMatchIndex].content{
                
                cards[chosenIndex].isMatched = true
                cards[potentialMatchIndex].isMatched = true
                score += 2
                if card.bonusTimeRemaining > 0{
                    score += 1
                }
            } else {
                if seenCards.contains(cards[chosenIndex].id){
                    score -= 1
                }
                if seenCards.contains(cards[potentialMatchIndex].id){
                    score -= 1
                }
                seenCards.insert(cards[chosenIndex].id)
                seenCards.insert(cards[potentialMatchIndex].id)
                print(seenCards)
            }
            self.cards[chosenIndex].isFaceUp = true
        } else {
            indexOfFaceUpCard = chosenIndex
        }
    }
    }
    
    struct Card: Identifiable{
        
        
        var isFaceUp: Bool = false{
            didSet{
                if isFaceUp{
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false{
            didSet{
                stopUsingBonusTime()
                
            }
        }
        var content: CardContent
        var id: Int
    
    //MARK: - bonus time
    
    var bonusTimeLimit: TimeInterval = 5
    
    private var faceUpTime: TimeInterval{
        if let lastFaceUpDate = self.lastFaceUpDate{
            return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
        } else {
            return pastFaceUpTime
        }
    }
    
    var lastFaceUpDate: Date?
    
    var pastFaceUpTime: TimeInterval = 0
    
    var bonusTimeRemaining: TimeInterval{
        max(0, bonusTimeLimit - faceUpTime)
    }
    
    var bonusRemaining: Double{
        (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
    }
    
    var hasEarnedBonus: Bool{
        isMatched && bonusTimeRemaining > 0
        
    }
    
    var isConsumingBonusTime: Bool{
        isFaceUp && !isMatched && bonusTimeRemaining > 0
    }
    
    private mutating func startUsingBonusTime(){
        if isConsumingBonusTime, lastFaceUpDate == nil{
            lastFaceUpDate = Date()
        }
    }
    
    
        
    private mutating func stopUsingBonusTime(){
        pastFaceUpTime = faceUpTime
        self.lastFaceUpDate = nil
        
    }
    
    
}
    
    
    
    

    
}
