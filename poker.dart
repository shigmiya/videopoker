import 'cards.dart';

enum Ranking {
  royalFlush(250),
  straightFlush(50),
  fourAces(80),
  fourLows(40),
  fourHighs(25),
  fullHouse(7),
  flush(5),
  straight(4),
  threeOfAKind(3),
  twoPair(2),
  jacksOrBetter(1),
  none(0);

  final int score;
  const Ranking(this.score);
}

Ranking getHandRanking(Hand hand) {
  final values = hand.cards.map((e) => e.value).toList();
  final faces = hand.cards.map((e) => e.face).toList();
  final suits = hand.cards.map((e) => e.suit).toList();
  values.sort((a, b) => a.compareTo(b));
  faces.sort((a, b) => a.value.compareTo(b.value));
  suits.sort((a, b) => a.value.compareTo(b.value));

  final rankings = <Ranking>[];
  rankings.add(Ranking.none);

  // Helper objects.
  final faceCounts = <Face, int>{};
  for (final face in faces) {
    if (!faceCounts.containsKey(face)) {
      faceCounts[face] = 0;
    }
    faceCounts[face] = faceCounts[face]! + 1;
  }

  final suitCounts = <Suit, int>{};
  for (final suit in suits) {
    if (!suitCounts.containsKey(suit)) {
      suitCounts[suit] = 0;
    }
    suitCounts[suit] = suitCounts[suit]! + 1;
  }

  // Jacks or better.
  if (faceCounts.entries
      .where((element) => element.key.value >= 9)
      .any((element) => element.value == 2)) {
    rankings.add(Ranking.jacksOrBetter);
  }

  // Two pair.
  if (faceCounts.values.where((count) => count == 2).length == 2) {
    rankings.add(Ranking.twoPair);
  }

  // Three of a kind.
  if (faceCounts.values.any((count) => count == 3)) {
    rankings.add(Ranking.threeOfAKind);
  }

  // Straight.
  if (faces.last.value - faces.first.value == 4 ||
      (faces[3].value - faces[0].value == 3 && faces[4] == Face.ACE)) {
    rankings.add(Ranking.straight);
  }

  // Flush.
  if (suitCounts.values.any((count) => count == 5)) {
    rankings.add(Ranking.flush);
  }

  // Full house.
  if (faceCounts.values.any((count) => count == 3) &&
      faceCounts.values.any((count) => count == 2)) {
    rankings.add(Ranking.fullHouse);
  }

  // Four highs.
  if (faceCounts.entries
      .where((element) => element.key.value >= 3 && element.key.value <= 11)
      .any((element) => element.value == 4)) {
    rankings.add(Ranking.fourHighs);
  }

  // Four lows.
  if (faceCounts.entries
      .where((element) => element.key.value < 3)
      .any((element) => element.value == 4)) {
    rankings.add(Ranking.fourLows);
  }

  // Four aces.
  if (faceCounts.entries
      .where((element) => element.key.value == 12)
      .any((element) => element.value == 4)) {
    rankings.add(Ranking.fourAces);
  }

  // Straight flush.
  if ((faces.last.value - faces.first.value == 4 ||
          (faces[3].value - faces[0].value == 3 && faces[4] == Face.ACE)) &&
      suitCounts.values.any((count) => count == 5)) {
    rankings.add(Ranking.straightFlush);
  }

  // Royal flush.
  if (faces.last.value - faces.first.value == 4 &&
      faces.last.value == 12 &&
      suitCounts.values.any((count) => count == 5)) {
    rankings.add(Ranking.royalFlush);
  }

  rankings.sort((a, b) => a.score.compareTo(b.score));
  return rankings.last;
}
