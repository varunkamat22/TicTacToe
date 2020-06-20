import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

String player1;
String player2;

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TicTacToe",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: PlayerEntry()
      ),
    );
  }

  static PreferredSizeWidget getAppBar() {
    return AppBar(
      title: Text("TicTacToe", style: TextStyle(fontSize: 20,),),
      backgroundColor: Colors.cyan,
    );
  }

}

class PlayerEntry extends StatefulWidget {
  @override
  _PlayerEntryState createState() => _PlayerEntryState();
}

class _PlayerEntryState extends State<PlayerEntry> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: EnterNameWidget(num: 1),
      ),
    );
  }
}

class EnterNameWidget extends StatelessWidget {

  final int num;
  final textController = TextEditingController();

  EnterNameWidget({this.num});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyApp.getAppBar(),
      body: Padding(
          padding: const EdgeInsets.all(50),
          child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Player ${num}",
                          hintText: "Enter Name",
                          labelStyle: TextStyle(fontSize: 25, color: Colors.cyan),
                          hintStyle: TextStyle(fontSize: 10),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.cyan),
                          ),
                        ),
                        style: TextStyle(fontSize: 25, color: Colors.blueAccent),
                        controller: textController,
                      ),
                      RaisedButton(
                        color: Colors.cyan,
                        child: Text("Go", style: TextStyle(color: Colors.white, fontSize: 20,),),
                        onPressed: (){
                          if (num == 1) {
                            player1 = textController.text;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EnterNameWidget(num: 2,)));
                          } else {
                            player2 = textController.text;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => GameArea()));
                          }
                        },
                      )
                  ],
                ),
      )
    );
  }
}

class GameArea extends StatefulWidget {
  @override
  _GameAreaState createState() => _GameAreaState();
}

class _GameAreaState extends State<GameArea> {

  var gameData = new GameData();

  @override
  void initState() {
    gameData.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyApp.getAppBar(),
      body: Column(
       children: <Widget>[
         Row(
           children: <Widget>[
             Expanded(
               child: Container(
                 color: gameData.currentPlayer == player1 ? Colors.green : Colors.grey,
                 padding: EdgeInsets.all(10),
                 child: Text("${player1}  X", style: TextStyle(fontSize: 20, color: Colors.white),),
               ),
             ),
             Expanded(
               child: Container(
                 color: gameData.currentPlayer == player2 ? Colors.green : Colors.grey,
                 padding: EdgeInsets.all(10),
                 child: Text("${player2}  O", style: TextStyle(fontSize: 20, color: Colors.white),),
               ),
             )
           ],
         ),
         Container(
             padding: EdgeInsets.all(20),
             child:Table(
                 border: TableBorder.all(color: Colors.white),
                 children:[
                   TableRow(
                       children: drawTableCells(0, gameData)
                   ),
                   TableRow(
                       children: drawTableCells(1, gameData)
                   ),
                   TableRow(
                       children: drawTableCells(2, gameData)
                   )
                 ]
             )
         ),
         Container(
           child: Padding(
             padding: EdgeInsets.all(10),
             child: RaisedButton(
               color: Colors.cyan,
               onPressed: (){
                 setState(() {
                    gameData.reset();
                 });
               },
               child: Text("Reset", style:TextStyle(color: Colors.white, fontSize: 20)),
             ),
           )
         )
       ],
      )
    );

  }

  List<TableCell> drawTableCells(int rowNum, GameData gameData) {
    List<TableCell> cells = new List(3);
    for (var i=0; i<3; i++) {
      var cell = TableCell(
          child: Container(
              padding: EdgeInsets.all(10),
              color: Colors.cyan,
              child: FlatButton(
                onPressed: (){
                      doGameMove(gameData, rowNum, i);
                      var win = checkForWinner(gameData);
                      setState(() {
                        if (win != "") {
                          gameData.gameStatus = "complete";
                          gameData.reset();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Alert(msg: win,)));
                        }
                      });
                },
                child: Text("${gameData.grid[rowNum][i]}", style: TextStyle(color: Colors.white, fontSize: 30),),
              )
          )
      );
      cells[i] = cell;
    }
    return cells;
  }

  void doGameMove(GameData gameData, int r, int c) {
    setState(() {
      if (gameData.grid[r][c] == "" && gameData.gameStatus != "complete") {
        if (gameData.currentPlayer == player1) {
          gameData.grid[r][c] = "X";
          gameData.currentPlayer = player2;
        } else {
          gameData.grid[r][c] = "O";
          gameData.currentPlayer = player1;
        }
      }
    });
  }

  String checkForWinner(GameData gameData) {
    var grid = gameData.grid;
    //first check for rows
    for (var i=0; i<3; i++) {
      var data = grid[i][0];
      if (data != "" && grid[i][1] == data && grid[i][2] == data) {
        return data == "X" ? "${player1} wins" : "${player2} wins";
      }
    }

    //check for columns
    for (var i=0; i<3; i++) {
      var data = grid[0][i];
      if (data != "" && grid[1][i] == data && grid[2][i] == data) {
        return data == "X" ? "${player1} wins" : "${player2} wins";
      }
    }

    var data = grid[0][0];
    if (data != "" && grid[1][1] == data && grid[2][2] == data) {
      return data == "X" ? "${player1} wins" : "${player2} wins";
    }

    data = grid[0][2];
    if (data != "" && grid[1][1] == data && grid[2][0] == data) {
      return data == "X" ? "${player1} wins" : "${player2} wins";
    }

    var isAnyCellEmpty = false;
    for (int i=0; i<3; i++) {
      for (int j=0; j<3; j++) {
        if(grid[i][j] == "") {
          isAnyCellEmpty = true;
          break;
        }
      }
    }

    if(!isAnyCellEmpty) {
      return "It's a draw!!";
    }

    return "";
  }

}

class GameData {
  var currentPlayer;
  var gameStatus;
  var grid = new List.generate(3, (_) => new List(3));

  GameData({this.currentPlayer, this.gameStatus});

  void reset() {
    currentPlayer = player1;
    gameStatus = "in_progress";
    for (int i=0; i<3; i++) {
      for (int j=0; j<3; j++) {
        this.grid[i][j] = "";
      }
    }
  }

}

class Alert extends StatelessWidget {

  var msg;

  Alert({this.msg});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Game over!'),
      content: Text(msg, style: TextStyle(fontSize: 20),),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

}






