var nilTab = [nil] as [Any?];
var intTab = [0,1,2,3,4,5,6,7,8,9,0];
var cardTab : [Card] = Deck.allSpades;

print("\u{001B}[0;36mTesting 'nilTab'\u{001B}[0;0m");
print("Before randShuffle : \(nilTab)");
nilTab.randShuffle();
print("After randShuffle : \(nilTab)");
nilTab.randShuffle();
print("After randShuffle : \(nilTab)");
nilTab.randShuffle();

print("\n\u{001B}[0;36mTesting 'intTab'\u{001B}[0;0m");
print("Before randShuffle : \(intTab)");
intTab.randShuffle();
print("After randShuffle : \(intTab)");
intTab.randShuffle();
print("After randShuffle : \(intTab)");
intTab.randShuffle();

print("\n\u{001B}[0;36mTesting 'cardTab'\u{001B}[0;0m");
print("Before randShuffle : \(cardTab)");
cardTab.randShuffle();
print("After randShuffle : \(cardTab)");
cardTab.randShuffle();
print("After randShuffle : \(cardTab)");
cardTab.randShuffle();
