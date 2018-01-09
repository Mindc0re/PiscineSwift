/* Creating 4 different instances of the Card class */
let AceOfSpade = Card(c: Color.Spade, v: Value.Ace);
let AceOfSpade2 = Card(c: Color.Spade, v: Value.Ace);
let ThreeOfClub = Card(c: Color.Club, v: Value.Three);
let QueenOfDiamond = Card(c: Color.Diamond, v: Value.Queen);


print("\u{001B}[0;36mTesting the description computed property\u{001B}[0;0m");
print(AceOfSpade);
print(AceOfSpade2);
print(ThreeOfClub);
print(QueenOfDiamond);


print("\n\u{001B}[0;36mTesting the isEqual method\u{001B}[0;0m");
print(AceOfSpade.isEqual(AceOfSpade2));
print(AceOfSpade.isEqual(ThreeOfClub));
print(QueenOfDiamond.isEqual(ThreeOfClub));

print("\n\u{001B}[0;36mTesting the '==' operator's overload\u{001B}[0;0m");
print(AceOfSpade == AceOfSpade2);
print(AceOfSpade == ThreeOfClub);
print(QueenOfDiamond == ThreeOfClub);
