print("\u{001B}[0;36mAll Spades :\u{001B}[0;0m");
for spade in Deck.allSpades
{
    print(spade);
}

print("\n\u{001B}[0;36mAll Clubs :\u{001B}[0;0m");
for club in Deck.allClubs
{
    print(club);
}

print("\n\u{001B}[0;36mAll Diamonds :\u{001B}[0;0m");
for diamond in Deck.allDiamonds
{
    print(diamond);
}

print("\n\u{001B}[0;36mAll Hearts :\u{001B}[0;0m");
for heart in Deck.allHearts
{
    print(heart);
}

print("\n\u{001B}[0;36mAll Cards :\u{001B}[0;0m");
for card in Deck.allCards
{
    print(card);
    if (card.value.rawValue == 13)
    {
        print("");
    }
}
