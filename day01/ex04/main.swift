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

print("\n\u{001B}[0;31mInitial state :\u{001B}[0;0m", terminator: "");
printGame(deck: myDeck);

print("\n\u{001B}[0;31mDrawing 5 cards\u{001B}[0;0m", terminator: "");
_ = myDeck.draw();
_ = myDeck.draw();
_ = myDeck.draw();
_ = myDeck.draw();
_ = myDeck.draw();
printGame(deck: myDeck);

print("\n\u{001B}[0;31mFolding 3 cards\u{001B}[0;0m", terminator: "");
if let testUnwrap = myDeck.outs.first { myDeck.fold(c: testUnwrap); }
if let testUnwrap = myDeck.outs.first { myDeck.fold(c: testUnwrap); }
if let testUnwrap = myDeck.outs.first { myDeck.fold(c: testUnwrap); }

printGame(deck: myDeck);
