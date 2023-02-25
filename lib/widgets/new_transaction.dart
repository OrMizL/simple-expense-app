import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaction;

  NewTransaction(this.addTransaction);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _dateController;

  void _submitForm() {
    if (_amountController.text.isEmpty ||
        _titleController.text.isEmpty ||
        _dateController == null) return;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredAmount <= 0) return;

    widget.addTransaction(
      _titleController.text,
      enteredAmount,
      _dateController,
    );

    Navigator.of(context).pop();
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    ).then(
      (pickedDate) {
        if (pickedDate == null) return;
        setState(() {
          _dateController = pickedDate;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus.unfocus(),
      child: SingleChildScrollView(
        child: Card(
          child: Container(
            padding: EdgeInsets.only(
              top: 10,
              right: 10,
              left: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  // onChanged: (value) => titleInput = value,
                  controller: _titleController,
                  onSubmitted: (_) => _submitForm(),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Amount'),
                  // onChanged: (value) => amountInput = value,
                  controller: _amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onSubmitted: (_) => _submitForm(),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _dateController == null
                            ? 'No date chosen'
                            : DateFormat.yMd().format(_dateController),
                      ),
                    ),
                    TextButton(
                      onPressed: _showDatePicker,
                      child: Text(
                        'Pick a Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  child: Text('Add Transaction'),
                  onPressed: _submitForm,
                  style: TextButton.styleFrom(
                      foregroundColor:
                          Theme.of(context).textTheme.labelLarge.color,
                      backgroundColor: Theme.of(context).colorScheme.primary),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
