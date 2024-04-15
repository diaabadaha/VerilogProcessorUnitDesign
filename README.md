# ENCS3310 Advanced Digital Design Microprocessor Project

## Overview
This repository houses the artifacts of a Verilog-based microprocessor design project for the ENCS3310 - Advanced Digital Design course. It features an Arithmetic Logic Unit (ALU), a register file, and a comprehensive testbench for validating the integrated microprocessor.

## Components
- `advancedProject.v`: Verilog source file that includes the ALU, register file, top module design, and the microprocessor's testbench, ensuring each component functions correctly and interacts as expected within the system.
- `Course-Project_v5.pdf`: Detailed project outline describing the requirements and design process tailored to each student's ID number.
- `Report.pdf`: Detailed report documenting the design rationale, implementation specifics, and testing outcomes for the project.

## Design Features
- Unique ALU and register file designed according to student ID specificities.
- Execution of various arithmetic and logical operations by the ALU.
- Register file acting as a rapid-access memory storage for operands.
- All of them connected with each others to obtain a microprocessor.

## Synchronization and Validation
- Implementation synchronized with clock signals for real-world hardware application.
- In-depth testbench included within the `.v` file to validate the ALU, register file, and their integration into the microprocessor core.

## Project Validation
- A sequence of machine code instructions tests every operation of the ALU.
- Verification of the register file and the microprocessor core integration is executed, with expected results illustrated in the accompanying report.

## Repository Structure
- `advancedProject.v`: The Verilog implementation with a built-in testbench for the microprocessor.
- `Course-Project_v5.pdf` and `Report.pdf`: Project documentation providing comprehensive guidelines and analytical insights.

## How to Use
To run simulations and tests:
1. Load `advancedProject.v` into a Verilog-compatible simulator.
2. Review `Course-Project_v5.pdf` for design specifications tied to student IDs.
3. Consult `Report.pdf` for a detailed narrative on the design and validation process.

## Contributions
- Diaa Badaha - Student Designer and Developer
- Abdellatif Abu-Issa & Elias Khalil - Course Instructors

## Acknowledgments
Gratitude is extended to the course staff and the Engineering Department for their educational support and project supervision.
