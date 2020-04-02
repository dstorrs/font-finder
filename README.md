# Purpose

This Racket library searches standard locations on your computer for TrueType, OpenType, and Postscript Type 1 (PT1) fonts.

**This library is very early-stage and incomplete**

# Font Directories 

The following are the standard locations for fonts based on your OS:

    Windows:  C:\Windows\Fonts  (TT and OT)
              C:\psfonts\pfm    (PT1)


    macOS:    /System/Library/Fonts
              /Library/Fonts
              /Users/{name}/Library/Fonts


    unix:     Throws an exception.  Font locations are not standardized.  A future version will handle this better.

# Font Extensions

Fonts are identified based on their extension.  Expected extensions are:

  TrueType: .ttf, .ttc
  OpenType: .ttf, .otf
  PT1     : .pfm, .pfb

See the Warnings section below.

# Interface

 `(known-fonts)`             : Returns a list of all font files it can find
 `(populate-known-fonts)`    : Re-scans the disk to refresh the value returned by `(known-fonts)`
 `(system-font-folders)`     : Returns the list of system folders that will be searched for fonts.
 `(macos-user-font-folders)` : Returns the list of /Users/{name}/Library/Fonts directories that exist on this Mac.

Note:  You don't need to explicitly call `populate-known-fonts`, since `known-fonts` will take care of that if it has not been done yet.  After `populate-known-fonts` is called, the list will be cached and future calls to `known-fonts` will return the cached copy without re-checking the disk.  You may call `populate-known-fonts` in order to refresh the list (e.g. if you install more fonts).

# **WARNINGS**

* PT1 fonts are problematic in that they consist of two files; this module does not worry about that, it simply returns both as separate items and it's your job to match them up.  They will often not be contiguous in the list.
* The returned list is not guaranteed to be in any particular order.
* font-finder will not notice fonts that aren't in one of the expected locations
* Fonts are identified based on their extension.  If it doesn't have one of the expected extensions, it will not be recognized and therefore it will not be in the list of known fonts.
* The list returned by `known-fonts` only updates when `populate-known-fonts` is called.  This is done automatically the first time you call `known-fonts`, but if you install or delete fonts then your list will be stale and you'll need to call `populate-known-fonts` again in order to refresh it.