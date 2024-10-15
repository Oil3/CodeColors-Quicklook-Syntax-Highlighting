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


![ss2_lanczos](https://github.com/user-attachments/assets/45b5521d-a45a-4e25-953b-8a816149d1ad)

  
![ss1_lanczos](https://github.com/user-attachments/assets/df6605b5-b4e8-45ed-88af-60a3d98997ab)

I made the app because I was straining my eyes quicklooking python scripts, and I don't like to wait for Xcode to load, and I don't like installing things that are too complex or not Gatekeeper friendly.  

## Plans:
-custom colors, color schemes
-Chunks instead of lines for lazy loading
-line numbering
