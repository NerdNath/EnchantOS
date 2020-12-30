//enchantAutomationDelegates.lib.ks
//this will hold the delegates that are called when enchantOS internal
//automation buttons are pressed

//include the needed library scripts
runoncepath("1:/library/guiTools.lib.ks").

function enchantMnvLock {
  set automationListEdit:ENABLED to false.
  set loadSelectPopup:ENABLED to false.
  set runSelectPopup:ENABLED to false.
  set deleteSelectPopup:ENABLED to false.
  switchStackTo(mnvLockStack).//from guiTools.lib.ks
}

function enchantLaunch {
  set automationListEdit:ENABLED to false.
  set loadSelectPopup:ENABLED to false.
  set runSelectPopup:ENABLED to false.
  set deleteSelectPopup:ENABLED to false.
  switchStackTo(launchStack).//from guiTools.lib.ks
}

function enchantHoverslam {
  set automationListEdit:ENABLED to false.
  set loadSelectPopup:ENABLED to false.
  set runSelectPopup:ENABLED to false.
  set deleteSelectPopup:ENABLED to false.
  switchStackTo(hoverslamStack).//from guiTools.lib.ks
}