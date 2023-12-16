import 'package:flutter_riverpod/flutter_riverpod.dart';

// final counterProvider = Provider((ref) => 0);

const int menuLength = 4;

final waitNotifierProvider = StateNotifierProvider<WaitNotifier, List<List<int>>>(
      (ref) => WaitNotifier(),
);

final orderNotifierProvider = StateNotifierProvider<OrderNotifier, List<int>>(
      (ref) => OrderNotifier(),
);

final myModelProvider = StateNotifierProvider<MyModel, List<int>>(
      (ref) => MyModel(),
);
// 注文のフロー
// OrderPageで注文を行う
// 注文は"order"で一時的に保存される
// "confirm"の"onpressed"で"order"をnotifier内のstateに追加
// "onpressed"により"order"は初期化
//----完了----


// orderもProviderで管理する
// OrderProviderを新たに設置する
// OrderProviderはOrderPageで使用する
// orderはconfirmのYesを押下したとき、waitingはゴミ箱を押下したときに更新するようにする

class WaitNotifier extends StateNotifier<List<List<int>>> {
  WaitNotifier() : super([]);

  void addConfirmedOrder(List<int> confirmedOrder) {
    int flag = 0;
    for (int i = 0; i < confirmedOrder.length; i++) {
      if (confirmedOrder[i] != 0) {
        flag = 1;
        break;
      }
    }
    if (flag == 0) {
      print(state);
    }else{
      state.add(confirmedOrder);
      print(state);
    }
  }

  void deleteConfirmedOrder(int index) {
    state.removeAt(index);
    print(state);
  }
}

class OrderNotifier extends StateNotifier<List<int>> {
  OrderNotifier() : super(List.filled(menuLength, 0));

  void initializeOrder() {
    state.fillRange(0, state.length, 0);
    print(state);
  }

  void addOrder(int menuNum, int value) {
    state[menuNum] = value;
    print(state);
  }
}

class MyModel extends StateNotifier<List<int>> {
  MyModel() : super(List.filled(menuLength, 0));

  void updateValue(int menuNum, int selectedValue) {
    state[menuNum] = selectedValue;
  }
}