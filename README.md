# Quantova - Personal Finance MVP

Quantova is a minimalist, high-performance personal finance application designed to help users track their income and expenses with ease. Built with Flutter, it focuses on essential features to provide immediate value without unnecessary complexity.

## 🚀 Features (MVP)

*   **Quick Transaction Entry:** Log income and expenses in seconds.
*   **Smart Receipt Scanning:** Automatically extract total amount and merchant name from receipts using on-device OCR (ML Kit).
*   **Interactive Dashboard:**
    *   **Dual-Line Chart:** Visualize income vs. expenses trends with a sleek, minimalist line chart.
    *   **Monthly Filtering:** Navigate through months to see historical data.
    *   **Savings Indicators:** Track both your "Global Savings" (all-time) and "Period Savings" (current month) at a glance.
*   **Comprehensive Reports:**
    *   **Category Breakdown:** See exactly where your money goes.
    *   **Monthly Trends:** Analyze your financial progress over time.
    *   **Expense Distribution:** Visual pie charts for better understanding.
*   **Dark Mode:** A beautiful, eye-friendly dark theme that activates automatically or manually.
*   **Privacy First:** All data is stored locally on your device using SQLite. No internet connection required for core functionality.

## 🛠️ Architecture

Quantova is built using **Clean Architecture** principles and the **BLoC (Business Logic Component)** pattern, ensuring:
*   **Scalability:** Ready to grow from a personal tool to a more complex system.
*   **Testability:** Business logic is separated from UI code.
*   **Maintainability:** Clear separation of concerns (Domain, Data, Presentation layers).

## 🔮 Future Roadmap (Potential)

While currently a personal tool, the architecture supports expansion into:
*   **Multi-User Support:** Roles for admins, accountants, and family members.
*   **Cloud Sync:** Optional backup and real-time sync across devices.
*   **Advanced Exporting:** Generate professional PDF/Excel reports for accounting.
*   **Budgeting:** Set limits for specific categories.

## 🏁 Getting Started

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/KarmaBlank/quantova.git
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the app:**
    ```bash
    flutter run
    ```

## 📱 Release

The latest release APK can be found in the `releases` section or built manually using:
```bash
flutter build apk --release
```
