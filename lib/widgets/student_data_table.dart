import 'package:flutter/material.dart';
import 'package:phd_monitoring_mobile_app/model/user_role.dart';

class StudentDataTable extends StatefulWidget {
  final Map<String, dynamic> tableData;
  final Function(List<Map<String, dynamic>>) onSelectionChanged;
  final Function(int id) onTap;
  final UserRole role;

  const StudentDataTable({
    super.key,
    required this.tableData,
    required this.onSelectionChanged,
    required this.onTap,
    required this.role,
  });

  @override
  State<StudentDataTable> createState() => _StudentDataTableState();
}

class _StudentDataTableState extends State<StudentDataTable> {
  late List<Map<String, dynamic>> _data;
  late List<String> _fields;
  late List<String> _fieldTitles;
  bool selectOn = false;

  // Selection tracking
  final Set<int> _selectedRows = {};
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    _parseData();
  }

  @override
  void didUpdateWidget(StudentDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tableData != oldWidget.tableData) {
      _parseData();
    }
  }

  void _parseData() {
    if (widget.tableData['success'] == true &&
        widget.tableData['response'] != null) {
      final response = widget.tableData['response'];
      _data = List<Map<String, dynamic>>.from(response['data'] ?? []);
      _fields = List<String>.from(response['fields'] ?? []);
      _fieldTitles = List<String>.from(response['fieldsTitles'] ?? []);

      _selectedRows.clear();
      _selectAll = false;
      _notifySelectionChanged();
    }
  }

  void _toggleSelectAll() {
    setState(() {
      _selectAll = !_selectAll;
      _selectedRows.clear();
      if (_selectAll) {
        _selectedRows.addAll(_data.asMap().keys);
      }
      _notifySelectionChanged();
    });
  }

  void _toggleRowSelection(int index) {
    setState(() {
      if (_selectedRows.contains(index)) {
        _selectedRows.remove(index);
        _selectAll = false;
      } else {
        _selectedRows.add(index);
        if (_selectedRows.length == _data.length) {
          _selectAll = true;
        }
      }
      _notifySelectionChanged();
    });
  }

  void _notifySelectionChanged() {
    final selectedItems = _selectedRows.map((index) => _data[index]).toList();
    widget.onSelectionChanged(selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    if (_data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return Column(
      children: [
        if (widget.role != UserRole.student)
          Row(
            children: [
              Spacer(),
              if (selectOn)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // selectOn = !selectOn;
                    });
                  },
                  child: Text("Do to select"),
                ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectOn = !selectOn;
                    _selectedRows.clear();
                  });
                },
                child: Text(!selectOn ? "Select" : "Cancel"),
              ),
            ],
          ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columnSpacing: 10,
              horizontalMargin: 8,
              dataRowHeight: 48,
              headingRowHeight: 40,
              columns: [
                if (selectOn)
                  DataColumn(
                    label: SizedBox(
                      width: 24,
                      child: Checkbox(
                        value: _selectAll,
                        onChanged: (_) => _toggleSelectAll(),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                ..._fieldTitles.map(
                  (title) => DataColumn(
                    label: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
              rows:
                  _data.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;

                    return DataRow(
                      onLongPress: () {
                        widget.onTap(item['id']);
                      },
                      cells: [
                        if (selectOn)
                          DataCell(
                            SizedBox(
                              width: 24,
                              child: Checkbox(
                                value: _selectedRows.contains(index),
                                onChanged: (_) => _toggleRowSelection(index),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ),
                        ..._fields.map(
                          (field) => DataCell(
                            Text(
                              item[field]?.toString() ?? 'N/A',
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
