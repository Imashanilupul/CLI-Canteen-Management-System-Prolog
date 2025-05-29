# 🍽️ CLI-Canteen Management System (Prolog)

This is a **command-line based Canteen Management System** written in **Prolog**, featuring a simple chatbot-style interface. It allows both **canteen owners** and **customers** to interact with the system efficiently—whether managing the menu or receiving personalized meal recommendations.

---

## 💡 Features

- 👤 **Role-Based Interaction**
  - **Owner**:
    - Add new menu items
    - Delete existing items
  - **Customer**:
    - Get meal recommendations based on preferences
    - Filter menu items by criteria

- 🔍 **Filtering Options**
  - Filter by: `item_name`, `cuisine`, `type`, `meal_type`, or `price`

- 🤖 **Interactive Chatbot**
  - Menu-driven and easy to use
  - Provides step-by-step instructions
  - Flexible command-based usage

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/cli-canteen-system.git
cd cli-canteen-system
```

### 2. Open Prolog Environment

Use SWI-Prolog or any compatible Prolog interpreter to start the environment from your project directory.

```bash
swipl
```

### 3. Load the Rules File

At the Prolog prompt, load the rules:

```prolog
?- consult('rules.pl').
```

### 4. Start the Chatbot

At the Prolog prompt, run:

```prolog
?- start_chatbot.
```



