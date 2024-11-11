import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/event.dart';
import 'package:flutter_firebase/models/user_m.dart';
import 'package:flutter_firebase/screens/home/event/event_print.dart';
import 'package:flutter_firebase/services/database.dart';
import 'package:provider/provider.dart';

class EventList extends StatefulWidget {
  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    final List<Event>? eventsP = Provider.of<List<Event>?>(context) ?? [];
    final user = Provider.of<User_m?>(context);
    List<Event> eventsPublic = [];

    // Check whether the list of event is null or empty
    if(eventsP!=null){
      eventsP.forEach((event){
        if(event.isPublicEvent!){
          eventsPublic.add(event);
        }
      });
    }

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user?.uid).userData,
      initialData: null,
      builder: (context,snapshot){
        if (snapshot.data?.admin == null ? (eventsPublic.isEmpty) : (eventsP == null || eventsP.isEmpty)) {
          return Center(child: Text('No events available.'));
        } else {
          return StreamProvider<List<Event>>.value(
            value: DatabaseService(uid: user?.uid).events,
            initialData: [],
            child: ListView.builder(
              itemCount: snapshot.data?.admin!=null ? eventsP?.length : eventsPublic.length,
              itemBuilder: (context, index) {
                return EventPrint(event: snapshot.data?.admin!=null ? (eventsP!)[index] : eventsPublic[index]);
              },
            )
          );
        }
      }
    );
  }
}