import Foundation

class Deck : NSObject
{
    static let allSpades: [Card] = Value.allValues.map { Card(c: Color.Spade, v: $0); }
    static let allClubs: [Card] = Value.allValues.map { Card(c: Color.Club, v: $0); }
    static let allDiamonds: [Card] = Value.allValues.map { Card(c: Color.Diamond, v: $0); }
    static let allHearts: [Card] = Value.allValues.map { Card(c: Color.Heart, v: $0); }
    
    static let allCards: [Card] = allSpades + allClubs + allDiamonds + allHearts;
}

extension Array
{
    mutating func randShuffle()
    {
        if self.count == 0
        {
            return ;
        }
        var swap: Element;
        var rand: Int;
        
        for i in 0...(self.count - 1)
        {
            rand = Int(arc4random_uniform(UInt32(self.count)));
            swap = self[rand];
            self[rand] = self[i];
            self[i] = swap;
        }
    }
}
