import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/event.dart';

class ParticipantsModal extends StatelessWidget {
  final Event event;

  ParticipantsModal({required this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Participants',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.brown[700],
            ),
          ),

          SizedBox(height: 10),

          if (event.participants == null || event.participants!.isEmpty)
            Center(
              child: Text(
                'No participants found.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: event.participants!.length,
                itemBuilder: (context, index) {
                  final participant = event.participants![index];

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      leading: CircleAvatar(
                        backgroundColor: Colors.brown[200],
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Printing the first and last name
                          Text(
                            '${participant.firstName ?? 'No First Name'} ${participant.lastName ?? 'No Last Name'}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.brown[800],
                            ),
                          ),

                          SizedBox(height: 4),

                          // Printing the email
                          Text(
                            participant.email ?? 'No Email',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),

                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Printing number of adult
                            Text(
                              'Adults: ${participant.nbAdult ?? 0}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.brown[600],
                              ),
                            ),
                            
                            // Printing number of children
                            Text(
                              'Children: ${participant.nbChild ?? 0}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.brown[600],
                              ),
                            ),
                            
                            // Printing number of non-members
                            Text(
                              event.isPublicEvent == true
                                  ? 'Non-members: ${participant.nbNonMember ?? 0}'
                                  : 'Food: ${participant.food ?? 'N/A'}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.brown[600],
                              ),
                            ),
                          ],
                        ),
                      ),
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
