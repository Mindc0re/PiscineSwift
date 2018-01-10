import Foundation
class Card : NSObject
{
    var color: Color;
    var value: Value;
    
    override var description: String
    {
        switch self.value.rawValue
        {
        case 1:
            return "Ace of \(self.color.rawValue)";
        case 11:
            return "Jack of \(self.color.rawValue)";
        case 12:
            return "Queen of \(self.color.rawValue)";
        case 13:
            return "King of \(self.color.rawValue)";
        default:
            return "\(self.value.rawValue) of \(self.color.rawValue)";
        }
    }
    
    init(c: Color, v: Value)
    {
        color = c;
        value = v;
    }
    
    override func isEqual(_ object: Any?) -> Bool
    {
        let castedObj = object as? Card;
        if (castedObj?.color.rawValue == self.color.rawValue && castedObj?.value.rawValue == self.value.rawValue)
        {
            return true;
        }
        
        return false;
    }
}

func ==(left: Card, right: Card) -> Bool
{
    if (left.color.rawValue == right.color.rawValue && left.value.rawValue == right.value.rawValue)
    {
        return true;
    }
    
    return false;
}
