import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Points Game',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: TheMainScreen(),
    );
  }
}

class TheMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myWinningPointsTextController = TextEditingController();
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
              child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo[300], Colors.teal[200], Colors.white],
              begin: AlignmentDirectional.topCenter,
              end: AlignmentDirectional.bottomCenter,
            ),
          ),
          child: Center(
            child: SafeArea(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(
                    top: 30, right: 40, left: 40, bottom: 20),
                children: <Widget>[
                  Text(
                    'The Points Game on Flutter',
                    style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Developed by Adnan Sawas',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 17,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 30),
                    child: Image.asset(
                      'img/dice.png',
                      width: 300,
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 0, right: 30, bottom: 60, left: 30),
                      child: TextField(
                        maxLength: 3,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        controller: myWinningPointsTextController,
                        decoration: InputDecoration(
                            labelText: 'Points to win',
                            hintText: '100',
                            labelStyle: TextStyle(
                              fontSize: 20,
                            ),
                            prefixIcon: Icon(Icons.star)),
                      ),
                    ),
                  ),
                  ButtonTheme(
                    highlightColor: Colors.indigo[400],
                    buttonColor: Colors.teal[400],
                    height: 50,
                    minWidth: 250.0,
                    child: RaisedButton(
                      child: Text(
                        'Play a game',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        var pointsToWin =
                            int.tryParse(myWinningPointsTextController.text);
                        if (pointsToWin == null) {
                          pointsToWin = 100;
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TheGameWidget(
                                      pointsToWin: pointsToWin,
                                    )));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ButtonTheme(
                      highlightColor: Colors.teal[400],
                      buttonColor: Colors.indigo[400],
                      height: 50,
                      minWidth: 250.0,
                      child: RaisedButton(
                        child: Text(
                          'Game Instructions',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GameInstructions()));
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TheGameWidget extends StatelessWidget {
  final int pointsToWin;
  const TheGameWidget({Key key, @required this.pointsToWin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Points Game'),
        backgroundColor: Colors.indigo[400],
      ),
      body: PointsGame(
        pointsToWin: pointsToWin,
      ),
    );
  }
}

class PointsGame extends StatefulWidget {
  const PointsGame({@required this.pointsToWin});

  final int pointsToWin;

  @override
  _PointsGameState createState() => _PointsGameState();
}

class _PointsGameState extends State<PointsGame> {
  var player1 = {'currentRoundScore': 0, 'totalScore': 0, 'turn': 1};
  var player2 = {'currentRoundScore': 0, 'totalScore': 0, 'turn': 2};

  int currentDiceValue = 0;
  int currentTurn = 2;
  bool zero = false;
  int playDice() {
    setState(() {
      Random randomNumber = new Random();
      currentDiceValue = randomNumber.nextInt(7);
      if (currentDiceValue == 0) {
        zero = true;
      } else {
        zero = false;
      }
    });
    return currentDiceValue;
  }

  void resetGame() {
    setState(() {
      player1 = {'currentRoundScore': 0, 'totalScore': 0, 'turn': 1};
      player2 = {'currentRoundScore': 0, 'totalScore': 0, 'turn': 2};
      currentDiceValue = 0;
      currentTurn = 2;
      zero = false;
    });
  }

  void changeTurn() {
    setState(() {
      if (currentTurn == 1) {
        currentTurn = 2;
      } else {
        currentTurn = 1;
      }
    });
  }

  bool isItMyTurn(int myTurnNumber) {
    return currentTurn == myTurnNumber;
  }

  @override
  Widget build(BuildContext context) {
    bool turn;
    if (currentTurn == 1) {
      turn = true;
    } else {
      turn = false;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            zero ? Colors.red[700] : Colors.green[200],
            zero ? Colors.white : Colors.teal[100],
            Colors.white
          ],
          radius: 1.0,
          stops: [0, 0.8, 1],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RotatedBox(
              quarterTurns: 2,
              child: PlayerSection(
                  onPlayDice: playDice,
                  player: player1,
                  onChangeTurn: changeTurn,
                  isItMyTurn: isItMyTurn,
                  resetGame: resetGame,
                  pointsToWin: widget.pointsToWin)),
          RotatedBox(
            quarterTurns: turn ? 2 : 0,
            child: PlayGroundSection(
              diceValue: currentDiceValue,
            ),
          ),
          Container(
              padding: EdgeInsets.only(bottom: 20),
              child: PlayerSection(
                onPlayDice: playDice,
                player: player2,
                onChangeTurn: changeTurn,
                isItMyTurn: isItMyTurn,
                resetGame: resetGame,
                pointsToWin: widget.pointsToWin,
              )),
        ],
      ),
    );
  }
}

class PlayGroundSection extends StatefulWidget {
  PlayGroundSection({this.diceValue});
  final int diceValue;
  @override
  _PlayGroundSectionState createState() => _PlayGroundSectionState();
}

class _PlayGroundSectionState extends State<PlayGroundSection> {
  @override
  Widget build(BuildContext context) {
    int diceValue = widget.diceValue;
    return Container(
      child: Center(
        child: RotatedBox(
          quarterTurns: 0,
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: Colors.black,
              style: BorderStyle.solid,
              width: 2,
            ))),
            child: Text(
              '$diceValue',
              style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      blurRadius: 5.0,
                      offset: Offset(2, 5.0),
                      color: Colors.grey[800],
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

class PlayerSection extends StatefulWidget {
  const PlayerSection({
    @required this.onPlayDice,
    @required this.player,
    @required this.onChangeTurn,
    @required this.isItMyTurn,
    @required this.resetGame,
    @required this.pointsToWin,
  });

  final Function onPlayDice;
  final Map<String, dynamic> player;
  final Function onChangeTurn;
  final Function isItMyTurn;
  final Function resetGame;
  final int pointsToWin;

  @override
  _PlayerSectionState createState() => _PlayerSectionState();
}

class _PlayerSectionState extends State<PlayerSection> {
  @override
  Widget build(BuildContext context) {
    int currentRoundScore = widget.player['currentRoundScore'];
    int totalScore = widget.player['totalScore'];
    bool isItMyTurn = widget.isItMyTurn(widget.player['turn']);

    // Play audio

    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('$currentRoundScore',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ))),
              Text(
                'This round',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 30, left: 30),
                  child: ButtonTheme(
                    minWidth: double.infinity,
                    child: FlatButton(
                      disabledTextColor: Colors.grey[600],
                      textColor: Colors.white,
                      disabledColor: Colors.grey[300],
                      child: Text('Hold'),
                      color: Colors.indigo[400],
                      onPressed: !(isItMyTurn)
                          ? null
                          : () {
                              setState(() {
                                widget.player['totalScore'] +=
                                    currentRoundScore;
                                widget.player['currentRoundScore'] = 0;
                                if (widget.player['totalScore'] >=
                                    widget.pointsToWin) {
                                  Future.delayed(
                                      Duration.zero, () => _showDialog());
                                  return;
                                }
                                widget.onChangeTurn();
                              });
                            },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: ButtonTheme(
                    minWidth: double.infinity,
                    child: FlatButton(
                        disabledTextColor: Colors.grey[600],
                        textColor: Colors.white,
                        disabledColor: Colors.grey[300],
                        child: Text('Play'),
                        color: Colors.teal[400],
                        onPressed: !(isItMyTurn)
                            ? null
                            : () {
                                int currentDiceValue = widget.onPlayDice();
                                setState(() {
                                  if (currentDiceValue == 0) {
                                    widget.player['currentRoundScore'] = 0;
                                    widget.onChangeTurn();
                                  } else {
                                    widget.player['currentRoundScore'] +=
                                        currentDiceValue;
                                    currentRoundScore += currentDiceValue;
                                  }
                                });
                              }),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('$totalScore',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ))),
              Text(
                'Total Score',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CupertinoAlertDialog(
          title: new Text("Congratulations !!"),
          content: new Text("The game has ended :)"),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                widget.resetGame();
              },
            ),
          ],
        );
      },
    );
  }
}

class GameInstructions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Instructions'),
      ),
      body: Container(
        child: Center(
          child: ListView(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    'How to play?',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 25, right: 25),
                child: Text(
                  'The Game is played by 2 players on both sides of the device. '
                      'Every player plays by throwing a dice that contains numbers from 0 to 6.\n\n'
                      'The dice value gets added to the current round score, so the more you play the more points you get.\n'
                      'However, if the dice value happened to be zero (0), you lose the current round points and the turn gets to the other player.\n\n'
                      'To protect yourself from losing the points you collected, click the "Hold" button to add current round scores to total scores and give turn to the other player.\n\n\n'
                      'To win the game, total scores should be greater than or equal to number of points entered in the main screen; Default is 100',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
