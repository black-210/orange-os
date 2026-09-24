# Orange OS

Orange OS is a CLI-first distribution built on top of xnu++.

It is designed to provide a minimal userspace and system management
environment while leaving the underlying platform architecture to xnu++.

## Architecture

```text
Orange OS
│
├── CLI
├── Package management
├── Services
├── Configuration
└── Userspace
        │
        ▼
      xnu++
        │
        ▼
 XNU / Mach / BSD / IOKit
