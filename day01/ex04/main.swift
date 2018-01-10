func printGame(deck: Deck)
{
    print("\n\u{001B}[0;36mCards remaning : \u{001B}[0;0m");
    print(deck.description);
    
    print("\n\u{001B}[0;36mCards out : \u{001B}[0;0m");
    for c in deck.outs
    {
        print(c);
    }
    
    print("\n\u{001B}[0;36mDiscarded cards : \u{001B}[0;0m");
    for c in deck.discards
    {
        print(c);
    }
}

var myDeck = Deck(shuffle: true);

print("\n\u{001B}[0;31mCreating a shuffled deck\u{001B}[0;0m");
print("\u{001B}[0;31mInitial state :\u{001B}[0;0m", terminator: "");
printGame(deck: myDeck);

print("\n\u{001B}[0;31mFolding a card that's not in 'outs'\u{001B}[0;0m", terminator: "");
let foldCard = Card(c: Color.Spade, v: Value.Ace);
myDeck.fold(c: foldCard);
printGame(deck: myDeck);

print("\n\u{001B}[0;31mDrawing 5 cards\u{001B}[0;0m", terminator: "");
_ = myDeck.draw();
_ = myDeck.draw();
_ = myDeck.draw();
_ = myDeck.draw();
_ = myDeck.draw();
printGame(deck: myDeck);

print("\n\u{001B}[0;31mFolding 5 cards\u{001B}[0;0m", terminator: "");
if let testUnwrap = myDeck.outs.first { myDeck.fold(c: testUnwrap); }
if let testUnwrap = myDeck.outs.first { myDeck.fold(c: testUnwrap); }
if let testUnwrap = myDeck.outs.first { myDeck.fold(c: testUnwrap); }
if let testUnwrap = myDeck.outs.first { myDeck.fold(c: testUnwrap); }
if let testUnwrap = myDeck.outs.first { myDeck.fold(c: testUnwrap); }

printGame(deck: myDeck);

print("\n\u{001B}[0;31mFolding 1 more card (Testing folding without cards in 'outs')\u{001B}[0;0m", terminator: "");
if let testUnwrap = myDeck.outs.first { myDeck.fold(c: testUnwrap); }

printGame(deck: myDeck);

print("\n\u{001B}[0;31mCreating a sorted deck\u{001B}[0;0m", terminator: "");
print("\n\u{001B}[0;31mInitial state :\u{001B}[0;0m", terminator: "");
var sortedDeck = Deck(shuffle: false);
printGame(deck: sortedDeck);

print("\n\u{001B}[0;31mDrawing all the cards except the King of Heart\u{001B}[0;0m", terminator: "");
for _ in 0...50
{
    _ = sortedDeck.draw();
}
printGame(deck: sortedDeck);

print("\n\u{001B}[0;31mFolding a card that's not in 'outs' (here, the King of Heart)\u{001B}[0;0m", terminator: "");
let foldCard2 = Card(c: Color.Heart, v: Value.King);
sortedDeck.fold(c: foldCard2);
printGame(deck: sortedDeck);

print("\n\u{001B}[0;31mDrawing the last card, and one another to test if the draw is protected when there is no card remaning in 'cards'\u{001B}[0;0m", terminator: "");
let _ = sortedDeck.draw();
let _ = sortedDeck.draw();
printGame(deck: sortedDeck);

