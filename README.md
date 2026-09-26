# Problem-88.-FIFO-Overflow-Underflow-Sticky-Error-Tracker
# FIFO Overflow/Underflow Sticky Error Tracker

This repository contains a Verilog implementation and testbench for a **Synchronous FIFO Overflow/Underflow Sticky Error Tracker**.

> **Note on Architecture:**  
> This module is specifically designed for **Synchronous FIFOs** operating on a single clock domain (`clk`). It acts as a lightweight status monitor alongside the FIFO logic. Data signals (`din`, `dout`) are deliberately omitted as error detection depends strictly on control flags (`full`, `empty`) and enable signals (`wr_en`, `rd_en`).

---

## Features

- **Overflow Detection:** Detects illegal write attempts when the FIFO is full (`wr_en & full`).
- **Underflow Detection:** Detects illegal read attempts when the FIFO is empty (`rd_en & empty`).
- **Sticky Latching:** Latches any detected fault into a `sticky_error` bit that remains high (`1`) until cleared by software.
- **Software Reset:** Provides an explicit software clear (`sw_clr_err`) port to reset the latched error without resetting the entire FIFO hardware.

---

### Interface Ports and Registers

#### Top-Level Ports

| Port Name | Direction | Width | Description |
| :--- | :--- | :--- | :--- |
| `clk` | Input | 1 bit | System Clock |
| `rst_n` | Input | 1 bit | Active-Low Asynchronous Hardware Reset |
| `full` | Input | 1 bit | FIFO Full status flag |
| `empty` | Input | 1 bit | FIFO Empty status flag |
| `wr_en` | Input | 1 bit | Write Enable control signal |
| `rd_en` | Input | 1 bit | Read Enable control signal |
| `sw_clr_err` | Input | 1 bit | Software Clear signal (resets sticky bit) |
| `overflow_err` | Output | 1 bit | Current/transient overflow pulse |
| `underflow_err` | Output | 1 bit | Current/transient underflow pulse |
| `sticky_error` | Output | 1 bit | Latched error flag indicating an overflow/underflow occurred |

---

