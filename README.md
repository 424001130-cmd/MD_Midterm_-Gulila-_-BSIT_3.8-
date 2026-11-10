# Community Learning Center Management System

## General Information
- **Course Title:** Mobile Development
- **Assessment:** Midterm Laboratory Examination
- **Student Name:** [Gulila, Lance Andrei A.]
- **Section:** [BSIT 3.8]

---

## Application Overview
The **Community Learning Center Management System** is an integrated Dart console application designed to register educational resources and participants, manage borrow and return transactions, track inventory copies, and output formatted records. The program demonstrates core object-oriented programming (OOP) principles, clean input validation, and structured console output.

---

## Implemented Features & Architecture

### 1. Program Setup, Variables & Input/Output
- **Interactive Menu:** Loop-driven console UI allowing users to select actions (Add Resource, Register Participant, View Records, Borrow Resource, Return Resource, Exit).
- **Console Validation:** Centralized input functions (`getInput` and `getInteger`) with error handling to enforce non-negative integers and prevent empty inputs.

### 2. Object-Oriented Design (OOP)
- **Abstraction:** `CenterRecord` serves as an abstract parent class declaring shared fields (`id`, `name`) and the abstract `displayDetails()` method.
- **Inheritance:** `LearningResource` and `Participant` inherit from `CenterRecord` and implement their own versions of `displayDetails()`.
- **Encapsulation:** Private properties (`_category`, `_availableCopies`, `_email`, `_borrowedResources`) controlled via getters and public methods (`borrowResource()`, `returnResource()`, `borrowItem()`, `returnItem()`).
- **Polymorphism:** View action combines records (`[...resourceMap.values, ...participantMap.values]`) into a `CenterRecord` context and dynamically invokes `displayDetails()`.
- **Mixin:** `TimestampMixin` provides reusable datetime tracking (`dateCreated`) across all entities.

### 3. Data Storage & Management
- **Key-Value Lookup:** Uses `Map<int, LearningResource>` and `Map<int, Participant>` for $O(1)$ fast record retrieval and duplicate ID prevention.
- **Transaction Engine:** Unified `processTransaction(bool isBorrow)` helper handling both borrow and return operations safely.

---

## Sample Test Scenarios

* **Scenario 1: Successful Registration & Borrow Transaction**
  1. Select Option `1` -> Register Resource (ID: `101`, Title: `Dart Basics`, Category: `Books`, Copies: `3`).
  2. Select Option `2` -> Register Participant (ID: `201`, Name: `Jane Doe`, Email: `jane@example.com`).
  3. Select Option `4` -> Borrow Resource (Participant ID: `201`, Resource ID: `101`).
  4. **Expected Output:** Success message displayed; Resource copies decrease to `2`, Participant active borrows increase to `1`.

* **Scenario 2: Invalid Input Handling (Error Prevention)**
  1. Select Option `1` -> Register Resource (ID: `102`).
  2. Enter string text (`abc`) when prompted for Available Copies.
  3. **Expected Output:** System displays `[!] Input Error: Please enter a valid non-negative integer.` and prompts again without crashing.

* **Scenario 3: Out-of-Stock Borrow Attempt**
  1. Attempt to borrow a resource with `0` available copies.
  2. **Expected Output:** Displays `[!] Transaction Failed: No available copies left.` and leaves record quantities unchanged.

---

## Instructions for Running the Application

1. **Prerequisites:** Ensure the Dart SDK is installed or open [onlinegdb](https://onlinegdb.com).
2. **Setup:** Place `main.dart` in your workspace directory.
3. **Execution:** Run the following command in your terminal:
   ```bash
   dart run main.dart
