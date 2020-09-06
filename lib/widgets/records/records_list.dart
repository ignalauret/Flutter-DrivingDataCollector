import 'package:driving_data_collector/models/record.dart';
import 'package:driving_data_collector/widgets/records/records_list_item.dart';
import 'package:flutter/material.dart';

class RecordsList extends StatelessWidget {
  RecordsList(this.records);
  final List<Record> records;
  @override
  Widget build(BuildContext context) {
    return records.length == 0
        ? Center(
            child: Text("No hay grabaciones."),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, index) => RecordsListItem(records[index]),
            itemCount: records.length,
          );
  }
}
