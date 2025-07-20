# AllEvents - Flutter Event Listing App 🎉


A fully functional cross-platform Event Listing App built using Flutter with Riverpod state management. 
This project is designed as part of an assignment for AllEvents to demonstrate practical Flutter development skills.

---

📱 Features

✅ Google Sign-In Authentication  
✅ Dynamic Category Listing (from remote API)  
✅ Event Listing with:
- Grid & List toggle views
- Responsive design  
  ✅ Event Details Screen with:
- WebView ticket booking
- Event details and venue information  
  ✅ Local Data Caching with Hive  
  ✅ Pull-to-Refresh, Skeleton Loading, and Shimmer effects  
  ✅ Animated UI Elements for smoother UX  
  ✅ Notifications Integration using flutter_local_notifications (server implementation required)

---

## 🚀 Getting Started

1. git clone https://github.com/Uday-bonhq/all_event.git
2. cd all_event and Install dependencies
3. Firebase Setup

- Configure your Firebase project.
- Download the `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) files.
- Place them in the respective platforms' directories.

4. Run the app


---

🔗 APIs Used

- Categories API:  
  https://allevents.s3.amazonaws.com/tests/categories.json

- Events API:  
  Events are fetched dynamically from the endpoint provided inside each category item.

---

📂 Project Structure

lib/
┣ core/ (utils, resources, common method)
┣ features/ (screens, widgets)
┣ models/ (data models)
┣ services/ (networking, authentication, notification)
┣ providers/ (Riverpod providers)
┣ main.dart




---

📸 Screenshots

(Screenshots can be added here)

---

💻 Tech Stack

- Flutter (v3.5.0)
- Riverpod (State Management)
- Firebase Auth & Google Sign-In
- Hive (Local Storage)
- WebView
- Notifications
- Shimmer/Skeleton Loaders
- Responsive Design

---

📦 APK & Demo Links

- APK Build: https://we.tl/t-bCv0KUqpKO
- GitHub Repository: https://github.com/your-username/all_event

---

📝 Notes

✅ Code follows clean architecture and modular folder structure  
✅ Dynamic fetching to accommodate API data changes  
✅ Responsive UI for all screen sizes

---

🙏 Acknowledgements

Thanks to the AllEvents team for the assignment opportunity. Open to feedback and improvements!





