import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/activity.dart';

class ActivityForm extends StatefulWidget {
  final Function(Activity) onSubmit; // Callback function to return activity data
  final Activity? initialActivity; // Initial activity to be modified

  ActivityForm({required this.onSubmit, this.initialActivity});

  @override
  _ActivityFormState createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final _formKey = GlobalKey<FormState>();

  String? _currentTitle;
  String? _currentDescription;
  TimeOfDay? _currentStart;
  TimeOfDay? _currentEnd;

  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fill in the form fields with the initial activity, if provided
    if (widget.initialActivity != null) {
      _currentTitle = widget.initialActivity!.title;
      _currentDescription = widget.initialActivity!.description;
      _currentStart = widget.initialActivity!.start;
      _currentEnd = widget.initialActivity!.end;
    }
  }

  // Select start time
  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _currentStart) {
      setState(() {
        _currentStart = picked;
        _startTimeController.text = picked.format(context);
      });
    }
  }

  // Select end time
  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _currentEnd) {
      setState(() {
        _currentEnd = picked;
        _endTimeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Text(
            'Add Activity',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 20.0),
          
          // Activity title input field
          TextFormField(
            initialValue: _currentTitle,
            decoration: InputDecoration(hintText: 'Activity Title'),
            validator: (val) => val!.isEmpty ? 'Please enter a title' : null,
            onChanged: (val) => setState(() => _currentTitle = val),
          ),
          
          SizedBox(height: 20.0),
          
          // Activity description input field
          TextFormField(
            initialValue: _currentDescription,
            decoration: InputDecoration(hintText: 'Activity Description'),
            validator: (val) => val!.isEmpty ? 'Please enter a description' : null,
            onChanged: (val) => setState(() => _currentDescription = val),
          ),

          SizedBox(height: 20.0),

          // Select start time
          TextFormField(
            controller: _startTimeController,
            decoration: InputDecoration(hintText: 'Start Time'),
            readOnly: true,
            onTap: () => _selectStartTime(context),
          ),
          
          SizedBox(height: 20.0),
          
          // Select end time
          TextFormField(
            controller: _endTimeController,
            decoration: InputDecoration(hintText: 'End Time'),
            readOnly: true,
            onTap: () => _selectEndTime(context),
          ),

          SizedBox(height: 20.0),
          
          // Button of validation
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.brown[400],
            ),
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Activity newActivity = Activity(
                  nameDoc: widget.initialActivity?.nameDoc,
                  title: _currentTitle,
                  description: _currentDescription,
                  start: _currentStart,
                  end: _currentEnd,
                );
                widget.onSubmit(newActivity); // Return the activity to the parent form
                Navigator.pop(context); // Close the modal
              }
            },
          ),
        ],
      ),
    );
  }
}
