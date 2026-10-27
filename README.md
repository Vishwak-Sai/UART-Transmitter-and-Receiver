# UART Transmitter and Receiver Verification Using SystemVerilog and UVM

## 1. Project Overview

This project focuses on designing and verifying a Universal Asynchronous Receiver/Transmitter (UART) system consisting of a transmitter (TX) and a receiver (RX). The transmitter converts 8-bit parallel data into serial data, while the receiver converts the incoming serial stream back into parallel data.

A Universal Verification Methodology (UVM)-based testbench is developed using SystemVerilog to generate stimulus, observe signal activity, and verify the functionality of the UART design. Simulation waveforms are analyzed using Siemens QuestaSim and EPWave through EDA Playground.

## 2. Objectives

- Design RTL modules for UART transmission and reception.
- Develop a reusable UVM testbench using transaction-based stimulus generation.
- Verify data transmission, reception, and UART frame timing.
- Analyze simulation waveforms to identify functional issues.
- Establish a foundation for testing baud rate accuracy, parity errors, and framing errors.

## 3. System Architecture

The project consists of the following components:

- **UART Transmitter (`uart_tx`):** Converts 8-bit parallel input data into a serial data stream.
- **UART Receiver (`uart_rx`):** Samples serial input data and reconstructs the corresponding parallel byte.
- **UART Interface (`uart_if`):** Connects the DUT signals with the UVM testbench.
- **Transaction (`uart_txn`):** Represents a data transaction to be transmitted.
- **Sequence (`uart_seq`):** Generates test transactions.
- **Driver (`uart_driver`):** Converts transactions into DUT input stimulus.
- **Monitor (`uart_monitor`):** Observes receiver outputs and reports received data.
- **Agent (`uart_agent`):** Groups the sequencer, driver, and monitor.
- **Environment (`uart_env`):** Organizes the verification components.
- **Test (`uart_test`):** Starts sequences and controls the simulation.

### Block Diagram

```text
              UVM Test
                  |
             UART Environment
                  |
              UART Agent
          +-------+-------+
          |       |       |
      Sequencer Driver  Monitor
                  |       ^
                  v       |
             UART Interface
                  |
          +-------+-------+
          |               |
      UART TX          UART RX
          |               ^
          +---- Loopback --+
```

## 4. Technologies and Tools

- **Hardware Description Language:** SystemVerilog
- **Verification Methodology:** UVM 1.2
- **Simulator:** Siemens QuestaSim
- **Online Simulation Platform:** EDA Playground
- **Waveform Viewer:** EPWave
- **Version Control:** Git and GitHub

## 5. Input and Output Signals

| Signal | Width | Description |
|---|---:|---|
| `clk` | 1 bit | System clock |
| `rst_n` | 1 bit | Active-low reset |
| `tx_start` | 1 bit | Initiates transmission |
| `tx_data` | 8 bits | Parallel transmit data |
| `txd` | 1 bit | Serial transmitter output |
| `rxd` | 1 bit | Serial receiver input |
| `rx_data` | 8 bits | Reconstructed received data |
| `rx_valid` | 1 bit | Indicates valid received data |

The exact signals depend on the RTL implementation. Optional signals such as `tx_busy` and `framing_error` can be added when supported by the design.

## 6. Verification Methodology

The UVM testbench follows a layered architecture:

1. Generate transactions containing test data.
2. Send transactions from the sequence to the driver through the sequencer.
3. Drive the DUT inputs through the virtual interface.
4. Connect the transmitter output to the receiver input for loopback testing.
5. Monitor receiver activity and received data.
6. Compare expected and actual results using a scoreboard when implemented.
7. Inspect simulation waveforms to validate signal transitions and timing.

### Planned Test Scenarios

- Basic data transmission and reception.
- Different data patterns, including `0x00`, `0x55`, `0xA5`, and `0xFF`.
- Back-to-back data transmission.
- Baud rate and frame timing verification.
- Parity error detection.
- Invalid stop-bit and framing error detection.

**Note:** Parity and framing error scenarios require the corresponding functionality to be implemented in the RTL and testbench before they can be considered verified.

## 7. Simulation and Waveform Analysis

The design and testbench are simulated using QuestaSim on EDA Playground. EPWave is used to inspect the following signals:

- Clock and reset.
- Transmit start and transmit data.
- Serial TX and RX signals.
- Received parallel data.
- Receive-valid indication.

The waveform is used to examine the sequence of events during transmission and reception and to debug functional or timing issues.

## 8. Expected Results

The expected outcome is a functioning UART TX/RX design with a reusable UVM verification environment. Successful basic loopback tests should demonstrate correct recovery of transmitted data, while waveform analysis should show clock activity, reset release, serial frame transitions, and receiver-valid indications.

Verification results should be confirmed through simulation logs and signal comparisons rather than waveform activity alone.

## 9. Project Structure

```text
UART-UVM-Verification/
├── design.sv
├── testbench.sv
├── uart_if.sv
├── uart_txn.sv
├── uart_seq.sv
├── uart_driver.sv
├── uart_monitor.sv
├── uart_agent.sv
├── uart_env.sv
├── uart_test.sv
├── run.do
└── README.md
```

The file organization may vary depending on the compilation setup. Ensure each UVM class is compiled exactly once and that the top-level testbench instantiates the RTL design.

## 10. Applications

UART is commonly used in:

- Microcontroller-to-peripheral communication.
- Embedded systems and debugging interfaces.
- Serial communication between development boards.
- FPGA and ASIC verification exercises.
- Hardware bring-up and diagnostic interfaces.

## 11. Future Enhancements

- Implement configurable baud rate generation.
- Add even and odd parity support.
- Detect parity and framing errors.
- Add a UVM scoreboard and functional coverage.
- Develop constrained-random and error-injection sequences.
- Run regression tests across multiple configurations.

## 12. Author
 Vishwak Sai
**Project:** UART Transmitter and Receiver Verification Using SystemVerilog and UVM

**Domain:** VLSI Design and Functional Verification

**Tools:** SystemVerilog, UVM 1.2, QuestaSim, EDA Playground

---

*This project demonstrates RTL integration, UVM testbench development, simulation-based verification, and waveform debugging for a serial communication protocol.*
