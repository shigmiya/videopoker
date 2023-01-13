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
    check('JD 2H JC 3C 4S', Ranking.jacksOrBetter);
    check('JD 2H 3C 4S JC', Ranking.jacksOrBetter);
    check('2H 3C JD 4S JC', Ranking.jacksOrBetter);
    check('2H 2D 10H JH QH', Ranking.none);
    check('10H 10D 2H 3H 4H', Ranking.none);

    check('2H 2S 3D 4S 4C', Ranking.twoPair);
    check('2H 2S 4S 4C 3D', Ranking.twoPair);
    check('3D 2H 2S 4S 4C', Ranking.twoPair);

    check('5H 5S 5C 10D QD', Ranking.threeOfAKind);
    check('5H 5C 10D 5S QD', Ranking.threeOfAKind);
    check('5H 5C 10D QD 5S', Ranking.threeOfAKind);
    check('QD 5H 5C 10D 5S', Ranking.threeOfAKind);

    check('2H 3C 4D 5D 6S', Ranking.straight);
    check('6S 2H 3C 4D 5D', Ranking.straight);
    check('6S 5H 4C 3D 2D', Ranking.straight);
    check('2H 3C 4D 5D 10S', Ranking.none);
    check('9H 8C 7D 6D 2S', Ranking.none);
    check('AS KS QD JD 10C', Ranking.straight);
    check('AS 2S 3D 4D 5C', Ranking.straight);
    check('2S 3D 4D 5C AS', Ranking.straight);
    check('2S 3D 4D 8C AS', Ranking.none);
    check('JC QC KS AS 2D', Ranking.none);

    check('3H 4H 10H JH AH', Ranking.flush);
    check('3H 4H 10H JH AS', Ranking.none);

    check('3H 3S 3D KH KS', Ranking.fullHouse);
    check('KH KS 3H 3S 3D', Ranking.fullHouse);
    check('KH 3H 3S KS 3D', Ranking.fullHouse);

    check('5H 5S 5C 5D QD', Ranking.fourHighs);
    check('QD 5H 5S 5C 5D', Ranking.fourHighs);
    check('5H 5S QD 5C 5D', Ranking.fourHighs);
    check('KH KS KD KC 3D', Ranking.fourHighs);
    check('3H 3S 3C 3D QD', Ranking.fourLows);
    check('QD 3H 3S 3C 3D', Ranking.fourLows);
    check('3H 3S QD 3C 3D', Ranking.fourLows);
    check('2H 2S 2D 2C JD', Ranking.fourLows);
    check('AH AS AC AD QD', Ranking.fourAces);
    check('QD AH AS AC AD', Ranking.fourAces);
    check('AH AS QD AC AD', Ranking.fourAces);

    check('2H 3H 4H 5H 6H', Ranking.straightFlush);
    check('6H 2H 3H 4H 5H', Ranking.straightFlush);
    check('6H 5H 4H 3H 2H', Ranking.straightFlush);
    check('AS 2S 3S 4S 5S', Ranking.straightFlush);
    check('2S 3S 4S 5S AS', Ranking.straightFlush);

    check('AS KS QS JS 10S', Ranking.royalFlush);
    check('10S JS QS KS AS', Ranking.royalFlush);
    check('QD KD 10D AD JD', Ranking.royalFlush);
  });
}
