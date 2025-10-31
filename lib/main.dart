import 'dart:async';
import 'package:flutter/material.dart';
import 'package:memory_game_flutter/data/data.dart';
import 'package:memory_game_flutter/models/TileModel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<TileModel> gridViewTiles = [];
  List<TileModel> questionPairs = [];

  @override
  void initState() {
    super.initState();
    reStart();
  }

  void reStart() {
    myPairs = getPairs();
    myPairs.shuffle();

    gridViewTiles = myPairs;

    // show actual tiles for 5 seconds, then flip to questions
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        questionPairs = getQuestionPairs();
        gridViewTiles = questionPairs;
        selected = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 40),
              points != 800
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "$points/800",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const Text(
                    "Points",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w300),
                  ),
                ],
              )
                  : Container(),
              const SizedBox(height: 20),
              points != 800
                  ? GridView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                gridDelegate:
                const SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisSpacing: 0.0, maxCrossAxisExtent: 100.0),
                children: List.generate(gridViewTiles.length, (index) {
                  return Tile(
                    imagePathUrl: gridViewTiles[index].imageAssetPath,
                    tileIndex: index,
                    parent: this,
                  );
                }),
              )
                  : Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        points = 0;
                        reStart();
                      });
                    },
                    child: Container(
                      height: 50,
                      width: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Text(
                        "Replay",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      // TODO: Rate us logic
                    },
                    child: Container(
                      height: 50,
                      width: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Text(
                        "Rate Us",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Tile extends StatefulWidget {
  final String imagePathUrl;
  final int tileIndex;
  final _HomeState parent;

  const Tile({
    required this.imagePathUrl,
    required this.tileIndex,
    required this.parent,
  });

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!selected && widget.tileIndex < myPairs.length) {
          setState(() {
            myPairs[widget.tileIndex].isSelected = true;
          });

          if (selectedTile != "") {
            // check if two selected tiles match
            if (selectedTile ==
                myPairs[widget.tileIndex].imageAssetPath) {
              points += 100;
              TileModel emptyTile =
              TileModel(imageAssetPath: "", isSelected: false);

              selected = true;
              Future.delayed(const Duration(seconds: 2), () {
                myPairs[widget.tileIndex] = emptyTile;
                myPairs[selectedIndex] = emptyTile;
                widget.parent.setState(() {});
                setState(() {
                  selected = false;
                });
                selectedTile = "";
              });
            } else {
              // wrong choice
              selected = true;
              Future.delayed(const Duration(seconds: 2), () {
                widget.parent.setState(() {
                  myPairs[widget.tileIndex].isSelected = false;
                  myPairs[selectedIndex].isSelected = false;
                });
                setState(() {
                  selected = false;
                });
              });
              selectedTile = "";
            }
          } else {
            // store first tile
            selectedTile = myPairs[widget.tileIndex].imageAssetPath;
            selectedIndex = widget.tileIndex;
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        child: myPairs[widget.tileIndex].imageAssetPath != ""
            ? Image.asset(myPairs[widget.tileIndex].isSelected
            ? myPairs[widget.tileIndex].imageAssetPath
            : widget.imagePathUrl)
            : Container(
          color: Colors.white,
          child: Image.asset("assets/correct.png"),
        ),
      ),
    );
  }
}
