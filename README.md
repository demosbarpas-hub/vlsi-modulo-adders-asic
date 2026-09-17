# Custom Modulo Adders & ASIC Physical Design Flow

## Overview
This repository contains the RTL design, verification, and physical implementation of high-performance N-bit adders[cite: 2]. The hardware is explicitly optimized with custom logic trees to calculate the remainder for specific moduli: Modulo 5, 9, 14, and 15 (including a Modulo 7 sub-block)[cite: 2]. 

By utilizing targeted hierarchical dataflow approaches rather than generic division logic, the architectures achieve highly efficient remainder calculations[cite: 2]. This project encompasses a complete digital ASIC design flow, from VHDL RTL architecture to gate-level synthesis, Place & Route (P&R), and formal verification using industry-standard Cadence EDA tools[cite: 2].

**Authors:** Demosthenes Karamparpas, Grigorios Risvas[cite: 2]  
**Course:** Integrated Circuits Design Lab 2 (VLSI 2), University of Patras[cite: 2]

## Hardware Architecture
* **Custom Modulo Trees:** Implemented custom multi-stage remainder-calculating logic using internal adders, padding, and intermediate multiplexing arrays[cite: 2].
* **Dedicated Comparators:** Designed parallel comparator units (e.g., `comparator_of_5`, `comparator_of_9`, `comparator_of_15`) to dictate arithmetic adjustments dynamically[cite: 2].
* **Register Staging:** Wrapped the combinational modulo logic with input and output D-Flip-Flop (`qd`) registers (`mod_flip_flop`) to properly analyze critical path timing and setup/hold constraints during physical design[cite: 2].

## ASIC Implementation Flow & Tech Stack
The designs were synthesized and routed across multiple technology nodes to analyze area, power, and timing[cite: 2].

* **Hardware Description Language:** VHDL[cite: 2]
* **Logic Synthesis (Cadence Genus):** Synthesized the RTL targeting both 45nm and 7nm (ASAP7) standard cell libraries, generating detailed power, area, and timing reports[cite: 2].
* **Place & Route (Cadence Innovus):** Executed the physical layout, floorplanning, and routing for the 45nm designs[cite: 2].
* **Formal Verification (Cadence LEC):** Performed Logic Equivalence Checking between the RTL and the synthesized gate-level netlists, achieving 100% equivalence (Compare Results: PASS) across all adder variations[cite: 2].
* **Simulation (Cadence Xcelium):** Verified functional correctness via testbenches simulating extreme boundary conditions and negative number handling[cite: 2].

## Directory Structure
* `src/` - VHDL source code (Adders, Comparators, Remainder Calculators, Top-Level Modulo modules)
* `tb/` - VHDL Testbenches and Xcelium simulation waveforms
* `synthesis/` - Cadence Genus reports (timing, area, power) for 45nm and 7nm runs
* `layout/` - Cadence Innovus physical design screenshots and physical netlists
