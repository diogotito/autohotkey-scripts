Some AutoHotKey scripts
=======================

Been learning AutoHotKey v1.1 a bit more in depth but I plan to migrate my scripts
to v2 because I'm excited about the evolution that's happening to the languge
there!

The relevant files are:

- `desktops.ahk` -  the "entry point" that has most of my hotkeys and `#Include`s
the rest of the relevant files, which are mostly in...
- `Lib/` – the [local library of functions](https://www.autohotkey.com/docs/Functions.htm#lib)

I created a shortcut to `desktops.ahk` in my Startup foler
(<kbd>⊞ Win</kbd> <kbd>R</kbd> `shell:startup` <kbd>&#x23ce;</kbd>)

Features
--------

- Bind <kbd>&#x21d1;</kbd><kbd>&#x229e;</kbd> <kbd>Q</kbd>
to <kbd>Alt</kbd> <kbd>F4</kbd> to close windows more ergonomically
- Bind <kbd>&#x229e;</kbd> <kbd>N</kbd> / <kbd>&#x21d1;</kbd><kbd>&#x229e;</kbd> <kbd>N</kbd>
to go to the next / previous desktop
- Bind <kbd>Ctrl</kbd><kbd>&#x229e;</kbd><kbd>Alt</kbd> <kbd><i>N</i></kbd>
to switch to the <i>N</i>-th desktop
- A few hotkeys to launch applications
- Many hotkeys that either [launch, switch to, or cycle](Lib/CycleOrLaunch.ahk)
through windows of an application (one hotkey for each application)
that begin with <kbd>Ctrl</kbd><kbd>&#x229e;</kbd><kbd>Alt</kbd>

### Software augmentations

- <kbd>&#x229e;</kbd> <kbd>C</kbd> launches **Character Map** and enhances it
with some keyboard shortcuts, like
  - <kbd>Ctrl</kbd> <kbd>F</kbd> to focus the "Search For" field
  (although this field gets automatically focused by the
  <kbd>&#x229e;</kbd> <kbd>C</kbd> hotkey as soon as the Character Map
  window pops up)
  - <kbd>Ctrl</kbd> <kbd>&larr; Backspace</kbd> proprely deletes a word
  (something that, amazingly, doesn't work in many native Windows programs!)
  - <kbd>Alt</kbd> <kbd>H</kbd><kbd>J</kbd><kbd>K</kbd><kbd>L</kbd> goes
  <kbd>&larr;</kbd><kbd>&darr;</kbd><kbd>&uarr;</kbd><kbd>&rarr;</kbd>
  in the character grid
  - <kbd>Ctrl</kbd> <kbd>C</kbd> instantly copies the highlighted character in
  the grid to the clipboard and hides the Character Map window
  - <kbd>Esc</kbd> _hides_ the Character Map window so that
  <kbd>&#x229e;</kbd> <kbd>C</kbd> brings it up very quickly next time.

> I probably should learn to use Hotstrings to insert commonly used Unicode
symbols.  
> Or install something like [WizKey](https://antibody-software.com/wizkey/)
for this.

- **7-zip** gets two Hotkeys to aid working with its dual-pane mode:
  - <kbd>Ctrl</kbd> <kbd>B</kbd> (bound to <kbd>F9</kbd>) toggles "2 Panels"
  - <kbd>Ctrl</kbd> <kbd>L</kbd> focuses the location bar of the active panel.

- <kbd>Ctrl</kbd> <kbd>Tab ↹</kbd> switches between the two most recently used
tabs on **Chrome** (if you have the
[QuicKey extension](https://chrome.google.com/webstore/detail/quickey-%E2%80%93-the-quick-tab-s/ldlghkoiihaelfnggonhjnfiabmaficg)
installed) and **TeXstudio**.

- **Firefox** gets <kbd>&#x21d1;</kbd><kbd>Alt</kbd> +
<kbd>#</kbd>/<kbd>$</kbd>/<kbd>%</kbd>/<kbd>^</kbd>/<kbd>*</kbd>/<kbd>+</kbd>/<kbd>?</kbd>
to focus the address bar and type the corresponding symbol to
[filter the autocomplete results](https://support.mozilla.org/en-US/kb/address-bar-autocomplete-firefox#w_changing-results-on-the-fly).
<kbd>&#x21d1;</kbd><kbd>Alt</kbd> + <kbd>?</kbd>
brings up a quick reference in a tooltip.

- I like to take my notes in **[Zim](https://zim-wiki.org/)**,
but it's a Python + GTK app that's too slow to start up on Windows for me,
so I enabled the Tray Icon plugin and made it automatically start up to the
tray.
Then I bound <kbd>&#x229e;</kbd> <kbd>Z</kbd> to quickly bring up a Zim window
using a small variety of methods:
  1. If it's minimized to the taskbar, restore it.
  2. If it's closed but the app is running in the tray,
  type `#b{Right}{Right}{Right}z{Enter}` to bring the window back
  3. If it isn't running, launch it again.
  4. If the window is focused, minimize it.

### Thanks

[VirtualDesktopAccessor](https://github.com/Ciantic/VirtualDesktopAccessor)
for providing a DLL to simplify use of Virtual Desktop APIs and sample AHK code
to call into it.

Companion programs
------------------

These are things I like to have installed on Windows workstations,
besides AutoHotKey and AHK scripts.

- [Everything](https://www.voidtools.com/) with "Toggle window Hotkey:"
<kbd>&#x21d1;</kbd><kbd>&#x229e;</kbd> <kbd>E</kbd>.
- [SylphyHorn](https://github.com/Grabacr07/SylphyHorn), which provides:
  - Customizable hotkeys to move windows to adjacent desktops and pin/unpin them
  - A tray icon and a popup showing the current desktop number
- [Monitorian](https://github.com/emoacht/Monitorian) to adjust monitor
brightness.
  - `Lib\MonitorianKeys.ahk` defines some hotkeys to increase and decrease
  the brightness of a single monitor while showing the brightness value in a
  tooltip under the mouse.
- [Microsoft PowerToys](https://learn.microsoft.com/en-us/windows/powertoys/).
The things I use the most are:
  - PowerToys Run
    - The `desktops.ahk` script augments the input field with some
    Readline (Emacs)-style keybindings.
  - Additional File Explorer preview handlers (see also: [QuickLook](https://github.com/QL-Win/QuickLook)).
  - Always On Top,
  Awake,
  Color Picker,
  Mouse Utilities,
  Screen Ruler
  and Shortcut Guide.
- [QuickLook](https://github.com/QL-Win/QuickLook): A floating preview window
that pops up with <kbd>Space</kbd> on a selected file in Explorer.
- [RepoZ](https://github.com/awaescher/RepoZ): Quickly search local Git repos
with <kbd>Ctrl</kbd><kbd>Alt</kbd> <kbd>R</kbd>
and open them in either Explorer or Windows Terminal.

### Honorable Mentions

[AltBacktick](https://github.com/akiver/AltBacktick): Switches between windows
of the same app on <kbd>Alt</kbd> <kbd>`</kbd>.
Implemented in C++ with Win32 API.

<!--
<kbd>Tab ↹</kbd>
<kbd>&#x21d1; Shift</kbd>
<kbd>Ctrl</kbd>
<kbd>&#x229e; Win</kbd>
<kbd>Alt</kbd>
-->