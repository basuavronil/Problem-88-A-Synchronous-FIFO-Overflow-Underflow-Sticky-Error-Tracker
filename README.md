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

## Port Descriptions

| Port Name | Direction | Data Type | Width | Description |
| :--- | :--- | :--- | :--- | :--- |
| `clk` | Input | `wire` | 1 bit | System clock (shared by write and read logic). |
| `rst_n` | Input | `wire` | 1 bit | Asynchronous active-low hardware reset. |
| `full` | Input | `wire` | 1 bit | Status flag indicating the FIFO is full. |
| `empty` | Input | `wire` | 1 bit | Status flag indicating the FIFO is empty. |
| `wr_en` | Input | `wire` | 1 bit | Write enable pulse from producer logic. |
| `rd_en` | Input | `wire` | 1 bit | Read enable pulse from consumer logic. |
| `sw_clr_err` | Input | `wire` | 1 bit | Software clear signal to reset the latched `sticky_error`. |
| `overflow_err` | Output | `wire` | 1 bit | Combinational/transient overflow pulse (active high). |
| `underflow_err` | Output | `wire` | 1 bit | Combinational/transient underflow pulse (active high). |
| `sticky_error` | Output | `reg` | 1 bit | Latched error flag; remains `1` after an error until cleared. |

---

