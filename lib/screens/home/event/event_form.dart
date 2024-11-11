import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/activity.dart';
import 'package:flutter_firebase/models/event.dart';
import 'package:flutter_firebase/models/user_m.dart';
import 'package:flutter_firebase/screens/home/event/activity_form.dart';
import 'package:flutter_firebase/services/database.dart';
import 'package:flutter_firebase/shared/constants.dart';
import 'package:flutter_firebase/shared/loading.dart';
import 'package:provider/provider.dart';

class EventForm extends StatefulWidget {
  final Event? event; // Add a parameter to modify the event

  EventForm({this.event});

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {

  final _formKey = GlobalKey<FormState>();
  final List<bool> admin = [true, false];
  final List<String> category = ['Public Event', 'Private Event'];

  String? _currentTitle='';
  String? _currentDescription='';
  DateTime? _currentDate;
  TimeOfDay? _currentStart;
  TimeOfDay? _currentEnd;
  String? _currentLoc='';
  bool? _currentCategory;

  final TextEditingController _dateController = TextEditingController();
  // Function for displaying the date selector
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Initial date
      firstDate: DateTime(2000), // Minimum date
      lastDate: DateTime(2100),  // Maximum date
    );
    if (picked != null && picked != _currentDate) {
      setState(() {
        _currentDate = picked;
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  List<Activity> _activities = [];
  // Function for displaying the form for adding or modifying an activity
  void _showActivityPanel({Activity? activity, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: ActivityForm(
              onSubmit: (newActivity) {
                if (index != null) {
                  // Modifying an existing activity
                  setState(() {
                    _activities[index] = newActivity; // Replaces the activity with the new one
                  });
                } else {
                  // Add a new activity
                  setState(() {
                    _activities.add(newActivity);
                  });
                }
              },
              initialActivity: activity, // To pre-fill the form if any changes are made
            ),
          ),
        );
      },
    );
  }

  // Function to add a new activity to the list
  void _addActivity(Activity newActivity) {
    setState(() {
      _activities.add(newActivity);
    });
  }

  // Function for deleting an activity
  void _deleteActivity(int index) {
    setState(() {
      _activities.removeAt(index);
    });
  }

  // Variable for storing the selected time
  final TextEditingController _timeControllerStart = TextEditingController();
  final TextEditingController _timeControllerEnd = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _currentTitle = widget.event?.title;
      _currentDescription = widget.event?.description;
      _currentDate = widget.event?.date;
      _currentStart = widget.event?.start;
      _currentEnd = widget.event?.end;
      _currentLoc = widget.event?.location;
      _currentCategory = widget.event?.isPublicEvent;

      _activities = widget.event?.activities ?? [];
      _dateController.text = "${_currentDate?.day}/${_currentDate?.month}/${_currentDate?.year}";
      _timeControllerStart.text = "${_currentStart!.hour}h${_currentStart!.minute}";
      _timeControllerEnd.text = "${_currentEnd!.hour}h${_currentEnd!.minute}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User_m?>(context);
    
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user?.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  'Create an event',
                  style: TextStyle(fontSize: 18.0),
                ),

                SizedBox(height: 20.0),

                // Event title input field
                Row(
                  children: [
                    Text(
                      'Title :',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        initialValue: _currentTitle??'',
                        decoration: textInputDecoration,
                        validator: (val) => val!.isEmpty ? 'Please enter a title' : null,
                        onChanged: (val) => setState(() => _currentTitle = val),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.0),

                // Event description input field
                Row(
                  children: [
                    Text(
                      'Description :',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        initialValue: _currentDescription??'',
                        decoration: textInputDecoration,
                        validator: (val) => val!.isEmpty ? 'Please enter a description' : null,
                        onChanged: (val) => setState(() => _currentDescription = val),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.0),

                // Event date input field
                Row(
                  children: [
                    Text(
                      'Date :',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        //initialValue: '',//_currentDate != null ? '${_currentDate!.day}/${_currentDate!.month}/${_currentDate!.year}' : null,
                        controller: _dateController,
                        readOnly: true,
                        decoration: textInputDecoration,
                        validator: (val) => (val==null? 'Please enter a date':(val.isEmpty ? 'Please enter a date' : null)),
                        onTap: () => _selectDate(context), // Ouvre le sélecteur de date
                        //onChanged: (val) => setState(() => _currentDescription = val),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.0),

                // Event start hour input field
                Row(
                  children: [
                    Text(
                      'Start hour :',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _timeControllerStart,
                        readOnly: true,
                        decoration: textInputDecoration,
                        validator: (val) => (val == null ? 'Please enter the start hour':(val.isEmpty ? 'Please enter the start hour' : null)),
                        onTap: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(), // Heure initiale
                          );
                          if (picked != null && picked != _currentStart) {
                            setState(() {
                              _currentStart = picked;
                              // Mettre à jour le TextEditingController pour afficher l'heure sélectionnée
                              _timeControllerStart.text = picked.format(context);
                            });
                          }
                        }
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.0),

                // Event end hour input field
                Row(
                  children: [
                    Text(
                      'End hour :',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _timeControllerEnd,
                        readOnly: true,
                        decoration: textInputDecoration,
                        validator: (val) => (val==null? 'Please enter the end hour':(val.isEmpty ? 'Please enter the end hour' : null)),
                        onTap: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(), // Heure initiale
                          );
                          if (picked != null && picked != _currentEnd) {
                            setState(() {
                              _currentEnd = picked;
                              // Mettre à jour le TextEditingController pour afficher l'heure sélectionnée
                              _timeControllerEnd.text = picked.format(context);
                            });
                          }
                        }
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.0),

                // Event location input field
                Row(
                  children: [
                    Text(
                      'Location :',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        initialValue: _currentLoc??'',
                        decoration: textInputDecoration,
                        validator: (val) => val!.isEmpty ? 'Please enter a location' : null,
                        onChanged: (val) => setState(() => _currentLoc = val),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.0),

                // Event category input field
                Row(
                  children: [
                    Text(
                      'Category :',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField(
                        decoration: textInputDecoration,
                        validator: (val) => val==null ? 'Please enter a category' : null,
                        value: _currentCategory == null ? null:(_currentCategory!?category[0]:category[1]),
                        items: category.map((category){
                          return DropdownMenuItem(
                            value: category,
                            child : Text(category),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _currentCategory = val==category[0]),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.0),

                // Add activity button
                TextButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Add Activity'),
                  onPressed: () => _showActivityPanel(),
                ),

                // Display the list of added activities
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _activities.asMap().entries.map((entry) {
                    int index = entry.key;
                    Activity activity = entry.value;

                    return ListTile(
                      title: Text(activity.title ?? 'No Title'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(activity.description ?? 'No Description'), // Description de l'activité
                          SizedBox(height: 5),
                          Text('${activity.start?.format(context)} - ${activity.end?.format(context)}'), // Heures de début et de fin
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _showActivityPanel(activity: activity, index: index), // Ouvre le formulaire avec les données de l'activité
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteActivity(index), // Supprime l'activité
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: 20.0),

                // Button for save the event
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.brown[400],
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      if(widget.event == null){
                        await DatabaseService(uid: user?.uid).createEventData(
                          _currentTitle!,
                          _currentDescription!,
                          _currentDate!,
                          _currentStart!,
                          _currentEnd!,
                          _currentLoc!,
                          _currentCategory!,
                          _activities
                        );
                      } else {
                        await DatabaseService(uid: user?.uid).updateEventData(
                          (widget.event?.nameDoc)!,
                          _currentTitle!,
                          _currentDescription!,
                          _currentDate!,
                          _currentStart!,
                          _currentEnd!,
                          _currentLoc!,
                          _currentCategory!,
                          _activities
                        );

                        // Modifying a document in the event collection to reload the home page
                        DocumentReference eventRef = DatabaseService().eventCollection.doc((widget.event?.nameDoc)!);
                        eventRef.update({'update': false});
                        eventRef.update({'update': true});
                      }
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            )
          );
        } else {
          return Loading();
        }
      }
    );
  }
}