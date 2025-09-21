# Minecraft ComputerCraft Automation

This workspace contains ComputerCraft programs used to monitor and control a modded Minecraft base (reactor, power, refinery, pumps, and turtles). Scripts are organized per computer ID in the `computer/` folder and reusable scripts on `disk/1/scripts/`. Most programs use peripherals via `peripheral.wrap` and use `rednet` for telemetry.

## Quick start

- Each in-world Computer runs its `startup.lua` under its folder (e.g. [computer/15/startup.lua](computer/15/startup.lua)). Start the computer in-game and the startup script will launch the controllers and monitors defined there.
- Background services are launched with `shell.run("bg ...")` from the startup scripts.
- Use `rednet.open(...)` on the proper side for wireless/monitoring messages, see each file for details.

## Key scripts and what they do

- Reactor control and monitoring
  - Controller: [computer/15/reactor-controller.lua](computer/15/reactor-controller.lua) — core reactor control loop (scram, coolant, burn rate adjustments).
  - Local monitor: [computer/15/reactor-monitor.lua](computer/15/reactor-monitor.lua) — local monitor display for reactor stats.
  - Wireless transmitter: [computer/15/reactor-mon-wireless.lua](computer/15/reactor-mon-wireless.lua) — sends reactor telemetry via `rednet` to tablets/monitors.

- Power dashboard and monitors
  - Dashboard: [computer/13/power-monitor.lua](computer/13/power-monitor.lua) and [computer/13/dashboard.lua](computer/13/dashboard.lua) — aggregate power and refinery displays.
  - Tablet displays: [computer/14/power.lua](computer/14/power.lua) and [computer/7/power.lua](computer/7/power.lua) — small power monitors listening on `rednet`.

- Refinery and pumps
  - Water pump controller (in-computer): [computer/13/controllers/water-pump-controller.lua](computer/13/controllers/water-pump-controller.lua).
  - Generator controller: [computer/13/controllers/generator-controller.lua](computer/13/controllers/generator-controller.lua).
  - Disk-stored pump script (alternate): [disk/1/scripts/water-pump-controller.lua](disk/1/scripts/water-pump-controller.lua).

- Turtle automation
  - High-level miner: [computer/8/mine.lua](computer/8/mine.lua) — mining logic, uses helper functions: [`refuel`](computer/8/mine.lua), [`unload`](computer/8/mine.lua), and [`mine_layer`](computer/8/mine.lua).
  - Autopilot module: [computer/8/autopilot.lua](computer/8/autopilot.lua) — provides movement helpers such as [`ap_module.getDirection`](computer/8/autopilot.lua), [`ap_module.go_to`](computer/8/autopilot.lua), and [`ap_module.face`](computer/8/autopilot.lua).

- Utilities and inspection
  - Peripheral checkers: [computer/15/check-peripherals.lua](computer/15/check-peripherals.lua) and [computer/13/check-peripherals.lua](computer/13/check-peripherals.lua).
  - Inventory readers and monitors under various computers: e.g. [computer/6/startup/read-inventory](computer/6/startup/read-inventory) and [disk/1/scripts/read-inventory](disk/1/scripts/read-inventory).
  - Fluid readers/inspectors: [disk/1/scripts/read_fluids](disk/1/scripts/read_fluids) and [disk/1/scripts/inspect-peripheral.lua](disk/1/scripts/inspect-peripheral.lua).

## How the reactor controller decides burn rate

The controller running in [computer/15/reactor-controller.lua](computer/15/reactor-controller.lua) reads energy stats from an induction port (`inductionPort_0`) and adjusts burn rate based on capacitor charge and input/output rates. It also performs safety scram on coolant or temperature thresholds.

## File layout

Top-level important folders:
- `computer/` — per-computer programs (organized by ID). Example: [computer/15/reactor-controller.lua](computer/15/reactor-controller.lua)
- `disk/1/scripts/` — reusable scripts that can be run from disks. Example: [disk/1/scripts/water-pump-controller.lua](disk/1/scripts/water-pump-controller.lua)
- `ids.json` — peripheral and computer ID mapping: [ids.json](ids.json)

## Running and troubleshooting

- Start computers in-game or run the relevant `startup.lua` (e.g. `shell.run("startup.lua")`) on the target machine.
- Use the provided check scripts to inspect peripherals and methods:
  - [computer/15/check-methods.lua](computer/15/check-methods.lua)
  - [computer/15/check-peripherals.lua](computer/15/check-peripherals.lua)
  - For detailed peripheral method lists: `peripheral.getMethods(...)` inside those scripts.

## Extending

- Add more telemetry listeners by subscribing to `rednet` messages on the appropriate channel (see [computer/14/reactor.lua](computer/14/reactor.lua) and [computer/7/reactor.lua](computer/7/reactor.lua)).
- Reuse the autopilot functions in [computer/8/autopilot.lua](computer/8/autopilot.lua) for new turtle tasks via [`ap_module.go_to`](computer/8/autopilot.lua) and friends.

## License and notes

This README documents local automation scripts for a private Minecraft server. Edit the startup scripts in each `computer/<id>/` folder to customize what runs on boot.

Relevant files:
- [computer/15/reactor-controller.lua](computer/15/reactor-controller.lua)
- [computer/15/reactor-monitor.lua](computer/15/reactor-monitor.lua)
- [computer/15/reactor-mon-wireless.lua](computer/15/reactor-mon-wireless.lua)
- [computer/13/controllers/water-pump-controller.lua](computer/13/controllers/water-pump-controller.lua)
- [computer/13/controllers/generator-controller.lua](computer/13/controllers/generator-controller.lua)
- [computer/13/power-monitor.lua](computer/13/power-monitor.lua)
- [computer/8/autopilot.lua](computer/8/autopilot.lua)
- [computer/8/mine.lua](computer/8/mine.lua)
