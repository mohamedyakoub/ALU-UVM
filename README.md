# ALU UVM Environment

This repository contains a **UVM** environment for verifying an ALU design. It includes a complete verification structure with stimulus generation, monitoring, and coverage collection.

## 📌 Project Overview

The **ALU** performs basic arithmetic and logic operations. This UVM environment is designed to thoroughly verify its functionality and ensure compliance with the design specifications.

### Key Features:

- **UVM Components:**
  - Environment
  - Agent
  - Sequencer
  - Driver
  - Monitor
  - Scoreboard
  - Coverage Collector
- **Test Scenarios and Sequences:**
  - Addition, subtraction, and logic operations
  - Randomized stimulus for comprehensive testing

## 📂 Directory Structure

```
├── src/                # ALU RTL and SystemVerilog Files
├── tb/                 # UVM Testbench
│    ├── env/           # UVM Environment
│    ├── agent/         # Driver, Monitor, Sequencer
│    ├── tests/         # Test Cases
│    └── sequences/     # Sequences
└── README.md           # Project Documentation
```

## 🚀 How to Run the Simulation

### Prerequisites

Ensure you have one of the following simulators installed:

- **QuestaSim**
- **VCS (Synopsys)**

### Running 

1. Questasim :
  There is a run.do file that can be used by using do in questasim transcript
```
      do run.do 
```
1. Synopsys tools :
  There is a make file that can be used.


## ✅ Verification Plan

1. **Functional Testing:** Verify all ALU operations (e.g., add, subtract, AND, OR).
2. **Corner Cases:** Ensure correct handling of important conditions (e.g., overflow, underflow).
3. **Random Stimulus:** Randomized operand generation for robust testing.

## 📊 Coverage

The UVM environment collects both **functional** and **code** coverage. The coverage report is generated after the simulation completes.

## 📜 License

This project is licensed under the MIT License. Feel free to use and modify it.

## 📧 Contact

For questions or contributions, feel free to reach out!

```
Mohamed Yakoub
Email: mohamedyakoub92001@gmail.com
```

