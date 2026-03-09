# Reminder App
Hey there, this is my final project of IOS Mobile Development course from ABB Tech Academy.

This is a robust **Reminder Application** for iOS built using **Swift** and **UIKit**. It allows users to create tasks, set specific dates and times for notifications, attach photos from their library, and manage their productivity with a clean, modern interface.

---

## ## Key Features

* **Task Management**: Create, edit, and delete reminders with ease.
* **Local Notifications**: Automated alerts for upcoming tasks using `UserNotifications`.
* **Media Support**: Attach images to reminders using the modern `PHPickerViewController`.
* **Persistent Storage**: Reminders and images are saved locally to the device's `UserDefaults` and `DocumentDirectory`.
* **Dark Mode Support**: A dedicated settings toggle to switch between light and dark themes.
* **SnapKit Layouts**: Uses SnapKit for programmatic, readable Auto Layout constraints.

---

## ## Project Structure

| File | Responsibility |
| --- | --- |
| **ReminderListViewController.swift** | The main dashboard; handles the table view and task lifecycle. |
| **AddReminderViewController.swift** | The form for creating/editing reminders and picking photos. |
| **DataManager.swift** | Handles JSON encoding for tasks and file management for images. |
| **NotificationManager.swift** | Manages `UNUserNotificationCenter` permissions and scheduling. |
| **ReminderCell.swift** | Custom `UITableViewCell` with strike-through logic for completed tasks. |
| **SettingsViewController.swift** | Controls the application's appearance and system overrides. |

---

## ## Workflow & Implementation (Bash Logic)

While this is a GUI-based iOS app, the logic flow of the methods can be visualized through the following sequences.

### ### 1. Saving a Reminder with an Image

When `saveTapped()` is called in `AddReminderViewController`, the following logic occurs:

```bash
# 1. Validate Input
if [ "$titleText" == "" ]; then stop_save; fi

# 2. Process Image (DataManager.saveImage)
generate_uuid_filename -> ".jpg"
compress_image_data (quality: 0.8)
write_to_disk -> "Documents/UUID.jpg"

# 3. Schedule Notification (NotificationManager.scheduleNotification)
set_content (title, body)
set_trigger (date_components)
add_request_to_UNUserNotificationCenter

```

### ### 2. Loading Data on App Launch

When `ReminderListViewController` loads, it triggers the `DataManager`:

```bash
# 1. Load Reminders
fetch_data_from_UserDefaults (key: "saved_reminders")
decode_JSON_to_Reminder_Array

# 2. Refresh UI
reload_tableView_data

```

---

## ## Technical Documentation & References

This project was developed using the following official Apple documentation and technical guides:

* **[UNUserNotificationCenter](https://developer.apple.com/documentation/usernotifications/unusernotificationcenter)**: For scheduling and managing local alerts.
* **[PHPickerViewController](https://developer.apple.com/documentation/PhotosUI/PHPickerViewController)**: For secure, modern access to the user's photo library.
* **[PhotoKit Observations](https://developer.apple.com/documentation/photokit/observing-changes-in-the-photo-library)**: Guidance on handling photo library changes.
* **Technical References & Brainstorming**:
* [Feature Planning Guide - Part 1](https://gemini.google.com/share/e74d2471069c)
* [Feature Planning Guide - Part 2](https://gemini.google.com/share/d86db43862ca)



---

## ## Getting Started

1. **Clone the repository**:
```bash
git clone https://github.com/kelbiyev/Reminder-App.git

```


2. **Install Dependencies**: This project uses **SnapKit**. Ensure you have [SnapKit]([https://cocoapods.org](https://github.com/SnapKit/SnapKit)) installed


3. **Open the Project**: Open `ReminderApp.xcworkspace` in Xcode.
4. **Run**: Select your preferred simulator and press **Cmd + R**.

