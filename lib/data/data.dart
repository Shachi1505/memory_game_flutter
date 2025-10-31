import 'package:memory_game_flutter/models/TileModel.dart';

// Global variables
String selectedTile = "";
int selectedIndex = -1;
bool selected = true;
int points = 0;

// Initialize empty lists safely
List<TileModel> myPairs = [];
List<bool> clicked = [];

List<bool> getClicked() {
  List<TileModel> myPairs = getPairs();
  List<bool> yoClicked = List<bool>.filled(myPairs.length, false);
  return yoClicked;
}

List<TileModel> getPairs() {
  List<TileModel> pairs = [];

  // Helper function to reduce code repetition
  void addPair(String assetPath) {
    TileModel tileModel =
    TileModel(imageAssetPath: assetPath, isSelected: false);
    pairs.add(tileModel);
    pairs.add(TileModel(imageAssetPath: assetPath, isSelected: false));
  }

  // Add image pairs
  addPair("assets/fox.png");
  addPair("assets/hippo.png");
  addPair("assets/horse.png");
  addPair("assets/monkey.png");
  addPair("assets/panda.png");
  addPair("assets/parrot.png");
  addPair("assets/rabbit.png");
  addPair("assets/zoo.png");

  return pairs;
}

List<TileModel> getQuestionPairs() {
  List<TileModel> pairs = [];

  void addQuestionPair() {
    TileModel tileModel =
    TileModel(imageAssetPath: "assets/question.png", isSelected: false);
    pairs.add(tileModel);
    pairs.add(TileModel(imageAssetPath: "assets/question.png", isSelected: false));
  }

  // Add 8 question mark pairs
  for (int i = 0; i < 8; i++) {
    addQuestionPair();
  }

  return pairs;
}
