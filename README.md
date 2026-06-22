# FFCOMBINE v1.0

A portable multi-tool CLI hub for Windows written in Batch. It orchestrates multimedia processing, AI models, cross-compilation, network downloads, and Git automation into a single, light, and unified command-line experience.

## The Core Concept
The main philosophy behind **FFCOMBINE** is absolute toolchain independence and data centralization. Instead of messing up your Windows operating system with dozens of heavy installers, path variables, and registry entries, this hub isolates everything into a single directory. 

It provides an "all-in-one" environment where you can fetch media, compile high-performance code, run local AI models, and push updates to your repositories simultaneously without leaving the terminal.

---

## ⚠️ Important: Working Directory Rule
To ensure seamless execution, **all files you want to process must be placed directly into the root folder** of the project (the same directory where `ffcombine.bat` is located).

* **For Media Module**: Drop your `.mp4`, `.mkv`, `.avi`, or `.mp3` files directly into the root folder before launching the technical analysis or player.
* **For Code Builders**: Place your `.c` or `.cpp` source files directly into the root folder so the compilers can instantly detect and build them.

---

## Installation & Portable Binaries Setup

To run this hub from source code, you must download the portable versions of the required tools and place them into the respective directories:

* **Git for Windows (Portable)** -> Extract its contents directly into the `git` folder.
* **Llama.cpp (CPU & Vulkan Backends)** -> Extract Vulkan files into `llama/vulkan` and CPU files into `llama/cpu`.
* **LLVM-MinGW (Clang Compiler)** -> Extract the lightweight distribution into the `llvm-mingw` folder.
* **MinGW64 (GCC Compiler)** -> Ensure `mingwvars.bat` is present and extract it into the `mingw64` folder.
* **Wget for Windows** -> Place the standalone `wget.exe` binary into the `wget` folder.
* **YT-DLP, Deno Engine & FFmpeg** -> Place `yt-dlp.exe`, `deno.exe`, and the local `ffmpeg` binaries together directly into the `yt-dlp-ffmpeg` folder.

---

## Pre-Assembled Releases (Recommended)
If you do not want to download and set up all the compilers and tools manually, go to the **Releases** tab on GitHub. 

There you can download the single, pre-assembled `.tar.xz` archive compressed via PeaZip's Ultra settings. It contains the **entire 2 GB toolchain fully configured** out of the box. Just unpack it and run `ffcombine.bat` immediately!

---

## Repository Layout
```text
ffcombine/
├── git/                      <- Portable Git binaries (git-bash.exe, git-cmd.exe)
├── llama/                    <- Subfolders: /cpu/ and /vulkan/ containing llama-cli.exe & .gguf models
├── llvm-mingw/               <- Lightweight LLVM/Clang cross-compiler toolchain
├── mingw64/                  <- Classic GCC toolchain environment with mingwvars.bat
├── wget/                     <- Contains standalone wget.exe
├── yt-dlp-ffmpeg/            <- Contains yt-dlp.exe, deno.exe, local ffmpeg binaries, and downloaded media
├── ffcombine.bat             <- Main executable Master Hub script
└── *-combine.bat             <- Independent sub-module scripts
```

## License
This project is licensed under the **CC0 1.0 Universal (Public Domain)**. You can copy, modify, and distribute this software without any restrictions.
