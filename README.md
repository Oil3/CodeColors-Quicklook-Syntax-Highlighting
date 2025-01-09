# Code Colors 

**Code Colors - Quicklook Preview plug-in** is a 100% Swift, lightning-fast Quicklook Extension Plug-in for macOS.  
It is different than others because it uses the new SwiftUI 'Text' capabilities, no html, no rtf,.  
Lighting-fast means it's there before the sound the spacebar makes ends.  `[when filesize less than 4 memory pages]`  

### Features
- **Any File Types**: `.swift`, `.py`, `.yaml`, `.xml`, `.json`, as well as files without extensions. --> please tell me what you need.
- **Syntax Highlighting**:  Already handles various expressions and symbols --> please tell me what else you need.
- **Lazy Loading**: Loads lines per chunks for immediate viewing, stops when view disapears.
- **Pure Swift**:  Only the code that is necessary: the minimum.
- **Main-Thread Offloading**: All file loading and processing are done off the main thread, safeguarding against't system freezes.
- **As safe as your file**: Sandboxed, hardened, notarized, doesn't require internet or any permission whatsoever,  doesn't run the files, but applies formatting on strings that match a pattern.
- **No File Associations**: Doesn't replace the default app for opening files, and text is selectable accross lines for copy/pasting.


### Download from release or from the repository 

Unzip, move somewhere such as /Applications, run once, quit the app: macOS should acknowledge the Quicklook Extension .
Uninstall: as the extension stays within the app, remove the app to remove the extension.   


![ss2_lanczos](https://github.com/user-attachments/assets/45b5521d-a45a-4e25-953b-8a816149d1ad)

  
![ss1_lanczos](https://github.com/user-attachments/assets/df6605b5-b4e8-45ed-88af-60a3d98997ab)

I made the app because I was straining my eyes quicklooking python scripts, and I don't like to wait for Xcode to load.

## Plans:
- custom colors, color schemes
- import profiles  
- line numbering  
- Editing is very possible to implement however that might go beyond the scope  
- Search?  
