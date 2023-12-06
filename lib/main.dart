import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rvp;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return rvp.ProviderScope(
      child: MaterialApp(
        title: 'Lightning Order',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

const List<int> list = <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
final List<int> order = <int>[0, 0, 0, 0];
final List<int> waiting = <int>[0, 0, 0, 0];

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  text: 'Order',
                  icon: Icon(Icons.fastfood),
                ),
                Tab(
                  text: 'Waiting',
                  icon: Icon(Icons.local_grocery_store),
                ),
              ],
            ),
            title: Text('Lightning Order'),
          ),
          body: TabBarView(
            children: [
              Container(
                color: colorScheme.surfaceVariant,
                child: Center(
                  child: OrderPage(),
                ),
              ),
              Container(
                color: colorScheme.surfaceVariant,
                child: Center(
                  child: WaitingPage(),
                ),
              ),
            ],
          ),
        ),
    );
  }
}

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BigCard(menuNum: 0),
                BigCard(menuNum: 1),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BigCard(menuNum: 2),
                BigCard(menuNum: 3),
              ],
            ),
            SizedBox(
              height: 60,
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  _showCustomDialog(context);
                },
                child: Text('Confirm',
                    style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            Spacer(flex: 2),
          ],
        ),
    );
  }
}

class BigCard extends StatefulWidget {
  final int menuNum;
  BigCard({required this.menuNum});

  @override
  State<BigCard> createState() => _BigCardState();
}

class _BigCardState extends State<BigCard> {
  late int _menuNum;

  @override
  void initState() {
    super.initState();
    _menuNum = widget.menuNum;
  }

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: 200,
      height: 250,
      child: Card(
        child: Stack(
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset('assets/images/circle_logo.png',
                  fit: BoxFit.fill),
            ),
            Positioned(
              bottom: 0,
              left: 80,
              child: SizedBox(
                width: 40,
                child: DropdownButtonCount(menuNumber: _menuNum),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class DropdownButtonCount extends StatefulWidget {
  final int menuNumber;
  DropdownButtonCount({required this.menuNumber});

  @override
  State<DropdownButtonCount> createState() => _DropdownButtonCountState();
}

class _DropdownButtonCountState extends State<DropdownButtonCount> {
  int _value = list.first;
  late int _menuNumber;

  @override
  void initState() {
    super.initState();
    _menuNumber = widget.menuNumber;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 5,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      value: _value,
      onChanged: (newValue) {
        setState(() {
          _value = newValue!;
          order[_menuNumber] = _value;
        });
        // This is called when the user selects an item.
      },
      items: list.map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }
}


class WaitingPage extends StatelessWidget {
  const WaitingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClickCounter(),
    );
  }
}

class ClickCounter extends StatefulWidget {
  @override
  State<ClickCounter> createState() => _ClickCounterState();
}

class _ClickCounterState extends State<ClickCounter> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Click Counter'),
      ),
      body: Center(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 5,     //ボックス左右間のスペース
            mainAxisSpacing: 0,      //ボックス上下間のスペース
            crossAxisCount: 2,        //ボックスを横に並べる数
          ),
          itemCount: waiting.length,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              width: 200,
              height: 250,
              child: Card(
                child: Stack(
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.asset('assets/images/circle_logo.png',
                          fit: BoxFit.fill),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 80,
                      child: SizedBox(
                        width: 40,
                        child: Text(
                          waiting[index].toString(),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void _showCustomDialog(BuildContext context) {
  showDialog(
      context: context, builder: (context) => _createCustomDialog(context));
}

Dialog _createCustomDialog(BuildContext context) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: SizedBox(
      width: 300,
      height: 170,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Container(
              width: 300,
              height: 126,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 210, 225, 192),
                border: Border(
                  bottom: BorderSide(
                    width: 0.5,
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                ),
              ),
              child: const Center(
                child: Text("Confirm your order?"),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 210, 225, 192),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            width: 300,
            height: 44,
            child: Row(
              children: [
                MaterialButton( //こっちのときは注文確定しない（値はそのまま）
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  minWidth: 150,
                  onPressed: () {
                    Navigator.of(context).pop();
                    print("object");
                    },
                  child: Center(
                    child: Text("No"),
                  ),
                ),
                MaterialButton( //こっちのときだけ注文確定
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  minWidth: 150,
                  onPressed: () {
                    Navigator.of(context).pop();
                    for (int i = 0; i < order.length; i++) {
                      waiting[i] = order[i];
                    }
                    order.fillRange(0, order.length, 0);
                    print("object");
                  },
                  child: Center(
                    child: Text("Yes"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}



