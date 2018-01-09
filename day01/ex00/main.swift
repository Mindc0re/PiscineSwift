print("\u{001B}[0;36mTesting all the singular values in the Color enum\u{001B}[0;0m");
print(Color.Spade.rawValue);
print(Color.Club.rawValue);
print(Color.Diamond.rawValue);
print(Color.Heart.rawValue);

print("\n\u{001B}[0;36mTesting all the values in the Color enum, using the 'allColors' static property\u{001B}[0;0m");
for color in Color.allColors
{
    print("Color : \(color.rawValue)");
}

print("\n\n\u{001B}[0;31mTesting all the singular values in the Value enum\u{001B}[0;0m");
print("Ace raw value is \(Value.Ace.rawValue)");
print("Two raw value is \(Value.Two.rawValue)");
print("Three raw value is \(Value.Three.rawValue)");
print("Four raw value is \(Value.Four.rawValue)");
print("Five raw value is \(Value.Five.rawValue)");
print("Six raw value is \(Value.Six.rawValue)");
print("Seven raw value is \(Value.Seven.rawValue)");
print("Eight raw value is \(Value.Eight.rawValue)");
print("Nine raw value is \(Value.Nine.rawValue)");
print("Ten raw value is \(Value.Ten.rawValue)");
print("Jack raw value is \(Value.Jack.rawValue)");
print("Queen raw value is \(Value.Queen.rawValue)");
print("King raw value is \(Value.King.rawValue)");

print("\n\u{001B}[0;31mTesting all the values in the Value enum, using the 'allValues' static property\u{001B}[0;0m");
for val in Value.allValues
{
    print("Value : \(val.rawValue)");
}
