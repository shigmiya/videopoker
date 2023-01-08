enum Face {
  TWO(0, '2'),
  THREE(1, '3'),
  FOUR(2, '4'),
  FIVE(3, '5'),
  SIX(4, '6'),
  SEVEN(5, '7'),
  EIGHT(6, '8'),
  NINE(7, '9'),
  TEN(8, '10'),
  JACK(9, 'J'),
  QUEEN(10, 'Q'),
  KING(11, 'K'),
  ACE(12, 'A');

  final int value;
  final String character;
  const Face(this.value, this.character);
}

enum Suit {
  HEART(0, 'H'),
  SPADE(1, 'S'),
  CLUB(2, 'C'),
  DIAMOND(3, 'D');

  final int value;
  final String character;
  const Suit(this.value, this.character);
}

const numFaces = 13;
const numSuits = 4;

class Card {
  Face face;
  Suit suit;
  int value;
  Card(this.face, this.suit) : value = face.value + suit.value * numFaces;

  @override
  String toString() {
    return face.character + suit.character;
  }
}

class Hand {
  List<Card> cards;
  Hand(this.cards);
}

class Deck {
  List<Card> cards = [];
  int nextCardIndex = 0;

  void initDeck() {
    cards.clear();
    for (final face in Face.values) {
      for (final suit in Suit.values) {
        cards.add(Card(face, suit));
      }
    }
  }

  void shuffle() {
    cards.shuffle();
    nextCardIndex = 0;
  }

  Card draw() {
    Card card = cards[nextCardIndex];
    nextCardIndex++;
    return card;
  }
}
