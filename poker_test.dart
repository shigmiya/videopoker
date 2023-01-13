import 'package:test/test.dart';
import 'cards.dart';
import 'poker.dart';

void main() {
  Card parseCard(String str) {
    String face;
    String suit;
    if (str.length == 2) {
      face = str[0];
      suit = str[1];
    } else if (str.length == 3) {
      face = str.substring(0, 2);
      suit = str[2];
    } else {
      throw 'bad card $str';
    }

    Face faceValue = Face.values.where((v) => v.character == face).single;
    Suit suitValue = Suit.values.where((v) => v.character == suit).single;
    return Card(faceValue, suitValue);
  }

  Hand parseHand(String str) {
    List<String> parts = str.split(' ');
    assert(parts.length == 5);
    List<Card> cards = parts.map(parseCard).toList();
    return Hand(cards);
  }

  void check(String handStr, Ranking expectedRanking) {
    Hand hand = parseHand(handStr);
    Ranking ranking = getHandRanking(hand);
    expect(ranking, equals(expectedRanking));
  }

  test('Check rankings', () {
    check('2H 2D 10H JH QH', Ranking.none);

    check('JD JC 2H 3C 4S', Ranking.jacksOrBetter);
  });
}
