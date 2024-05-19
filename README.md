# aos Packages 

Welcome to the aos packages repo! This project contains a collection of lua modules designed to help build aos (Actor-Oriented) processes or agents. Our goal is to provide a set of reusable modules that make it easier for developers to create robust and scalable aos solutions.

## Table of Contents 📚

- [Repository Structure 🗂️](#repository-structure)
- [Modules 🧩](#modules)
  - [Test Unit Module 🧪](#test-unit-module)
  - [dbAdmin Module 🛠️](#dbadmin-module)
  - [Other Modules 🔧](#other-modules)
- [Getting Started 🚀](#getting-started)
- [Contributing 🤝](#contributing)
- [License 📄](#license)
- [Contact 📬](#contact)

## Repository Structure 🗂️

This repository is organized as a monorepo, with each module located in the `packages` folder. The structure is as follows:

```
aos-modules/
│
├── packages/
│   ├── test-unit/
│   ├── db-admin/
│   ├── [other-modules]/
│
├── README.md
├── LICENSE
└── .gitignore
```

## Modules 🧩

### Test Unit Module 🧪

The Test Unit Module provides tools for creating and running unit tests for your AOS processes. It includes:

- **Assertions**: Functions to check the correctness of your code.
- **Test Runner**: A simple framework to execute tests and report results.

### dbAdmin Module 🛠️

The dbAdmin Module offers functionalities for managing SQLite databases, including:

- **List Tables**: Retrieve a list of tables in the database.
- **Get Record Count**: Get the number of records in a specified table.
- **Execute Queries**: Run custom SQL queries against the database.

### [Other Modules] 🔧

(Description of other modules you plan to include)

## Getting Started 🚀

To get started with the AOS Modules, follow these steps:

1. **Clone the Repository**:
    ```sh
    git clone https://github.com/yourusername/aos-modules.git
    ```

2. **Navigate to the Packages Folder**:
    ```sh
    cd aos-modules/packages
    ```

3. **Install Dependencies**:
    Each module might have its own dependencies. Check the `README` file within each module's folder for specific instructions.

4. **Run Tests**:
    Navigate to the `test-unit` module and run the tests to ensure everything is set up correctly.
    ```sh
    cd test-unit
    lua run_tests.lua
    ```

## Contributing 🤝

We welcome contributions from the community! To contribute:

1. Fork the repository.
2. Create a new branch for your feature or bugfix.
3. Make your changes and commit them with clear messages.
4. Open a pull request to the `main` branch.

Please ensure your code follows our coding standards and includes tests for any new functionality.

## License 📄

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Contact 📬

If you have any questions or need further assistance, feel free to open an issue or contact us at [your-email@example.com].

---

Feel free to adjust as necessary!