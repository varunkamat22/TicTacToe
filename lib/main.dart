import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

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
  final playerInfo = PlayerInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getEnterNameWidget(1, new TextEditingController(), playerInfo, context),
    );
  }

}

Widget getEnterNameWidget(int num, TextEditingController textEditingController, PlayerInfo playerInfo, BuildContext context){

    return Scaffold(
      appBar: MyApp.getAppBar(),
      body: Padding(
          padding: const EdgeInsets.all(50),
          child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                      Text (
                        "Player $num",
                        style: TextStyle(color: Colors.cyan, fontSize: 20),
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Name",
                          hintStyle: TextStyle(fontSize: 15, color: Colors.cyan),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.cyan),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.cyan),
                          ),
                        ),
                        style: TextStyle(fontSize: 25, color: Colors.cyan),
                        controller: textEditingController,
                      ),
                      SizedBox(height: 10,),
                      RaisedButton(
                        color: Colors.cyan,
                        child: Text("Go", style: TextStyle(color: Colors.white, fontSize: 20,),),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        onPressed: (){
                          if (num == 1) {
                            playerInfo.player1 = textEditingController.text.isNotEmpty ? textEditingController.text: playerInfo.player1;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => getEnterNameWidget(2,new TextEditingController(),playerInfo,context)));
                          } else {
                            playerInfo.player2 = textEditingController.text.isNotEmpty ? textEditingController.text: playerInfo.player2;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => GameArea(playerInfo: playerInfo,)));
                          }
                        },
                      )
                  ],
                ),
      )
    );
}

class GameArea extends StatefulWidget {
  final PlayerInfo playerInfo;

  GameArea({this.playerInfo});

  @override
  _GameAreaState createState() => _GameAreaState(playerInfo: playerInfo);
}

class _GameAreaState extends State<GameArea> {

  final GameData gameData = new GameData();
  final PlayerInfo playerInfo;

  _GameAreaState({this.playerInfo});

  @override
  void initState() {
    super.initState();
    gameData.reset(playerInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: MyApp.getAppBar(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(height: 20,),
              Text(
                  "${gameData.currentPlayer}'s turn",
                  style : TextStyle(fontSize: 20, color: Colors.white)
              ),
              SizedBox(height: 40,),
              Table(
                      border: TableBorder(horizontalInside: BorderSide(width: 2, color: Colors.white, style: BorderStyle.solid),
                          verticalInside: BorderSide(width: 2, color: Colors.white, style: BorderStyle.solid)),
                      columnWidths: Map.from({
                        0: FixedColumnWidth(80),
                        1: FixedColumnWidth(80),
                        2: FixedColumnWidth(80)
                      }),

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
              ),
              SizedBox(height: 40,),
              Container(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: RaisedButton(
                      color: Colors.cyan,
                      onPressed: (){
                        setState(() {
                          gameData.reset(playerInfo);
                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.white)
                      ),
                      child: Text("Reset", style:TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  )
              )
            ],
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
              padding: EdgeInsets.all(2),
              height: 60,
              child: FlatButton(
                onPressed: (){
                      doGameMove(gameData, rowNum, i, playerInfo);
                      var win = checkForWinner(gameData, playerInfo);
                      setState(() {
                        if (win != "") {
                          gameData.gameStatus = "complete";
                          gameData.reset(playerInfo);
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

  void doGameMove(GameData gameData, int r, int c, PlayerInfo playerInfo) {
    setState(() {
      if (gameData.grid[r][c] == "" && gameData.gameStatus != "complete") {
        if (gameData.currentPlayer == playerInfo.player1) {
          gameData.grid[r][c] = "X";
          gameData.currentPlayer = playerInfo.player2;
        } else {
          gameData.grid[r][c] = "O";
          gameData.currentPlayer = playerInfo.player1;
        }
      }
    });
  }

  String checkForWinner(GameData gameData, PlayerInfo playerInfo) {
    var grid = gameData.grid;
    //first check for rows
    for (var i=0; i<3; i++) {
      var data = grid[i][0];
      if (data != "" && grid[i][1] == data && grid[i][2] == data) {
        return data == "X" ? "${playerInfo.player1} won" : "${playerInfo.player2} won";
      }
    }

    //check for columns
    for (var i=0; i<3; i++) {
      var data = grid[0][i];
      if (data != "" && grid[1][i] == data && grid[2][i] == data) {
        return data == "X" ? "${playerInfo.player1} won" : "${playerInfo.player2} won";
      }
    }

    var data = grid[0][0];
    if (data != "" && grid[1][1] == data && grid[2][2] == data) {
      return data == "X" ? "${playerInfo.player1} won" : "${playerInfo.player2} won";
    }

    data = grid[0][2];
    if (data != "" && grid[1][1] == data && grid[2][0] == data) {
      return data == "X" ? "${playerInfo.player1} won" : "${playerInfo.player2} won";
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

  void reset(PlayerInfo playerInfo) {
    currentPlayer = playerInfo.player1;
    gameStatus = "in_progress";
    for (int i=0; i<3; i++) {
      for (int j=0; j<3; j++) {
        this.grid[i][j] = "";
      }
    }
  }

}

class PlayerInfo {
  var player1 = "Player1";
  var player2 = "Player2";
}

class Alert extends StatelessWidget {

  final msg;

  Alert({this.msg});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Game over!', style: TextStyle(color: Colors.cyan),),
      content: Text(msg, style: TextStyle(fontSize: 20),),
      actions: <Widget>[
        FlatButton(
          child: Text('OK', style: TextStyle(fontSize: 20, color: Colors.cyan),),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

}






