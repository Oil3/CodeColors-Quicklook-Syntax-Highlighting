# CodeContentLoader

**CodeContentLoader** is a 100% Swift, lightning-fast Quicklook Extension Plug-in for macOS. It's a work in progress  using native  syntax highlighting , no JavaScript, no WebKit , no RTF, no external dependencies.


### Features
- **Supported File Types**: `.swift`, `.py`, `.yaml`, `.xml`, `.json`, as well as files without extensions. --> please tell me what you need.
- **Syntax Highlighting**:  Already handles various expressions and symbols --> please tell me what else you need.
- **Lazy Loading**: Load line per line for immediate viewing, stops when view disapears.
- **Pure Swift**:  only the code that is necessarry: the minimum.
- **Main-Thread Offloading**: All file loading and processing are done off the main thread, ensuring the app remains responsive.
- **As safe as your file**: The app is sandboxed, hardened, notarized, doesn't require internet or any permission whatsoever,  doesn't run the files, but iterates through them as utf8 text.
- **No File Associations**: the plug-in doesn't replace the default app for opening files, and text is selectable accross lines for copy/pasting


### Download from release or from the repository
Unzip, move somewhere such as /Applications, run once, quit the app: macOS should acknowledge the Quicklook Extension .
Uninstall: as the extension stays within the app, remove the app to remove the extension.

<img width="1049" alt="ss1" src="https://github.com/user-attachments/assets/6cfd81c6-133d-4a33-bfd8-487a21bfa950">
<img width="1009" alt="ss2" src="https://github.com/user-attachments/assets/76517a29-f8a6-424d-a74c-284d1ae901f0">

I made the app because I was straining my eyes quicklooking python scripts, and I don't like to wait for Xcode to load, and I don't like installing things that are too complex or not Gatekeeper friendly.  

## Plans:
-custom colors, color schemes
-Chunks instead of lines for lazy loading
-line numbering
