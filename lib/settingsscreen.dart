import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final List<String> items; // String değerler listesi
  final List<double> chances;
  final Function(List<String> items, List<double> chances) onUpdate;

  SettingsScreen(this.items, this.chances, this.onUpdate);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController valueController = TextEditingController();
  TextEditingController chanceController = TextEditingController();
  int? selectedItemIndex; // Seçili öğenin dizinini saklamak için

  @override
  void dispose() {
    valueController.dispose();
    chanceController.dispose();
    super.dispose();
  }

  void _showAddItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: valueController,
                decoration: InputDecoration(labelText: 'Value'),
                keyboardType: TextInputType.text, // String değer girişi için text olmalı
              ),
              TextFormField(
                controller: chanceController,
                decoration: InputDecoration(labelText: 'Chance'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (valueController.text.isNotEmpty && chanceController.text.isNotEmpty) {
                  widget.items.add(valueController.text); // String değer ekleniyor
                  widget.chances.add(double.parse(chanceController.text));
                  valueController.clear();
                  chanceController.clear();
                  Navigator.pop(context);
                  setState(() {}); // Eklenen öğeyi liste güncellensin diye setState kullanıyoruz
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditItemDialog(BuildContext context, int index) {
    setState(() {
      selectedItemIndex = index;
      valueController.text = widget.items[index];
      chanceController.text = widget.chances[index].toString();
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: valueController,
                decoration: InputDecoration(labelText: 'Value'),
                keyboardType: TextInputType.text, // String değer girişi için text olmalı
              ),
              TextFormField(
                controller: chanceController,
                decoration: InputDecoration(labelText: 'Chance'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (valueController.text.isNotEmpty && chanceController.text.isNotEmpty) {
                  widget.items[index] = valueController.text; // String değer güncelleniyor
                  widget.chances[index] = double.parse(chanceController.text);
                  valueController.clear();
                  chanceController.clear();
                  Navigator.pop(context);
                  setState(() {}); // Güncellenen öğeyi liste güncellensin diye setState kullanıyoruz
                }
              },
              child: Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.items.removeAt(index);
                widget.chances.removeAt(index);
                Navigator.pop(context);
                setState(() {}); // Öğe kaldırıldığında listeyi güncellemek için setState kullanıyoruz
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 270, bottom: 480),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/spin.jpg'), // Resmi ekle
                  ),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(widget.items[index]), // String değeri göster
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(widget.chances[index].toString()),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit), // Düzenleme düğmesi eklendi
                    onPressed: () {
                      _showEditItemDialog(context, index);
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 20), // Butonlar ile listeye boşluk ekliyoruz
            ElevatedButton(
              onPressed: () {
                _showAddItemDialog(context);
              },
              child: Icon(Icons.add),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onUpdate(widget.items, widget.chances);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
