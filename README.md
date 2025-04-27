# 🎬 PayMob-Task
![simulator_screenshot_85BBCB29-6017-4DE2-906D-0D9D70ACA83A](https://github.com/user-attachments/assets/10cafb26-b488-4516-89fe-bb32f5fde5eb)

## 📋 Requirements

- iOS 13.0+
- Xcode 16.1+
- Swift 5.6+

## 🚀 Installation

To get started by cloning the repository:

```bash
git clone https://github.com/Mostafa10399/Movie-Task
```

## 🛠 Stack & Architecture

- Swift 5
- UIKit
- Swift Package Manager (SPM) — [Learn More](https://swift.org/package-manager/)
- MVVM (Model-View-ViewModel) Architecture
- Combine and CombineCocoa for reactive programming
- Dependency Injection for better testability and modularity
- Repository Design Pattern for clean and scalable data handling
- Codable for seamless JSON parsing
- Alamofire for efficient network requests
- SnapKit for programmatic UI layout
- Modularization for better project organization
- Flavors to support multiple build configurations (e.g., Staging, Production)

## 🧩 Project Structure

The project is modularized into two main frameworks to ensure scalability, maintainability, and code separation:

### 1. CoreKit
- Handles all business logic and network operations.
- Responsible for:
  - API requests and responses.
  - Models and data parsing.
  - Business use cases and repositories.

### 2. AppUIKit
- Contains common components and shared UI utilities.
- Includes:
  - Reusable UI elements (e.g., buttons, labels, custom views).
  - Extensions, helpers, and other shared tasks that are UI-related.

## 📦 Modularization & Flavors

The project is structured to support multiple targets and build configurations using Flavors, making it easy to manage environments like Development, Staging, and Production.
