# WinRes App

A macOS application which serves two purposes:

### 1. Works as an app switcher

Switch to a specific app using a keyboard shortcut. For example, assign `⌥1` to switch to your browser and `⌥2` to switch to your terminal app.
The switching logic is the following:

1. If the app is not running, launch the app
2. If the app is running, but there are no windows of the app, open a new app window
3. If there are windows of the app, then switch to the app
4. If a window of the app is in the focus, switch to the next app window

### 2. Adds keyboard shortcuts to move and resize windows

Assign keyboard shortcuts to:

1. Zoom the active window
2. Minimize the active window
3. Move the active window to the left side of the screen
4. Move the active window to the right side of the screen

**Warning**: the window resizing feature is experimental, which means it may not work in some cases. It also means that the feature may be removed in a future release.

## Screenshots

<img src="./WinRes/Docs/Images/Settings.png" width="500">

## Installation

Go to [the releases page](https://github.com/mdmitry01/WinRes/releases) and download the latest app version.

## How to use

After launching the WinRes app, you should see its icon in the menu bar. Click on it and select "Settings".
At this point, the app may already request the Accessibility permissions (depending on your macOS version).
Grant the requested permissions at your discretion, but the app won't work without the Accessibility permissions.

In the settings window, you can assign keyboard shortcuts for the window actions (e.g. Zoom active window, Minimize active window, etc.). 

Also, you can assign shortcuts to quickly switch between applications. Let's say you want to open Google Chrome with a keyboard shortcut. 
To do so, we'll need to know the bundle ID of the Google Chrome app. 
To get it, use the following terminal command: `osascript -e 'id of app "Google Chrome"'`. 
The command should return `com.google.Chrome`. Specify this value in the "App bundle ID" field,
then click on the "Shortcut" field to assign a shortcut. If you want to always open a new window of the app, check the "Open a new window" checkbox. 

## Build

To build the WinRes app:

1. Open this project in Xcode
2. Increase the version number if needed. See how to do it here: https://stackoverflow.com/a/47945146
3. In the menu bar, go to `Product` > `Archive`
4. In the `Archives` window that opens, select the version you want and click `Distribute App`
5. Select `Copy App` as the distribution method
6. Choose a name and location, then click `Export`
7. Use the Disk Utility to create a `dmg` file from the `app` file you created in the previous step, see how to do so [here](https://kb.parallels.com/en/123895)

## Why

I tried to replicate a similar window management experience that I have on my Linux machine, but on macOS. 
Why not use existing solutions like [Rectangle](https://github.com/rxhanson/Rectangle) and [rcmd](https://apps.apple.com/en-us/app/id1596283165), you may ask?
The existing solutions are great, but they don't offer the exact experience I'm looking for. Also, I wanted a pet project, so I decided to implement the WinRes app.

## Implementation details

The WinRes app mainly relies on two APIs:

1. API to simulate keyboard presses, e.g. simulate `Command+N` to open a new window
2. The accessibility API to select menu bar items, e.g. select `Window->Move Window to Left Side of Screen` to move the window. Why not use the App Shortcuts in the macOS keyboard settings which basically do the same (they allow you to assign keyboard shortcuts to menu bar items)? The answer is simple: it did not work stable for me. Sometimes the assigned shortcuts were not working at all. So instead, I used the accessibility API to implement these shortcuts in the WinRes app.
