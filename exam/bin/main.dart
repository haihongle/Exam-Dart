import 'dart:convert';
import 'dart:html';

class Order {
  String item;
  String itemName;
  double price;
  String currency;
  int quantity;

  Order(this.item, this.itemName, this.price, this.currency, this.quantity);

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      json['Item'],
      json['ItemName'],
      (json['Price'] as num).toDouble(),
      json['Currency'],
      json['Quantity'],
    );
  }

  Map<String, dynamic> toJson() => {
        'Item': item,
        'ItemName': itemName,
        'Price': price,
        'Currency': currency,
        'Quantity': quantity,
      };
}

List<Order> orders = [];

final String jsonString = '''
[
  {"Item": "A1000", "ItemName": "Iphone 15", "Price": 1200, "Currency": "USD", "Quantity": 1},
  {"Item": "A1001", "ItemName": "Iphone 16", "Price": 1500, "Currency": "USD", "Quantity": 1}
]
''';

void main() {
  // Parse JSON string
  List<dynamic> jsonData = jsonDecode(jsonString);
  orders = jsonData.map((e) => Order.fromJson(e)).toList();

  // Gắn sự kiện nút
  querySelector('#btnAdd')?.onClick.listen((_) => addOrder());
  querySelector('#btnSearch')?.onClick.listen((_) => searchOrder());

  // Hiển thị danh sách ban đầu
  displayOrders(orders);
}

void displayOrders(List<Order> orderList) {
  TableSectionElement tableBody = querySelector('#orderBody') as TableSectionElement;
  tableBody.children.clear();

  for (var o in orderList) {
    TableRowElement row = TableRowElement();
    row.children.addAll([
      TableCellElement()..text = o.item,
      TableCellElement()..text = o.itemName,
      TableCellElement()..text = o.price.toString(),
      TableCellElement()..text = o.currency,
      TableCellElement()..text = o.quantity.toString(),
    ]);
    tableBody.children.add(row);
  }
}

void addOrder() {
  String item = (querySelector('#item') as InputElement).value!.trim();
  String itemName = (querySelector('#itemName') as InputElement).value!.trim();
  double price = double.tryParse((querySelector('#price') as InputElement).value!) ?? 0;
  String currency = (querySelector('#currency') as InputElement).value!.trim();
  int quantity = int.tryParse((querySelector('#quantity') as InputElement).value!) ?? 1;

  if (item.isEmpty || itemName.isEmpty) {
    window.alert('Please fill all required fields!');
    return;
  }

  Order newOrder = Order(item, itemName, price, currency, quantity);
  orders.add(newOrder);
  displayOrders(orders);
  window.alert('✅ Order added successfully!');
}

void searchOrder() {
  String keyword = (querySelector('#searchBox') as InputElement).value!.trim().toLowerCase();
  if (keyword.isEmpty) {
    displayOrders(orders);
    return;
  }
  var filtered = orders.where((o) => o.itemName.toLowerCase().contains(keyword)).toList();
  displayOrders(filtered);
}
