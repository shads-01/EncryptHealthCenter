# 🏥 Encrypt Health Center

A healthcare appointment management app built with Flutter and Firebase. Patients can register, browse doctors by specialty, view profiles and ratings, book appointments with date/time pickers, and manage their medical profile — all wrapped in a polished UI with animated transitions.

## ✨ Technologies

- `Flutter`
- `Dart`
- `Firebase Authentication`
- `Cloud Firestore`
- `Firebase Storage`
- `Lottie Animations`
- `Google Sign-In`

## 🚀 Features

- Animated splash screen with Lottie ambulance animation
- Email/password authentication with registration and login
- Patient registration with medical details (blood group, gender, DOB)
- Home page with auto-sliding image carousel and specialist category cards
- Browse doctors by specialty — Medicine, Cardiologist, Neurologist, Paediatrician, and more
- Top-rated doctors list fetched in real-time from Firestore
- Doctor profile view with star ratings, contact info, and working hours
- Search doctors by name or specialization
- Book appointments with date and time pickers
- View and delete upcoming appointments
- Editable user profile with personal and medical information
- Bottom navigation bar with Home, Search, Appointments, and Profile tabs

## 📍 The Process

We wanted to build something that actually solves a real problem — booking doctor appointments shouldn't feel like a chore. Started with the core auth flow using Firebase, then built out the doctor listing system powered by Cloud Firestore. The homepage came together with a scrolling image carousel and colorful specialty cards that make browsing feel intuitive. Each doctor profile pulls live data including ratings, working hours, and contact details, with a one-tap booking flow. The appointment system stores everything in Firestore and lets patients track or cancel bookings. Added Lottie for the splash screen to give it some personality, and the edit profile page keeps medical records like blood group and DOB easily accessible.

## 🚦 Running the Project

1. Clone the repository
2. Install dependencies: `flutter pub get`
3. Set up a Firebase project and add your `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS)
4. Run the app: `flutter run`
