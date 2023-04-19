import 'package:flutter/material.dart';

class ReasonChoicePicker extends StatefulWidget {
  final void Function(String selectedChoice) ReasonChoicePickerFn;
  ReasonChoicePicker(this.ReasonChoicePickerFn);

  @override
  State<ReasonChoicePicker> createState() => _ChoicePickerState();
}

class _ChoicePickerState extends State<ReasonChoicePicker> {
  String _selectedChoice = '';
  final List<String> reasonList = [
    'Food',
    'Clothing',
    'Travel',
    'Miscellaneous',
  ];
  @override
  Widget build(BuildContext context) {
    if (_selectedChoice.length == 1) {
      setState(() {
        widget.ReasonChoicePickerFn(_selectedChoice);
      });
    }
    return Wrap(
      children: reasonList.map(
        (reason) {
          bool isSelected = false;
          if (_selectedChoice.contains(reason)) {
            isSelected = true;
          }
          return GestureDetector(
            onTap: () {
              if (!_selectedChoice.contains(reason)) {
                if (_selectedChoice.length < 5) {
                  _selectedChoice = reason;
                  setState(() {});
                }
              } else {
                _selectedChoice = '';
                setState(() {});
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey,
                        width: 2)),
                child: Text(
                  reason,
                  style: TextStyle(
                      color: isSelected ? Colors.blue : Colors.grey,
                      fontSize: 14),
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
