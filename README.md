# Calculator App (Flutter)

This is a basic calculator application built using Flutter for a technical club induction task. The goal of the project was to create a simple calculator that can perform the main arithmetic operations and manage the app state using Riverpod.

The calculator supports addition, subtraction, multiplication and division. It also allows decimal inputs, percentage calculations, and includes buttons for clearing the entire expression (AC) and deleting the last character. The result updates dynamically as the expression changes, and the app also keeps a small history of recent calculations.

The project is organized into separate folders to keep the code readable. The models folder contains the data model used for storing calculation history. Providers contain the Riverpod state logic that manages the calculator operations. The main user interface is inside the screens folder, while reusable UI components like buttons are placed in widgets. Utility functions for evaluating expressions are kept inside the utils folder.

