import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/event.dart';
import 'package:flutter_firebase/models/participant.dart';
import 'package:flutter_firebase/models/user_m.dart';
import 'package:flutter_firebase/services/database.dart';
import 'package:flutter_firebase/shared/constants.dart';
import 'package:provider/provider.dart';

class ParticipantForm extends StatefulWidget {
  final Function(Participant) onSubmit; // Function for sending form data
  final Event event; // Parameter for the event to be modified

  const ParticipantForm({required this.onSubmit, required this.event});

  @override
  _ParticipantFormState createState() => _ParticipantFormState();
}

class _ParticipantFormState extends State<ParticipantForm> {
  final _formKey = GlobalKey<FormState>();

  String? _firstName;
  String? _lastName;
  String? _email;
  int? _nbAdult;
  int? _nbChild;
  int? _nbNonMember;
  String? _food;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User_m?>(context);
    
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            'Event registration',
            style: TextStyle(fontSize: 18.0),
          ),

          SizedBox(height: 20.0),

          // Participant first name input field
          Row(
            children: [
              Text(
                'First name :',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  decoration: textInputDecoration,
                  validator: (val) => val!.isEmpty ? 'Please enter a first name' : null,
                  onChanged: (val) => setState(() => _firstName = val),
                ),
              ),
            ],
          ),

          SizedBox(height: 10),

          // Participant last name input field
          Row(
            children: [
              Text(
                'Last name :',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  decoration: textInputDecoration,
                  validator: (val) => val!.isEmpty ? 'Please enter a last name' : null,
                  onChanged: (val) => setState(() => _lastName = val),
                ),
              ),
            ],
          ),

          SizedBox(height: 10),

          // Participant email input field
          Row(
            children: [
              Text(
                'Email :',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  decoration: textInputDecoration,
                  validator: (val) => val!.isEmpty ? 'Please enter an email' : null,
                  onChanged: (val) => setState(() => _email = val),
                ),
              ),
            ],
          ),

          SizedBox(height: 10),

          // Participant number adult input field
          Row(
            children: [
              Text(
                'Number of Adults :',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  decoration: textInputDecoration,
                  keyboardType: TextInputType.number,
                  validator: (val) => val!.isEmpty ? 'Please enter number of adults' : null,
                  onChanged: (val) => setState(() => _nbAdult = int.tryParse(val)),
                ),
              ),
            ],
          ),

          SizedBox(height: 10),

          // Participant number children input field
          Row(
            children: [
              Text(
                'Number of Children :',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  decoration: textInputDecoration,
                  keyboardType: TextInputType.number,
                  validator: (val) => val!.isEmpty ? 'Please enter number of children' : null,
                  onChanged: (val) => setState(() => _nbChild = int.tryParse(val)),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 10),

          // Participant number non-member or food contribution input field
          widget.event.isPublicEvent! 
            ?Row(
              children: [
                Text(
                  'Number of Non-members :',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: textInputDecoration,
                    keyboardType: TextInputType.number,
                    validator: (val) => val!.isEmpty ? 'Please enter number of non-members' : null,
                    onChanged: (val) => setState(() => _nbNonMember = int.tryParse(val)),
                  ),
                ),
              ],
            )
            :Row(
              children: [
                Text(
                  'Food contribution :',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: textInputDecoration,
                    keyboardType: TextInputType.number,
                    validator: (val) => val!.isEmpty ? 'Please enter your food contribution' : null,
                    onChanged: (val) => setState(() => _food = val),
                  ),
                ),
              ],
            ),

          SizedBox(height: 20),

          // Registration button
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.brown[400]),
            child: Text(
              'Register',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await DatabaseService(uid: user?.uid).addParticipant(
                  user?.uid ?? '',
                  widget.event.nameDoc!,
                  _firstName!,
                  _lastName!,
                  _email!,
                  _nbAdult ?? 0,
                  _nbChild ?? 0,
                  _nbNonMember ?? 0,
                  _food ?? ''
                );
                // Modifying a document in the event collection to reload the home page
                DocumentReference eventRef = DatabaseService().eventCollection.doc((widget.event.nameDoc)!);
                eventRef.update({'update': false});
                eventRef.update({'update': true});
                Navigator.pop(context); // Closes the modal after submission
              }
            }
          ),
        ],
      ),
    );
  }
}
