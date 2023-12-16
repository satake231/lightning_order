import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lightning_order/providers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
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

const List<int> list = <int>[0, 1, 2, 3, 4, 5];

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

class OrderPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              onPressed: () => {
                _showCustomDialog(context),
              },
              child: Text(
                'Confirm',
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

class BigCard extends ConsumerWidget {
  final int menuNum;
  BigCard({required this.menuNum});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 200,
      height: 250,
      child: Card(
        child: Stack(
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset('assets/images/Bot_logo.png',
                  fit: BoxFit.fill),
            ),
            Positioned(
              bottom: 0,
              left: 80,
              child: SizedBox(
                width: 40,
                child: DropdownButtonCount(menuNumber: menuNum),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DropdownButtonCount extends ConsumerWidget {
  final int menuNumber;
  DropdownButtonCount({required this.menuNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderNotifier = ref.watch(orderNotifierProvider.notifier);
    var myModel = ref.watch(myModelProvider);
    final myModelNotifier = ref.watch(myModelProvider.notifier);

    return DropdownButton<int>(
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 5,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      value: myModel[menuNumber],
      onChanged: (newValue) {
        myModelNotifier.updateValue(menuNumber, newValue!);
        orderNotifier.addOrder(menuNumber, newValue);
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

class WaitingPage extends ConsumerWidget {
  const WaitingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    var waitState = ref.watch(waitNotifierProvider);
    final waitNotifier = ref.watch(waitNotifierProvider.notifier);

    if(waitState.isEmpty) {
      return Center(
        child: Text("No orders",
          style: TextStyle(
            fontSize: 35,
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Text(
              'You have ''${waitState.length} orders',
              style: TextStyle(
                fontSize: 25,
              ),
          ),
        ),
        Expanded(
          // Make better use of wide windows with a grid.
          child: GridView(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              childAspectRatio: 400 / 80,
            ),
            children: [
              for (var index = 0; index < waitState.length; index++)
                ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.delete_outline, semanticLabel: 'Delete'),
                    color: theme.colorScheme.primary,
                    onPressed: () {
                      waitNotifier.deleteConfirmedOrder(index);
                    },
                  ),
                  title: Text(
                    generateWaitState(index, waitState),
                    semanticsLabel: index.toString(),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

String generateWaitState(int index, List<List<int>> waitState) {
  var text = '';
  for (var j = 0; j < waitState[index].length; j++) {
    text += '${waitState[index][j]}, ';
  }
  return text;
}

void _showCustomDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return _CustomDialog();
    },
  );
}

class _CustomDialog extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final waitNotifier = ref.watch(waitNotifierProvider.notifier);
    var order = ref.watch(orderNotifierProvider);

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
                  MaterialButton(
                    //こっちのときは注文確定しない（値はそのまま）
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
                  MaterialButton(
                    //こっちのときだけ注文確定
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    minWidth: 150,
                    onPressed: () {
                      Navigator.of(context).pop();
                      waitNotifier.addConfirmedOrder([...order]);
                      order.fillRange(0, order.length, 0);
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
}