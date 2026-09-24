# Orange OS

Orange OS is an experimental, CLI-first operating-system distribution built on top of xnu++.

It provides a minimal userspace, system management tools, package management, service management, configuration, and a foundation for future desktop and application support.

Orange OS is designed as a distribution layer, while xnu++ provides the underlying kernel and platform architecture.

---

Overview

Orange OS is being developed as a lightweight and modular operating-system distribution.

The project separates the operating-system platform from the distribution:
```
┌─────────────────────────────────────┐
│             Applications            │
├─────────────────────────────────────┤
│          Desktop / CLI              │
├─────────────────────────────────────┤
│             Orange OS               │
│                                     │
│  init · packages · services · CLI   │
│  configuration · userspace          │
├─────────────────────────────────────┤
│               xnu++                 │
│       Kernel / Platform Layer       │
├─────────────────────────────────────┤
│       XNU / Mach / BSD / IOKit      │
├─────────────────────────────────────┤
│              Hardware               │
└─────────────────────────────────────┘
```
Orange OS does not contain a second kernel.

It is intended to run on top of xnu++.

---

Project Goals

Orange OS aims to provide:

- A minimal operating-system userspace.
- A CLI-first environment.
- A modular system-management architecture.
- Package management.
- Service management.
- System configuration.
- A native initialization system.
- A reproducible build environment.
- Support for multiple architectures.
- A foundation for desktop environments.
- A foundation for application development.
- A distribution that can evolve independently from the underlying platform.

The project is intentionally being developed incrementally.

---

Relationship With xnu++

Orange OS depends conceptually on xnu++ as its underlying platform.

The separation is:
```
xnu++
│
├── Kernel
├── Boot infrastructure
├── Memory management
├── Interrupt infrastructure
├── Device/platform interfaces
├── Security architecture
└── Recovery infrastructure
        │
        ▼
Orange OS
│
├── init
├── CLI
├── package management
├── service management
├── configuration
├── userspace
└── desktop integration
```
This separation allows xnu++ to remain a platform while Orange OS evolves as a distribution.

---

Current Status

Orange OS is currently an experimental development distribution.

The current project contains:

- i386 userspace build.
- x86-64 userspace build.
- Freestanding Orange initialization program.
- Root filesystem layout.
- Orange CLI.
- Configuration system.
- Package-management prototype.
- Service-management prototype.
- Development ISO generation.
- Limine boot integration.
- xnu++ kernel integration path.
- QEMU development workflow.

Many components are still prototypes.

Orange OS should not currently be considered a production operating system.

---

Architecture

The current architecture is:

                    Orange OS
                         │
        ┌────────────────┼────────────────┐
        │                │                │
       CLI          Package System    Service System
        │                │                │
        └────────────────┼────────────────┘
                         │
                       init
                         │
                         ▼
                       xnu++
                         │
             ┌───────────┼───────────┐
             │           │           │
            CPU        Memory      Devices
             │           │           │
             └───────────┼───────────┘
                         │
                XNU / Mach / BSD /
                       IOKit

The architecture is designed to allow additional userspace components to be added without modifying the distribution's fundamental structure.

---

Userspace

The current Orange OS initialization program is located at:

userspace/init.c

It is compiled as a freestanding ELF executable.

Two architecture-specific builds are currently maintained:

build/orange_init.elf
build64/orange_init.elf

The resulting binaries are:

build/orange_init.elf
    ELF 32-bit i386

build64/orange_init.elf
    ELF 64-bit x86-64

The initialization program currently provides early Orange OS userspace bring-up.

The long-term goal is to evolve it into a complete initialization and system-supervision environment.

---

Initialization

The intended boot flow is:
```
Firmware
   │
   ▼
Limine
   │
   ▼
Multiboot2
   │
   ▼
xnu++
   │
   ▼
Orange OS init
   │
   ▼
System services
   │
   ▼
Orange userspace
```
The current development ISO also places the Orange initialization ELF alongside the xnu++ kernel:
```
/boot/
├── xnuxx.elf
└── orange_init.elf
```
This establishes the foundation for the userspace handoff mechanism.

---

CLI

Orange OS provides the "orange" command as its primary system-management interface.

The command is located at:

bin/orange

The root filesystem contains:

rootfs/bin/orange

The CLI is intended to provide a consistent interface for system administration.

Basic command groups include:
```
orange init
orange system
orange package
orange service
orange version
orange help
```
---

Package Management

Orange OS includes an early package-management system.

Package state is stored under:

/var/lib/orange/

The package root is:

/var/lib/orange/packages

The package database is:

/var/lib/orange/packages.db

The current CLI supports the basic package-management operations:
```
orange package list
orange package search
orange package install
orange package remove
orange package info
orange package update
```
The current implementation is a prototype.

Future package-management work includes:

- Dependency resolution.
- Package repositories.
- Package metadata.
- Version management.
- Package signatures.
- Integrity verification.
- Transaction handling.
- Atomic upgrades.
- Rollback.
- Offline package repositories.

---

Service Management

Orange OS includes an early service-management architecture.

Service definitions are stored under:

/etc/orange/services

Service state is stored under:

/var/lib/orange/services

The current service interface includes:
```
orange service list
orange service enable
orange service disable
orange service start
orange service stop
orange service status
```
Service definitions contain information such as:

NAME
DESCRIPTION
COMMAND

The current implementation is experimental.

A future native service supervisor will replace the early prototype.

---

Configuration

The main Orange OS configuration file is:

/etc/orange.conf

The current configuration includes:

NAME="Orange OS"
VERSION="0.2.0"
PLATFORM="xnu++"
MODE="cli"

PREFIX="/usr/local"

STATE_ROOT="/var/lib/orange"
PACKAGE_ROOT="/var/lib/orange/packages"
PACKAGE_DB="/var/lib/orange/packages.db"
LOG_ROOT="/var/log/orange"

SERVICE_ROOT="/etc/orange/services"
SERVICE_STATE="/var/lib/orange/services"

DESKTOP="kde-plasma"
DISPLAY_SERVER="wayland"

The configuration system is intended to keep distribution policy separate from the underlying xnu++ platform.

---

Root Filesystem

The current root filesystem layout is:
```
rootfs/
├── bin/
│   ├── init
│   └── orange
│
├── dev/
├── etc/
│   ├── init.conf
│   ├── orange.conf
│   └── os-release
│
├── home/
├── proc/
├── root/
├── run/
├── sys/
├── tmp/
│
├── usr/
│   ├── bin/
│   └── lib/
│
└── var/
    ├── lib/
    │   └── orange/
    └── log/
```
This follows a conventional Unix-style filesystem organization while keeping Orange OS-specific state under "/var/lib/orange".

---

System Identity

Orange OS currently identifies itself using:

Name: Orange OS
Platform: xnu++
Architecture: i386 / x86-64
Userspace: Orange

The release information is stored in:

/etc/os-release

The initialization configuration is stored in:

/etc/init.conf

---

Desktop Support

Orange OS is designed to support desktop environments as userspace components.

The current target desktop is:

KDE Plasma

The configuration currently specifies:

DESKTOP="kde-plasma"
DISPLAY_SERVER="wayland"

The intended architecture is:
```
xnu++
   │
   ▼
Orange OS
   │
   ▼
Userspace
   │
   ▼
Wayland
   │
   ▼
KDE Plasma
```
KDE Plasma is not part of the Orange OS kernel layer and is not part of xnu++.

It is a future userspace/desktop integration target.

---

Build Environment

Orange OS is currently developed using LLVM-based tools.

Primary tools include:

clang
ld.lld
xorriso
QEMU
Limine

The initialization binaries are built as freestanding executables.

Typical compiler options include:

-ffreestanding
-fno-pic
-fno-stack-protector
-fno-builtin

---

Building Orange OS

The current userspace can be built directly with LLVM.

i386
```
cd ~/orange-os

mkdir -p build

clang -m32 \
    -target i386-unknown-none \
    -ffreestanding \
    -fno-pic \
    -fno-stack-protector \
    -fno-builtin \
    -c userspace/init.c \
    -o build/orange_init.o

ld.lld -m elf_i386 \
    --image-base=0x100000 \
    -e orange_init \
    -o build/orange_init.elf \
    build/orange_init.o
```
```
x86-64

cd ~/orange-os

mkdir -p build64

clang -m64 \
    -target x86_64-unknown-none \
    -ffreestanding \
    -fno-pic \
    -fno-stack-protector \
    -fno-builtin \
    -c userspace/init.c \
    -o build64/orange_init.o

ld.lld -m elf_x86_64 \
    --image-base=0x200000 \
    -e orange_init \
    -o build64/orange_init.elf \
    build64/orange_init.o
```
Verify the resulting binaries:

file build/orange_init.elf build64/orange_init.elf

Expected architecture information:

ELF 32-bit ... Intel i386
ELF 64-bit ... x86-64

---

Development ISO

Orange OS can be assembled into a development ISO containing both the xnu++ kernel and Orange OS initialization binary.

The development layout is:
```
build/iso/
├── boot/
│   ├── limine/
│   │   ├── limine-bios-cd.bin
│   │   └── limine-bios.sys
│   │
│   ├── xnuxx.elf
│   └── orange_init.elf
│
└── limine.conf
```
The Limine configuration uses Multiboot2:

timeout: 0
```
/Orange OS x86-64
    protocol: multiboot2
    kernel_path: boot():/boot/xnuxx.elf
    module_path: boot():/boot/orange_init.elf
```
This allows the boot environment to provide both the xnu++ kernel and Orange initialization payload.

---

QEMU

Orange OS is currently tested using QEMU.

For terminal-based testing:
```
qemu-system-x86_64 \
    -cdrom build/orange-os.iso \
    -boot d \
    -m 256M \
    -display curses \
    -no-reboot \
    -no-shutdown
```
The curses display is useful in environments where QEMU's GTK or SDL graphics backends are unavailable.

---

Development Environment

Orange OS can be developed from a Linux-like environment with:

- LLVM/Clang
- LLD
- xorriso
- QEMU
- Limine
- standard shell tools

The project can also be developed from constrained environments such as Termux when the required native tools are available.

The project does not depend on a traditional Linux kernel inside the Orange OS architecture.

---

Repository Structure

The current repository is organized as:
```
orange-os/
├── bin/
│   └── orange
│
├── docs/
│   └── ARCHITECTURE.md
│
├── etc/
│   ├── orange/
│   │   └── services/
│   └── orange.conf
│
├── packages/
│
├── rootfs/
│   ├── bin/
│   ├── dev/
│   ├── etc/
│   ├── home/
│   ├── proc/
│   ├── root/
│   ├── run/
│   ├── sys/
│   ├── tmp/
│   ├── usr/
│   └── var/
│
├── system/
│
├── userspace/
│   └── init.c
│
├── var/
│   └── lib/
│       └── orange/
│
├── build/
├── build64/
│
├── Makefile
└── README.md
```
Build directories contain generated files and development artifacts.

---

Design Principles

Minimal

Orange OS starts with a small userspace instead of attempting to provide a complete desktop operating system immediately.

Modular

Components such as package management and service management are separated from the underlying platform.

CLI-first

The command line is the primary interface during early development.

Distribution-focused

Orange OS is concerned with userspace, packages, services, configuration, and applications rather than implementing the kernel itself.

Architecture-aware

i386 and x86-64 builds are maintained independently.

Incremental

The project is developed in stages instead of claiming completeness before the underlying components exist.

---

What Orange OS Does Not Claim Yet

Orange OS is not currently a production-ready general-purpose operating system.

The following areas are still under development:

- Complete process management.
- Complete virtual memory integration.
- Complete filesystem support.
- Complete networking.
- Complete hardware support.
- Production package repositories.
- Production dependency resolution.
- Complete service supervision.
- Full userspace isolation.
- Full user/account management.
- Complete graphical environment.
- Complete KDE Plasma integration.
- Production security infrastructure.

The project documentation intentionally distinguishes current implementation from planned functionality.

---

Security

Orange OS relies on the security architecture being developed in xnu++.

The current system includes architectural concepts for:

- Boot verification.
- Measurements.
- Rollback protection.
- Recovery.
- Capability requirements.

However, these components are still under development.

Orange OS should therefore be considered an experimental operating-system project and should not be treated as a production-secure platform.

---

Roadmap

Phase 1 — Userspace Foundation

- [x] Root filesystem
- [x] Orange CLI
- [x] Configuration
- [x] Init prototype
- [x] i386 init build
- [x] x86-64 init build
- [x] Development ISO

Phase 2 — System Services

- [x] Service configuration format
- [x] Service CLI
- [ ] Native service supervisor
- [ ] Process supervision
- [ ] Service dependencies
- [ ] Logging system

Phase 3 — Package System

- [x] Package database prototype
- [x] Package CLI
- [ ] Package format
- [ ] Dependency resolver
- [ ] Repository system
- [ ] Package signatures
- [ ] Atomic transactions
- [ ] Rollback

Phase 4 — Core Userspace

- [ ] Native init
- [ ] Process management
- [ ] Users
- [ ] Groups
- [ ] Permissions
- [ ] Filesystem integration
- [ ] Device management
- [ ] Networking

Phase 5 — Desktop

- [ ] Wayland integration
- [ ] KDE Plasma packages
- [ ] Display manager
- [ ] Graphics stack
- [ ] Input integration
- [ ] Desktop services

Phase 6 — Distribution

- [ ] Stable package repositories
- [ ] Installation system
- [ ] System upgrades
- [ ] Recovery environment
- [ ] Release profiles
- [ ] Hardware support matrix
- [ ] Stable release process

---

Current Architecture

The intended long-term architecture is:

                         Applications
                              │
                    ┌─────────┴─────────┐
                    │                   │
                  CLI              KDE Plasma
                    │                   │
                    └─────────┬─────────┘
                              │
                         Orange OS
                              │
              ┌───────────────┼───────────────┐
              │               │               │
             init         packages        services
              │               │               │
              └───────────────┼───────────────┘
                              │
                            xnu++
                              │
             ┌────────────────┼────────────────┐
             │                │                │
           Memory          Devices          Security
             │                │                │
             └────────────────┼────────────────┘
                              │
                    XNU / Mach / BSD / IOKit
                              │
                           Hardware

---

Relationship to the xnu++ Project

Orange OS is developed as a separate distribution project.

The underlying platform is:

xnu++

The distribution is:

Orange OS

The repositories are intentionally separated so that the platform and distribution can evolve independently.

xnu++
  ↓
Platform

Orange OS
  ↓
Distribution

For information about the kernel/platform architecture, boot system, provider architecture, security interfaces, and low-level implementation, see the xnu++ project documentation.

---

Project Status

Orange OS is an active experimental project.

The current development milestone demonstrates:
```
xnu++
      │
      ▼
Multiboot2
      │
      ▼
Limine
      │
      ▼
Orange OS ISO
      │
      ├── xnu++ kernel
      │
      └── Orange init
```
The project is currently focused on turning this foundation into a complete userspace environment.

---

Long-Term Vision

The long-term goal of Orange OS is to provide a complete distribution environment built around xnu++.

The intended result is:
```
Boot
 ↓
xnu++
 ↓
Orange OS init
 ↓
System services
 ↓
Filesystem
 ↓
Networking
 ↓
Package management
 ↓
Applications
 ↓
Optional KDE Plasma desktop

The project will continue to develop from the lowest system layers toward a complete distribution.
```
---

License

See the repository license for the current licensing terms of Orange OS.

---

Orange OS

Platform: xnu++
Userspace: Orange
Primary interface: CLI
Architectures: i386 / x86-64
Boot protocol: Multiboot2
Bootloader: Limine
Desktop target: KDE Plasma / Wayland
Status: Experimental
