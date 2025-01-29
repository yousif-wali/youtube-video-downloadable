# YouTube Video Downloader (Zig + Python's yt-dlp)

## 🚀 Overview
This is a **YouTube Video Downloader** written in **Zig** that uses **Python's yt-dlp** package to download videos. The program allows users to:
- Enter a **YouTube video URL**.
- **List available formats** (video/audio).
- **Choose a format** for downloading.
- **Save the video** in the `zig-downloader/` folder.

## 📦 Installation

### **1. Install Zig Compiler**
Make sure you have **Zig** installed. Check with:
```sh
zig version
```
If not installed, download it from:
🔗 [https://ziglang.org/download](https://ziglang.org/download)

### **2. Install Python and yt-dlp**
This program requires `yt-dlp` to be installed via Python:
```sh
python3 -m pip install -U yt-dlp
```
Verify installation with:
```sh
python3 -m yt_dlp --version
```

## 🔨 Build Instructions

### **Compile for Your OS**
Run the following command to compile the Zig program:
```sh
zig build-exe src/main.zig -O ReleaseSafe
```

### **Cross-Compile for Windows 64-bit (From macOS/Linux)**
```sh
zig build-exe src/main.zig -O ReleaseSafe -target x86_64-windows
```

## 🎬 Usage

### **Run the Program**
```sh
./main
```
1. **Enter a YouTube video URL**.
2. **Choose a format from the list**.
3. **The video will be saved in the `zig-downloader/` folder**.

## 🛠 Troubleshooting

### **yt-dlp Not Found**
If you see the error:
```
🚨 Python's yt-dlp is not installed!
```
Install `yt-dlp` with:
```sh
python3 -m pip install -U yt-dlp
```

### **Windows Execution Issues**
If Windows doesn't recognize the `.exe`, try running:
```sh
.\main.exe
```

## 🚀 Features
✅ Uses **Python's yt-dlp** for the latest YouTube updates  
✅ Small Zig binary (~1MB, no embedded yt-dlp)  
✅ Cross-platform (macOS, Windows, Linux)  
✅ No need to bundle `yt-dlp.exe`  

## 📜 License
This project is **open-source** and free to use.

---
🚀 Enjoy downloading videos with Zig! 🎥✨
