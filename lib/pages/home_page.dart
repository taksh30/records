import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:records/database/records.dart';
import 'package:records/models/records_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<Records> recordsBox;
  final _searchCtr = TextEditingController();
  List<Records> _filteredRecords = [];
  List<Records> _maxRecordsToLoad = [];
  final ScrollController _scrollCtr = ScrollController();
  int _maxRecordsToLoadNumber = 20;

  // adding a list of all records
  void _addRecords(Box<Records> myBox) {
    if (myBox.isEmpty) {
      RecordsData recordsData = RecordsData();

      // take local list of records
      List<Records> records = recordsData.records;

      // add to mybox of hive
      for (var record in records) {
        myBox.add(record);
      }
    } else {
      if (kDebugMode) {
        print('Records are already added');
      }
    }
  }

  // filtering the records
  void _searchRecords(String search) {
    setState(() {
      _filteredRecords = recordsBox.values.where((record) {
        return record.name.toLowerCase().contains(search.toLowerCase()) ||
            record.phoneNumber.contains(search) ||
            record.city.toLowerCase().contains(search.toLowerCase());
      }).toList();
      _updateMaxRecords();
    });
  }

  // update the rupees
  Future<void> _updateRupees(Records record, int index) async {
    TextEditingController rupeeCtr =
        TextEditingController(text: record.rupees.toString());

    // dialog box
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Rupee'),
        content: TextField(
          autofocus: true,
          controller: rupeeCtr,
          decoration: InputDecoration(
            hintText: 'Update rupee value',
            hintStyle: TextStyle(color: Colors.grey.shade500),
            fillColor: Colors.grey.shade200,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade100),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade500),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
          ),

          // update rupees button
          TextButton(
            onPressed: () async {
              _onUpdateRupees(rupeeCtr, record, index, context);
            },
            child: const Text(
              'Update',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  // on update button
  void _onUpdateRupees(TextEditingController rupeeCtr, Records record,
      int index, BuildContext context) {
    int newRupeesValue = int.parse(rupeeCtr.text);
    setState(() {
      record.rupees = newRupeesValue;
      recordsBox.putAt(index, record);
    });
    Navigator.pop(context);
  }

  // take only first max records to load
  void _updateMaxRecords() {
    setState(() {
      _maxRecordsToLoad =
          _filteredRecords.take(_maxRecordsToLoadNumber).toList();
    });
  }

  // scroll listener
  void _scrollListener() {
    if (_scrollCtr.position.pixels == _scrollCtr.position.maxScrollExtent) {
      setState(() {
        if (_maxRecordsToLoadNumber < _filteredRecords.length) {
          _maxRecordsToLoadNumber += 20;
          _updateMaxRecords();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    recordsBox = Hive.box<Records>('records');
    _addRecords(recordsBox);
    _filteredRecords = recordsBox.values.toList();
    _updateMaxRecords();

    _scrollCtr.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar
      appBar: AppBar(
        title: const Text('Records'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade300,
        foregroundColor: Colors.grey.shade600,
      ),
      body: Column(
        children: [
          // search textfield
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => _searchRecords(value),
              controller: _searchCtr,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                prefixIconColor: Colors.grey.shade500,
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                fillColor: Colors.grey.shade200,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade100),
                  borderRadius: BorderRadius.circular(25),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade500),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // list of records
          Expanded(
            child: ListView.builder(
              controller: _scrollCtr,
              itemCount: _maxRecordsToLoad.length,
              itemBuilder: (context, index) {
                var record = _maxRecordsToLoad[index];

                // listtile of the records
                return ListTile(
                  onTap: () => _updateRupees(record, index),

                  // person name
                  title: Text(
                    record.name,
                  ),

                  // person phone number
                  subtitle: Text(
                    '${record.phoneNumber} - ${record.city}',
                  ),

                  // person image
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      record.imageUrl,
                    ),
                  ),

                  // person rupees value
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        record.rupees.toString(),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      record.rupees >= 50
                          ? const Text(
                              'HIGH',
                            )
                          : const Text(
                              'LOW',
                            ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
