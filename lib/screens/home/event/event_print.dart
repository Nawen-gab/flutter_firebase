import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/activity.dart';
import 'package:flutter_firebase/models/event.dart';
import 'package:flutter_firebase/models/participant.dart';
import 'package:flutter_firebase/models/user_m.dart';
import 'package:flutter_firebase/screens/home/event/event_form.dart';
import 'package:flutter_firebase/screens/home/participant/participant_form.dart';
import 'package:flutter_firebase/screens/home/participant/participants_modal.dart';
import 'package:flutter_firebase/services/database.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventPrint extends StatelessWidget {
  final Event event;
  EventPrint({required this.event});

  // Function for formatting time (TimeOfDay) in readable format
  String formatTimeOfDay(TimeOfDay? timeOfDay) {
    if (timeOfDay == null) return 'No time selected';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return DateFormat('HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User_m?>(context);
    
    return StreamBuilder<List<Event>>(
      stream: DatabaseService(uid: user?.uid).events,
      builder: (context,eventSnapshot) {
        return StreamBuilder<List<UserData>>(
          stream: DatabaseService(uid: user?.uid).listUser,
          builder: (context, snapshot) {
            UserData? userConnected;
            UserData? userDataEvent;

            if(snapshot.data != null){
              for(UserData _user in snapshot.data!){
                if(_user.uid == user?.uid){
                  userConnected=_user;
                }
                if(_user.uid == event.creatorUid){
                  userDataEvent=_user;
                }
              }
            }
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with event title and date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            event.title ?? 'No Title',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown[400],
                            ),
                          ),
                          Text(
                            event.date != null
                                ? DateFormat('dd/MM/yyyy').format(event.date!)
                                : 'No Date',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      
                      // Description of the event
                      Text(
                        event.description ?? 'No Description',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 15),
            
                      // Dividing line
                      Divider(color: Colors.grey[300]),
            
                      // Additional information (Time, Place, Category)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _eventDetailRow(
                            icon: Icons.access_time,
                            label: '${formatTimeOfDay(event.start)} - ${formatTimeOfDay(event.end)}',
                          ),
                          _eventDetailRow(
                            icon: Icons.location_on,
                            label: event.location ?? 'No Location',
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _eventDetailRow(
                            icon: Icons.category,
                            label: event.isPublicEvent == null ? 'No Category':(event.isPublicEvent! ? 'Public Event':'Private Event'),
                          ),
                          _eventDetailRow(
                            icon: Icons.person,
                            label: (userDataEvent?.firstName != null)&&(userDataEvent?.lastName != null) ? ((userDataEvent?.firstName)! + ' ' + (userDataEvent?.lastName)!) : 'Unknown Creator',
                          ),
                        ],
                      ),
        
                      SizedBox(height: 15),
                      Divider(color: Colors.grey[300]),
        
                      // Activity display
                      if (event.activities != null && event.activities!.isNotEmpty) ...[
                        Text(
                          'Activities:',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[400],
                          ),
                        ),
                        SizedBox(height: 10),
                        Column(
                          children: event.activities!.map((activity) => _activityItem(activity)).toList(),
                        ),
                      ],

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // View button
                          if (userConnected?.admin==true || (event.creatorUid == user?.uid))
                            ElevatedButton.icon(
                              icon: Icon(Icons.visibility, color: Colors.white),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown[400],
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () => _showParticipants(context),
                              label: Text(
                                'View',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),

                          // Register button
                          if ((event.creatorUid != user?.uid) && !isRegister(user!.uid!, event))
                            ElevatedButton.icon(
                              icon: Icon(Icons.check_circle, color: Colors.white),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown[400],
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () => _showRegisterForm(context),
                              label: Text(
                                'Register',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),

                          // Modify button
                          if (userConnected?.admin==true || (event.creatorUid == user?.uid))
                            ElevatedButton.icon(
                              icon: Icon(Icons.edit, color: Colors.white),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown[400],
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () => _showModifyEventPanel(context),
                              label: Text(
                                'Modify',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),

                          // Delate button
                          if (userConnected?.admin==true || (event.creatorUid == user?.uid))
                            ElevatedButton.icon(
                              icon: Icon(Icons.delete, color: Colors.white),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown[400],
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () => _showDeleteConfirmationDialog(context, (event.nameDoc)!),
                              label: Text(
                                'Delate',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        );
      }
    );
  }

  // Widget helper to display an icon with a descriptive text
  Widget _eventDetailRow({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.brown[400],
          size: 20.0,
        ),
        SizedBox(width: 8.0),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  // Widget to display an activity
  Widget _activityItem(Activity activity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.title ?? 'No Title',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                activity.description ?? 'No Description',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          Text(
            '${formatTimeOfDay(activity.start)} - ${formatTimeOfDay(activity.end)}',
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // Method for displaying the list of participants
  void _showParticipants(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ParticipantsModal(event: event);
      },
    );
  }

  void _showRegisterForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // So that the form can be scrolled if necessary
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: ParticipantForm(
              onSubmit: (newParticipant) {
                print('New Participant: ${newParticipant.email}');
                print('Number of Adults: ${newParticipant.nbAdult}');
                print('Number of Children: ${newParticipant.nbChild}');
                print('Number of Non-members: ${newParticipant.nbNonMember}');
                print('Food Preferences: ${newParticipant.food}');
              },
              event: event,
            ),
          ),
        );
      }
    );
  }

  void _showModifyEventPanel(BuildContext context) {
    showModalBottomSheet(context: context, builder: (context){
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: EventForm(event: event),
        ),
      );
    });
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, String nameDoc) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // The user must respond to the dialog box
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm deletion'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this event ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog box
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                DatabaseService dbService = DatabaseService(uid: event.creatorUid);
                await dbService.deleteEventWithActivities(nameDoc);
                Navigator.of(context).pop(); // Close the dialog box
              },
            ),
          ],
        );
      },
    );
  }

  bool isRegister(String uid, Event event){
    for(Participant participant in event.participants!){
      if(participant.uid == uid){
        return true;
      }
    }
    return false;
  }
}