import 'package:flutter/foundation.dart';

class PartyProvider with ChangeNotifier {
  final List<Party> _userParties = [];

  List<Party> get userParties => _userParties;

  void addParty(Party party) {
    _userParties.add(party);
    notifyListeners();
  }

  void removeParty(Party party) {
    _userParties.remove(party);
    notifyListeners();
  }
}

class Party {
  final String id;
  final String name;
  // Add other party-related fields

  Party({
    required this.id,
    required this.name,
  });
}