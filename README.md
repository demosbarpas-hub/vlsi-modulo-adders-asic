# Custom Modulo Adders & ASIC Physical Design Flow

## Overview
This repository contains the RTL design, verification, and physical implementation of high-performance N-bit adders. The hardware is explicitly optimized with custom logic trees to calculate the remainder for specific moduli: Modulo 5, 9, 14, and 15 (including a Modulo 7 sub-block). 

By utilizing targeted hierarchical dataflow approaches rather than generic division logic, the architectures achieve highly efficient remainder calculations. This project encompasses a complete digital ASIC design flow, from VHDL RTL architecture to gate-level synthesis, Place & Route (P&R), and formal verification using industry-standard Cadence EDA tools.

**Authors:** Demosthenes Karamparpas, Grigorios Risvas  
**Course:** Integrated Circuits Design Lab 2 (VLSI 2), University of Patras

## Hardware Architecture
* **Custom Modulo Trees:** Implemented custom multi-stage remainder-calculating logic using internal adders, padding, and intermediate multiplexing arrays.
* **Dedicated Comparators:** Designed parallel comparator units (e.g., `comparator_of_5`, `comparator_of_9`, `comparator_of_15`) to dictate arithmetic adjustments dynamically.
* **Register Staging:** Wrapped the combinational modulo logic with input and output D-Flip-Flop (`qd`) registers (`mod_flip_flop`) to properly analyze critical path timing and setup/hold constraints during physical design.

## ASIC Implementation Flow & Tech Stack
The designs were synthesized and routed across multiple technology nodes to analyze area, power, and timing.

* **Hardware Description Language:** VHDL
* **Logic Synthesis (Cadence Genus):** Synthesized the RTL targeting both 45nm and 7nm (ASAP7) standard cell libraries, generating detailed power, area, and timing reports.
* **Place & Route (Cadence Innovus):** Executed the physical layout, floorplanning, and routing for the 45nm designs.
* **Formal Verification (Cadence LEC):** Performed Logic Equivalence Checking between the RTL and the synthesized gate-level netlists, achieving 100% equivalence (Compare Results: PASS) across all adder variations.
* **Simulation (Cadence Xcelium):** Verified functional correctness via testbenches simulating extreme boundary conditions and negative number handling.

## Directory Structure
* `mod5/`, `mod9/`, `mod14/`, `mod15/` - Dedicated directories for each modulo hardware architecture. Each contains:
  * `VHDL code/` - Original RTL VHDL source files (`.vhd`).
  * `*.sdc` - Synopsys Design Constraints.
  * `*.v` - Synthesized gate-level Verilog netlist (from Cadence Genus).
  * `*.sdf` - Standard Delay Format file for precise timing analysis.
  * `tb.v` - Verilog testbench for post-synthesis simulation.
* `Technical_Report_VLSI_2.pdf` - Full project documentation, logic schematics, and area/power/timing reports.
* `Project_Presentation.pptx` - Summary presentation slide deck.
