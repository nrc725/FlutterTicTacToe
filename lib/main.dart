import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';
import 'package:audioplayers/audio_cache.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Tic Tac Toe'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum Choice{ONE, TWO, THREE}

class _MyHomePageState extends State<MyHomePage> {
  var mBoard = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];
  final int BOARD_SIZE = 9;

  final String HUMAN_PLAYER = "X";
  final String COMPUTER_PLAYER = "O";

  String gameMessage = "X's Turn";

  String r1c1 = ' ';
  String r1c2 = ' ';
  String r1c3 = ' ';
  String r2c1 = ' ';
  String r2c2 = ' ';
  String r2c3 = ' ';
  String r3c1 = ' ';
  String r3c2 = ' ';
  String r3c3 = ' ';

  bool button1Pressed = false;
  bool button2Pressed = false;
  bool button3Pressed = false;
  bool button4Pressed = false;
  bool button5Pressed = false;
  bool button6Pressed = false;
  bool button7Pressed = false;
  bool button8Pressed = false;
  bool button9Pressed = false;

  int tie = 0;
  int player = 0;
  int computer = 0;

  String turn = "X";
  int win = 0;

  int move = 0;
  int _gameChoice = 1;

  static AudioCache playerX = new AudioCache();
  static AudioCache playerO = new AudioCache();

  final Random mRand = new Random();


  void checkComputerMove()
  {
    if(_gameChoice == 1)
    {
      getRandomMove();
    }
    if(_gameChoice == 2)
    {
      if(getWinningMove() == true)
      {

      }
      else
      {
        getRandomMove();
      }
    }
    if(_gameChoice == 3)
    {
      if(getWinningMove() == true)
      {

      }
      else if(getBlockingMove() == true)
      {

      }
      else
        getRandomMove();
    }
  }

  bool getWinningMove()
  {
    // First see if there's a move O can make to win
    for (int i = 0; i < BOARD_SIZE; i++) {
      if (mBoard[i] != HUMAN_PLAYER && mBoard[i] != COMPUTER_PLAYER) {
        String curr = mBoard[i];
        mBoard[i] = COMPUTER_PLAYER;
        if (checkForWinner() == 3) {
          int num1 = i + 1;
          showComputerMove(num1);
          print("Computer's winning move is to $num1");
          displayBoard();
          return true;
        } else {
          mBoard[i] = curr;
        }
      }
    }
    return false;
  }

  bool getBlockingMove()
  {
    // See if there's a move O can make to block X from winning
    for (int i = 0; i < BOARD_SIZE; i++) {
      if (mBoard[i] != HUMAN_PLAYER && mBoard[i] != COMPUTER_PLAYER) {
        var curr = mBoard[i]; // Save the current number
        mBoard[i] = HUMAN_PLAYER;
        if (checkForWinner() == 2) {
          mBoard[i] = COMPUTER_PLAYER;
          int num2 = i + 1;
          showComputerMove(num2);
          print("Computer's blocking move is to $num2");
          displayBoard();
          return true;
        } else {
          mBoard[i] = curr;
        }
      }
    }
    return false;
  }

  void getRandomMove()
  {
    // Generate random move
    do {
      move = mRand.nextInt(BOARD_SIZE);
    } while (mBoard[move] == HUMAN_PLAYER || mBoard[move] == COMPUTER_PLAYER);

    int num3 = move + 1;
    showComputerMove(num3);
    print("Computer's random move is to $num3");
    mBoard[move] = COMPUTER_PLAYER;
    displayBoard();
  }



  void displayBoard() {
    print(mBoard[0] + " | " + mBoard[1] + " | " + mBoard[2]);
    print("-----------");
    print(mBoard[3] + " | " + mBoard[4] + " | " + mBoard[5]);
    print("-----------");
    print(mBoard[6] + " | " + mBoard[7] + " | " + mBoard[8]);
  }

  void _resetScores() {
    setState(() {
      tie = 0;
      player = 0;
      computer = 0;
    });
  }

  int checkForWinner() {
    // Check horizontal wins
    for (int i = 0; i <= 6; i += 3) {
      if (mBoard[i] == HUMAN_PLAYER &&
          mBoard[i + 1] == HUMAN_PLAYER &&
          mBoard[i + 2] == HUMAN_PLAYER) {
        win = 2;
        return 2;
      }
      if (mBoard[i] == COMPUTER_PLAYER &&
          mBoard[i + 1] == COMPUTER_PLAYER &&
          mBoard[i + 2] == COMPUTER_PLAYER) {
        win = 3;
        return 3;
      }
    }

    // Check vertical wins
    for (int i = 0; i <= 2; i++) {
      if (mBoard[i] == HUMAN_PLAYER &&
          mBoard[i + 3] == HUMAN_PLAYER &&
          mBoard[i + 6] == HUMAN_PLAYER) {
        win = 2;
        return 2;
      }
      if (mBoard[i] == COMPUTER_PLAYER &&
          mBoard[i + 3] == COMPUTER_PLAYER &&
          mBoard[i + 6] == COMPUTER_PLAYER) {
        win = 3;
        return 3;
      }
    }

    // Check for diagonal wins
    if ((mBoard[0] == HUMAN_PLAYER &&
        mBoard[4] == HUMAN_PLAYER &&
        mBoard[8] == HUMAN_PLAYER) ||
        (mBoard[2] == HUMAN_PLAYER &&
            mBoard[4] == HUMAN_PLAYER &&
            mBoard[6] == HUMAN_PLAYER)) {
      win = 2;
      return 2;
    }
    if ((mBoard[0] == COMPUTER_PLAYER &&
        mBoard[4] == COMPUTER_PLAYER &&
        mBoard[8] == COMPUTER_PLAYER) ||
        (mBoard[2] == COMPUTER_PLAYER &&
            mBoard[4] == COMPUTER_PLAYER &&
            mBoard[6] == COMPUTER_PLAYER)) {
      win = 3;
      return 3;
    }
    // Check for tie
    for (int i = 0; i < BOARD_SIZE; i++) {
      // If we find a number, then no one has won yet
      if (mBoard[i] != HUMAN_PLAYER && mBoard[i] != COMPUTER_PLAYER) {
        win = 0;
        return 0;
      }
    }

    // If we make it through the previous loop, all places are taken, so it's a tie
    win = 1;
    return 1;
  }

  void showStatus() {
    if (win == 1) {
      print("It's a tie.");
      tie++;
      setState(() {
        gameMessage = "It's a tie!";
      });
    } else if (win == 2) {
      print("You win!");
      player++;
      setState(() {
        gameMessage = "You win!";
      });
    } else if (win == 3) {
      print("Computer wins!");
      computer++;
      setState(() {
        gameMessage = "Computer Wins!";
      });
    }
  }

  playLocal_X() {
    playerX.play('sword.mp3');
  }
  playLocal_O() {
    playerO.play('swish.mp3');
  }

  void newGame() {
    setState(() {
      r1c1 = ' ';
      r1c2 = ' ';
      r1c3 = ' ';
      r2c1 = ' ';
      r2c2 = ' ';
      r2c3 = ' ';
      r3c1 = ' ';
      r3c2 = ' ';
      r3c3 = ' ';
    });

    button1Pressed = false;
    button2Pressed = false;
    button3Pressed = false;
    button4Pressed = false;
    button5Pressed = false;
    button6Pressed = false;
    button7Pressed = false;
    button8Pressed = false;
    button9Pressed = false;


    mBoard = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];
    turn = "X";
    win = 0;
    setState(() {
      gameMessage = "X's Turn";
    });
    print("New game has started!");
  }

  void showComputerMove(int move) {
    if (move == 1) box1Tapped();
    if (move == 2) box2Tapped();
    if (move == 3) box3Tapped();
    if (move == 4) box4Tapped();
    if (move == 5) box5Tapped();
    if (move == 6) box6Tapped();
    if (move == 7) box7Tapped();
    if (move == 8) box8Tapped();
    if (move == 9) box9Tapped();
  }

  void box1Tapped() {
    if (turn == HUMAN_PLAYER) {
      playLocal_X();
      setState(() {
        r1c1 = HUMAN_PLAYER;
      });
      print("Player moves to 1");
      displayBoard();
    } else {
      playLocal_O();
      setState(() {
        r1c1 = COMPUTER_PLAYER;
      });
    }
    button1Pressed = true;
  }

  void box2Tapped() {
    if (turn == HUMAN_PLAYER) {
      playLocal_X();
      print("Player moves to 2");
      setState(() {
        r1c2 = HUMAN_PLAYER;
      });
      displayBoard();
    } else {
      playLocal_O();
      setState(() {
        r1c2 = COMPUTER_PLAYER;
      });
    }
    button2Pressed = true;
  }

  void box3Tapped() {
    if (turn == HUMAN_PLAYER) {
      playLocal_X();
      print("Player move to 3");
      setState(() {
        r1c3 = HUMAN_PLAYER;
      });
      displayBoard();
    } else {
      playLocal_O();
      setState(() {
        r1c3 = COMPUTER_PLAYER;
      });
    }
    button3Pressed = true;
  }

  void box4Tapped() {
    if (turn == HUMAN_PLAYER) {
      playLocal_X();
      print("Player moves to 4");
      setState(() {
        r2c1 = HUMAN_PLAYER;
      });
      displayBoard();
    } else {
      playLocal_O();
      setState(() {
        r2c1 = COMPUTER_PLAYER;
      });
    }
    button4Pressed = true;
  }

  void box5Tapped() {
    if (turn == HUMAN_PLAYER) {
      playLocal_X();
      print("Player moves to 5");
      setState(() {
        r2c2 = HUMAN_PLAYER;
      });
      displayBoard();
    } else {
      playLocal_O();
      setState(() {
        r2c2 = COMPUTER_PLAYER;
      });
    }
    button5Pressed = true;
  }

  void box6Tapped() {
    if (turn == HUMAN_PLAYER) {
      print("Player moves to 6");
      setState(() {
        playLocal_X();
        r2c3 = HUMAN_PLAYER;
      });
      displayBoard();
    } else {
      playLocal_O();
      setState(() {
        r2c3 = COMPUTER_PLAYER;
      });
    }
    button6Pressed = true;
  }

  void box7Tapped() {
    if (turn == HUMAN_PLAYER) {
      playLocal_X();
      print("Player moves to 7");
      setState(() {
        r3c1 = HUMAN_PLAYER;
      });
      displayBoard();
    } else {
      playLocal_O();
      setState(() {
        r3c1 = COMPUTER_PLAYER;
      });
    }
    button7Pressed = true;
  }

  void box8Tapped() {
    if (turn == HUMAN_PLAYER) {
      print("Player moves to 8");
      playLocal_X();
      setState(() {
        r3c2 = HUMAN_PLAYER;
      });
      displayBoard();
    } else {
      playLocal_O();
      setState(() {
        r3c2 = COMPUTER_PLAYER;
      });
    }
    button8Pressed = true;
  }

  void box9Tapped() {
    if (turn == HUMAN_PLAYER) {
      print("Player moves to 9");
      playLocal_X();
      setState(() {
        r3c3 = HUMAN_PLAYER;
      });
      displayBoard();
    }
    else {
      playLocal_O();
      setState(() {
        r3c3 = COMPUTER_PLAYER;
      });
    }
    button9Pressed = true;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          leading: Icon(Icons.apps),
          title: Text("Tic Tac Toe", style: TextStyle(fontSize: 15.0)),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.new_releases),
              onPressed: () {
                newGame();
              },
            ),
            new IconButton(
              icon: new Icon(Icons.refresh),
              onPressed: () {
                _resetScores();
              },
            ),
            new IconButton(
              icon: new Icon(Icons.power_settings_new),
              onPressed: () => exit(0),
            ),
            // overflow menu
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    child: IconButton(
                      icon: Icon(Icons.info),
                      onPressed: () {_aboutDialog(context, "This is a simple tic-tac-toe game for Android and iOS. The buttons represent the game board and a text "
                          "widget displays the game status. Moves are represented by an X for the human player and an O for the "
                          "computer.");},
                    ),
                  ),
                  PopupMenuItem(
                    child: IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {_showSimpleDialog(context, "Select Game Difficulty");},
                    ),
                  ),
                ];
              },
            )
          ],
        ),
        body: OrientationBuilder(builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildVerticalLayout()
              : _buildHorizontalLayout();
        }));
  }

  _buildVerticalLayout()
  {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Container(margin: new EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 10.0)),

              Row(children: <Widget>[
                new Container(
                  margin: new EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 25.0),
                  child: new RaisedButton(
                    padding: const EdgeInsets.all(25.0),
                    child: new Text(
                      '$r1c1',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
                    ),
                    onPressed: () {
                      if(button1Pressed == false) {
                        if (win == 0) {
                          if (turn == HUMAN_PLAYER) {
                            mBoard[0] = HUMAN_PLAYER;
                            box1Tapped();
                            checkForWinner();
                            turn = COMPUTER_PLAYER;
                          }
                          if (win == 0) {
                            checkComputerMove();
                            checkForWinner();
                            turn = HUMAN_PLAYER;
                          }
                          showStatus();
                        }
                      }
                    },
                  ),
                ),
                // 1st Button in 1st Row

                //2nd button in 1st Row
                new Container(
                  margin: new EdgeInsets.fromLTRB(15.0, 0.0, 5.0, 25.0),
                  child: new RaisedButton(
                    padding: const EdgeInsets.all(25.0),
                    child: new Text(
                      '$r1c2',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
                    ),
                    onPressed: () {
                      if(button2Pressed == false) {
                        if (win == 0) {
                          if (turn == HUMAN_PLAYER) {
                            mBoard[1] = HUMAN_PLAYER;
                            box2Tapped();
                            checkForWinner();
                            turn = COMPUTER_PLAYER;
                          }
                          if (win == 0) {
                            checkComputerMove();
                            checkForWinner();
                            turn = HUMAN_PLAYER;
                          }
                          showStatus();
                        }
                      }
                    },
                  ),
                ),
                // 1st Button in 1st Row

                //3rd button in 1st Row
                new Container(
                  margin: new EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 25.0),
                  child: new RaisedButton(
                    padding: const EdgeInsets.all(25.0),
                    child: new Text(
                      '$r1c3',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
                    ),
                    onPressed: () {
                      if(button3Pressed == false) {
                        if (win == 0) {
                          if (turn == HUMAN_PLAYER) {
                            mBoard[2] = HUMAN_PLAYER;
                            box3Tapped();
                            checkForWinner();
                            turn = COMPUTER_PLAYER;
                          }
                          if (win == 0) {
                            checkComputerMove();
                            checkForWinner();
                            turn = HUMAN_PLAYER;
                          }
                          showStatus();
                        }
                      }
                    },
                  ),
                ),
              ]), // end 1st Row

              Row(children: <Widget>[
                new Container(
                  margin: new EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 25.0),
                  child: new RaisedButton(
                    padding: const EdgeInsets.all(25.0),
                    child: new Text(
                      '$r2c1',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
                    ),
                    onPressed: () {
                      if (win == 0) {
                        if (button4Pressed == false) {
                          if (turn == HUMAN_PLAYER) {
                            box4Tapped();
                            mBoard[3] = HUMAN_PLAYER;
                            checkForWinner();
                            turn = COMPUTER_PLAYER;
                          }
                          if (win == 0) {
                            checkComputerMove();
                            checkForWinner();
                            turn = HUMAN_PLAYER;
                          }
                          showStatus();
                        }
                      }
                    },
                  ),
                ),
                //4th Button in 2nd Row

                //2nd button in 1st Row
                new Container(
                  margin: new EdgeInsets.fromLTRB(15.0, 0.0, 5.0, 25.0),
                  child: new RaisedButton(
                    padding: const EdgeInsets.all(25.0),
                    child: new Text(
                      '$r2c2',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
                    ),
                    onPressed: () {
                      if(button5Pressed == false) {
                        if (win == 0) {
                          if (turn == HUMAN_PLAYER) {
                            mBoard[4] = HUMAN_PLAYER;
                            box5Tapped();
                            checkForWinner();
                            turn = COMPUTER_PLAYER;
                          }
                          if (win == 0) {
                            checkComputerMove();
                            checkForWinner();
                            turn = HUMAN_PLAYER;
                          }
                          showStatus();
                        }
                      }
                    },
                  ),
                ),
                // 5th Button in 2nd Row

                //6th button in 1st Row
                new Container(
                  margin: new EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 25.0),
                  child: new RaisedButton(
                    padding: const EdgeInsets.all(25.0),
                    child: new Text(
                      '$r2c3',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
                    ),
                    onPressed: () {
                      if(button6Pressed == false) {
                        if (win == 0) {
                          if (turn == HUMAN_PLAYER) {
                            mBoard[5] = HUMAN_PLAYER;
                            box6Tapped();
                            checkForWinner();
                            turn = COMPUTER_PLAYER;
                          }
                          if (win == 0) {
                            checkComputerMove();
                            checkForWinner();
                            turn = HUMAN_PLAYER;
                          }
                          showStatus();
                        }
                      }
                    },
                  ),
                ),
              ]), // end 2nd Row

              Row(children: <Widget>[
                new Container(
                  margin: new EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 25.0),
                  child: new RaisedButton(
                    padding: const EdgeInsets.all(25.0),
                    child: new Text(
                      '$r3c1',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
                    ),
                    onPressed: () {
                      if(button7Pressed == false) {
                        if (win == 0) {
                          if (turn == HUMAN_PLAYER) {
                            mBoard[6] = HUMAN_PLAYER;
                            box7Tapped();
                            checkForWinner();
                            turn = COMPUTER_PLAYER;
                          }
                          if (win == 0) {
                            checkComputerMove();
                            checkForWinner();
                            turn = HUMAN_PLAYER;
                          }
                          showStatus();
                        }
                      }
                    },
                  ),
                ),
                // 7th Button in 3rd Row

                //8th button in 3rd Row
                new Container(
                  margin: new EdgeInsets.fromLTRB(15.0, 0.0, 5.0, 25.0),
                  child: new RaisedButton(
                    padding: const EdgeInsets.all(25.0),
                    child: new Text(
                      '$r3c2',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
                    ),
                    onPressed: () {
                      if(button8Pressed == false) {
                        if (win == 0) {
                          if (turn == HUMAN_PLAYER) {
                            mBoard[7] = HUMAN_PLAYER;
                            box8Tapped();
                            checkForWinner();
                            turn = COMPUTER_PLAYER;
                          }
                          if (win == 0) {
                            checkComputerMove();
                            checkForWinner();
                            turn = HUMAN_PLAYER;
                          }
                          showStatus();
                        }
                      }
                    },
                  ),
                ),

                //9th button in 3rd Row
                new Container(
                  margin: new EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 25.0),
                  child: new RaisedButton(
                    padding: const EdgeInsets.all(25.0),
                    child: new Text(
                      '$r3c3',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
                    ),
                    onPressed: () {
                      if(button9Pressed == false) {
                        if (win == 0) {
                          if (turn == HUMAN_PLAYER) {
                            mBoard[8] = HUMAN_PLAYER;
                            box9Tapped();
                            checkForWinner();
                            turn = COMPUTER_PLAYER;
                          }
                          if (win == 0) {
                            checkComputerMove();
                            checkForWinner();
                            turn = HUMAN_PLAYER;
                          }
                          showStatus();
                        }
                      }
                    },
                  ),
                ),
              ]), // end 3rd Row

              Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                new Container(
                  margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                  child: new Text(
                    gameMessage,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
                  ),
                )
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                new Container(
                  margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                  child: new Text(
                    'Tie: $tie',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20.0),
                  ),
                )
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                new Container(
                  margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                  child: new Text(
                    'Player: $player',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20.0),
                  ),
                )
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                new Container(
                  margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                  child: new Text(
                    'Computer: $computer',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20.0),
                  ),
                )
              ]),

            ]));
  }

  _buildHorizontalLayout() {
    return Center(

      child:
      Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        new Container(margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0)),
        Column(children: <Widget>[
          new Container(
            margin: new EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 20.0),
            child: new RaisedButton(
              padding: const EdgeInsets.all(24.0),
              child: new Text(
                '$r1c1',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              onPressed: () {
                if (win == 0) {
                  if (turn == HUMAN_PLAYER) {
                    mBoard[0] = HUMAN_PLAYER;
                    box1Tapped();
                    checkForWinner();
                    turn = COMPUTER_PLAYER;
                  }
                  if (win == 0) {
                    checkComputerMove();
                    checkForWinner();
                    turn = HUMAN_PLAYER;
                  }
                  showStatus();
                }
              },
            ),
          ),
          // 1st Button in 1st Row

          //2nd button in 1st Row
          new Container(
            margin: new EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 20.0),
            child: new RaisedButton(
              padding: const EdgeInsets.all(24.0),
              child: new Text(
                '$r1c2',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              onPressed: () {
                if (win == 0) {
                  if (turn == HUMAN_PLAYER) {
                    mBoard[1] = HUMAN_PLAYER;
                    box2Tapped();
                    checkForWinner();
                    turn = COMPUTER_PLAYER;
                  }
                  if (win == 0) {
                    checkComputerMove();
                    checkForWinner();
                    turn = HUMAN_PLAYER;
                  }
                  showStatus();
                }
              },
            ),
          ),
          // 1st Button in 1st Row

          //3rd button in 1st Row
          new Container(
            margin: new EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 20.0),
            child: new RaisedButton(
              padding: const EdgeInsets.all(24.0),
              child: new Text(
                '$r1c3',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              onPressed: () {
                if (win == 0) {
                  if (turn == HUMAN_PLAYER) {
                    mBoard[2] = HUMAN_PLAYER;
                    box3Tapped();
                    checkForWinner();
                    turn = COMPUTER_PLAYER;
                  }
                  if (win == 0) {
                    checkComputerMove();
                    checkForWinner();
                    turn = HUMAN_PLAYER;
                  }
                  showStatus();
                }
              },
            ),
          ),
        ]),
        Column(children: <Widget>[
          new Container(
            margin: new EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 20.0),
            child: new RaisedButton(
              padding: const EdgeInsets.all(24.0),
              child: new Text(
                '$r2c1',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              onPressed: () {
                if (win == 0) {
                  if (turn == HUMAN_PLAYER) {
                    box4Tapped();
                    mBoard[3] = HUMAN_PLAYER;
                    checkForWinner();
                    turn = COMPUTER_PLAYER;
                  }
                  if (win == 0) {
                    checkComputerMove();
                    checkForWinner();
                    turn = HUMAN_PLAYER;
                  }
                  showStatus();
                }
              },
            ),
          ),
          //4th Button in 2nd Row

          //2nd button in 1st Row
          new Container(
            margin: new EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 20.0),
            child: new RaisedButton(
              padding: const EdgeInsets.all(24.0),
              child: new Text(
                '$r2c2',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              onPressed: () {
                if (win == 0) {
                  if (turn == HUMAN_PLAYER) {
                    mBoard[4] = HUMAN_PLAYER;
                    box5Tapped();
                    checkForWinner();
                    turn = COMPUTER_PLAYER;
                  }
                  if (win == 0) {
                    checkComputerMove();
                    checkForWinner();
                    turn = HUMAN_PLAYER;
                  }
                  showStatus();
                }
              },
            ),
          ),
          // 5th Button in 2nd Row

          //6th button in 1st Row
          new Container(
            margin: new EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 20.0),
            child: new RaisedButton(
              padding: const EdgeInsets.all(24.0),
              child: new Text(
                '$r2c3',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              onPressed: () {
                if (win == 0) {
                  if (turn == HUMAN_PLAYER) {
                    mBoard[5] = HUMAN_PLAYER;
                    box6Tapped();
                    checkForWinner();
                    turn = COMPUTER_PLAYER;
                  }
                  if (win == 0) {
                    checkComputerMove();
                    checkForWinner();
                    turn = HUMAN_PLAYER;
                  }
                  showStatus();
                }
              },
            ),
          ),
        ]),
        Column(children: <Widget>[
          new Container(
            margin: new EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 20.0),
            child: new RaisedButton(
              padding: const EdgeInsets.all(24.0),
              child: new Text(
                '$r3c1',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              onPressed: () {
                if (win == 0) {
                  if (turn == HUMAN_PLAYER) {
                    mBoard[6] = HUMAN_PLAYER;
                    box7Tapped();
                    checkForWinner();
                    turn = COMPUTER_PLAYER;
                  }
                  if (win == 0) {
                    checkComputerMove();
                    checkForWinner();
                    turn = HUMAN_PLAYER;
                  }
                  showStatus();
                }
              },
            ),
          ),
          // 7th Button in 3rd Row

          //8th button in 3rd Row
          new Container(
            margin: new EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 20.0),
            child: new RaisedButton(
              padding: const EdgeInsets.all(24.0),
              child: new Text(
                '$r3c2',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              onPressed: () {
                if (win == 0) {
                  if (turn == HUMAN_PLAYER) {
                    mBoard[7] = HUMAN_PLAYER;
                    box8Tapped();
                    checkForWinner();
                    turn = COMPUTER_PLAYER;
                  }
                  if (win == 0) {
                    checkComputerMove();
                    checkForWinner();
                    turn = HUMAN_PLAYER;
                  }
                  showStatus();
                }
              },
            ),
          ),

          //9th button in 3rd Row
          new Container(
            margin: new EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 20.0),
            child: new RaisedButton(
              padding: const EdgeInsets.all(24.0),
              child: new Text(
                '$r3c3',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19.0),
              ),
              onPressed: () {
                if (win == 0) {
                  if (turn == HUMAN_PLAYER) {
                    mBoard[8] = HUMAN_PLAYER;
                    box9Tapped();
                    checkForWinner();
                    turn = COMPUTER_PLAYER;
                  }
                  if (win == 0) {
                    checkComputerMove();
                    checkForWinner();
                    turn = HUMAN_PLAYER;
                  }
                  showStatus();
                }
              },
            ),
          )
        ]),
        Column( children: <Widget>[
          new Container(
            margin: EdgeInsets.fromLTRB(60.0, 10.0, 0.0, 0.0),
            child: new Text(
              gameMessage,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
            ),
          ),
          new Container(
            margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: new Text(
              '         Tie: $tie',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
            ),
          ),
          new Container(
            margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: new Text(
              '        Computer: $computer',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
            ),
          ),
          new Container(
            margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: new Text(
              '        Player: $player',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
            ),
          )
        ]),
      ]),
    );
  }
  Future _aboutDialog(BuildContext context, String message) async {
    return showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text(message),
          actions: <Widget>[
            new FlatButton(
                onPressed: () => Navigator.pop(context), child: new Text('Ok'))
          ],
        )
    );
  }

  Future _showSimpleDialog(BuildContext context, String message) async {
    switch (await showDialog(
        context: context,
        /*it shows a popup with few options which you can select, for option we
 created enums which we can use with switch statement, in this first switch
 will wait for the user to select the option which it can use with switch cases*/
        child: new SimpleDialog(
          title: new Text('Choose Computer Difficulty'),
          children: <Widget>[
            new SimpleDialogOption(
              child: new Text('Easy'),
              onPressed: () {
                Navigator.pop(context, Choice.ONE);
                Scaffold.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 2),
                  content: Text('Difficulty Set To Easy'),
                  action:SnackBarAction(label: 'Ok', onPressed: (){}),));
              }, ),
            new SimpleDialogOption(
              child: new Text('Medium'),
              onPressed: () {
                Navigator.pop(context, Choice.TWO);
                Scaffold.of(context).showSnackBar(SnackBar(duration: const Duration(seconds: 2),
                  content: Text('Difficulty Set To Medium'),
                  action:SnackBarAction(label: 'Ok', onPressed: (){}),));
              }, ),
            new SimpleDialogOption(
              child: new Text('Hard'),
              onPressed: () {
                Navigator.pop(context, Choice.THREE);
                Scaffold.of(context).showSnackBar(SnackBar(duration: const Duration(seconds: 2),
                  content: Text('Difficulty Set To Hard'),
                  action:SnackBarAction(label: 'Ok', onPressed: (){}),));
              }, ), ],))) {
      case Choice.ONE:
        _gameChoice = 1;
        break;
      case Choice.TWO:
        _gameChoice = 2;
        break;
      case Choice.THREE:
        _gameChoice = 3;
        break;}
    print('The selection was Choice = ' + '$_gameChoice');
  }
}


