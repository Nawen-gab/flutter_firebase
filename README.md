Flutter Firebase Event Management App

This Flutter app allows administrators to create, modify, and manage events, while users can register, view, and participate in those events. The app uses Firebase for backend services, including authentication and database management.

Installation and Setup

1. Clone the Repository

    git clone https://github.com/Nawen-gab/flutter_firebase.git

    cd flutter_firebase

2. Install Dependencies

    flutter pub get

3. Set Up Firebase

   Create a Firebase Project:

       Go to the Firebase Console, click Add Project, and follow the setup steps.

   Add Firebase to Your App:

       In the Firebase Console, add an Android app:

           Use your package name, typically com.example.your_app_name (found in android/app/src/main/AndroidManifest.xml).

           Download google-services.json when prompted and move it to android/app/.

   Enable Firebase Services:

       Authentication: Go to Authentication in the Firebase Console, enable Email/Password sign-in.

       Firestore Database: Go to Firestore Database, create a database in test mode for initial setup. Set up production rules as needed.

5. Add Firebase Plugins

    In your project's pubspec.yaml, add the necessary Firebase dependencies:

    dependencies:
    
        cupertino_icons: ^1.0.8
    
        firebase_core: ^3.6.0
    
        firebase_auth: ^5.3.1
    
        cloud_firestore: ^5.4.4
    
        provider: ^6.1.2
    
        flutter_spinkit: ^5.1.0
    
        intl: ^0.17.0
