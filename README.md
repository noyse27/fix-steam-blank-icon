# fix-steam-blank-icon.bat

Fixes blank icons for Steam game shortcuts.

Ref: https://github.com/mrsimb/steam_blank_icon_fix

Note: `fix-icon-no-validation.bat` is a version of `fix-icon.bat` without error handling and it hasn't the improvments.
It is provided NOT for actual use, but to enhance readability and ease of understanding.

Enhanced the Steam icon fix script to automatically scan the user's desktop for Steam shortcuts and refresh the desktop after processing, eliminating the need for manual intervention.

Changes Made
🔍 # Automatic Desktop Detection
Added intelligent desktop path detection that checks for both OneDrive and local desktop locations
Supports modern Windows setups where desktop is synced to OneDrive (%USERPROFILE%\OneDrive\Desktop)
Falls back gracefully to traditional desktop path (%USERPROFILE%\Desktop) if OneDrive is not used
Provides clear feedback about which desktop path is being used

🔄 # Automatic Desktop Refresh
Implemented automatic desktop refresh functionality using VBScript and Windows Shell API
Refreshes desktop icons after successful icon downloads (equivalent to pressing F5)
Only refreshes when files are actually processed to avoid unnecessary operations
Cleans up temporary files automatically

🛠️ # Improved Error Handling
Enhanced validation for Steam URL detection with proper regex patterns
Better variable initialization and cleanup between file processing
Improved feedback messages for debugging and user information
Added processed file counter to show script effectiveness

📝 # Code Quality Improvements
Fixed batch script syntax issues with proper escaping
More robust file existence checking
Cleaner variable handling and scoping
Added comprehensive comments for maintainability

# Benefits
Zero configuration required: Script now runs without any parameters or manual desktop specification
Cross-environment compatibility: Works on both OneDrive-synced and traditional desktop setups
Immediate visual feedback: Desktop refreshes automatically show fixed icons without manual F5
Better user experience: Clear progress indicators and error messages
Reduced maintenance: More robust error handling prevents script failures

# Testing
✅ Tested on Windows 11 with OneDrive desktop sync
✅ Verified compatibility with traditional desktop setups
✅ Confirmed proper icon downloading and desktop refresh functionality
✅ Validated error handling for non-Steam shortcuts and missing files
Breaking Changes
None - the script maintains backward compatibility while adding new automatic features.
