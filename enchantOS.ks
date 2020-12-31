// enchantOS.ks
// this shall become the core operating system for all my scripts in the future.
clearscreen.
//include the needed library scripts
if not(core:VOLUME:FILES:HASKEY("library")) {
  createdir("library/enchantOSlibraries").
}
if ship:CONNECTION:ISCONNECTED {
  cd("1:/library").
  copypath("0:/library/fileIO.lib.ks","").
  copypath("0:/library/guiTools.lib.ks","").
  copypath("0:/library/launchUtils.lib.ks","").
  list files in libraryList.
  for file in libraryList {
    if file:ISFILE {
      print "running " + file:NAME.
      runoncepath(file).
    }
  }
  copypath("0:/library/enchantOSlibraries","").
  cd("1:/library/enchantOSlibraries").
  libraryList:CLEAR().
  list files in libraryList.
  for file in libraryList {
    print "running " + file:NAME.
    runoncepath(file).
  }
  switch to 1.
}

// core:DOEVENT("close terminal").

//initialize program variables
global archiveList is createScriptOnlyFileList(). //called from fileIO.lib.ks
lock fileList to createScriptOnlyFileList(1). //using optional parameter
global terminateCommanded is false.
global scriptCalled is false.
global launchUnderway is false.
global launchAbortedDuringSession is false.
global ascentCompleted is false.
declare global internalScriptOptions to lexicon(
  "Maneuver Lock", true,
  "Launch", true,
  "Hoverslam", false
).
declare global internalScriptDelegates to lexicon(
  "Maneuver Lock", enchantMnvLock@,
  "Launch", enchantLaunch@,
  "Hoverslam", enchantHoverslam@
).
declare global internalScriptStackInits to lexicon(
  "Maneuver Lock", createMnvLockBox@,
  "Launch", createLaunchBox@,
  "Hoverslam", createHvrslamBox@
).
set consoleValues to lexicon(
  "width", 415,
  "height", 500,
  "xPos", 296,
  "yPos", -500,
  "isDraggable", false,
  "hint", "none" //type "none" here to not use this
).
global consoleGUI is initGUI(consoleValues). //from guiTools.lib.ks

//call the gui create functions from the guiCreate.lib file
createTitleBar().
createLoadLayout().
createRunLayout().
createDeleteLayout().
createScriptsBox().
createAutomationListEditButton().
createInternalAutomationBox().
createAutomationListEditBox().

//show the internal automation area & use optional doLastStackSet parameter
//which requires using the exclusion lexicon optional parameter first
switchStackTo(internalAutomationListStack, internalScriptOptions, true).

//show the console GUI.
consoleGUI:SHOW.

//main program loop
until terminateCommanded {
  if scriptCalled {
    runpath(runSelected(runSelectPopup:PRESSED)).
    set runScriptButton:ENABLED to false.
    set scriptCalled to false.
  }
  if launchUnderway {
    doLaunchTasks().
  }
  if launchAbortedDuringSession or ascentCompleted {
    doReleaseTasks().
    set launchAbortedDuringSession to false.
    set ascentCompleted to false.
  }
  // print "X position: " + consoleGUI:X at(0,20).
  // print "Y position: " + consoleGUI:Y at(0,21).
}
