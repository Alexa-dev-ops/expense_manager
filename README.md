# WYZE Expense Manager Assessment

A simple full-stack Expense Manager built for the WYZE Developer Track Assessment. 

## Tech Stack
* **Backend:** Dart, Shelf (Routing), SQLite (Database)
* **Frontend:** HTML, CSS, Vanilla JavaScript

## Setup & Run Instructions

### 1. Start the Backend
1. Ensure you have the Dart SDK installed.
2. Clone this repository and navigate into the project folder.
3. Fetch dependencies by running:
   `dart pub get`
4. Start the server:
   `dart run bin/server.dart`
5. The API will be live at `http://localhost:8080`.

### 2. Start the Frontend
1. Ensure the backend is running first.
2. Open the `frontend` folder.
3. Open `index.html` in any modern web browser (no web server required, but you can use Live Server if preferred).

## Assessment Requirements
* **Time Spent:** [Be honest here, e.g., "Roughly 6 hours over the weekend"]
* **Assumptions/Skipped Items:** Built a pure Dart backend instead of using a heavy framework to keep things lightweight. Used vanilla JS to minimize frontend complexity.
* **Extras Added:** Added a sleek, custom UI theme and basic confirmation prompts before deleting an expense.

## Honesty Policy & AI Usage
In accordance with the assessment guidelines, I utilized Google Gemini as an AI assistant during this project. I used it to help brainstorm the Dart routing structure with `shelf`, troubleshoot a missing SQLite C library on Linux. I fully understand all the code submitted and am prepared to explain the implementation details.
