//enchantOSguiDraw.lib.ks
//this will hold all the functions which draw the guis in Enchant OS.

function createTitleBar {
  //Make a collection of widgets for the enchantOS title bar
  global titleLayout is consoleGUI:ADDHLAYOUT().

  //Make a button to minimize the enchantOS console
  global minimizeButton is titleLayout:ADDBUTTON("Shrink").
  set minimizeButton:STYLE:HSTRETCH to false.
  set minimizeButton:ONCLICK to minimizeToggle@. //in the delegate library
  
  local titleText is titleLayout:ADDLABEL("<size=20>Welcome to EnchantOS!</size>").
  set titleText:STYLE:HSTRETCH to true.
  set titleText:STYLE:ALIGN to "CENTER".

  //Make a button to end the program
  global quitButton is titleLayout:ADDBUTTON("Exit").
  set quitButton:STYLE:HSTRETCH to false.
  set quitButton:ONCLICK to terminateProgram@:BIND(consoleGUI).
}

function createLoadLayout {
  local  loadLayout is consoleGUI:ADDHLAYOUT().
  local loadLabel is loadLayout:ADDLABEL("Select a Script to Load:").
  global loadSelectPopup is loadLayout:ADDPOPUPMENU().
  set loadSelectPopup:STYLE:WIDTH to 140.
  global loadScriptButton is loadLayout:ADDBUTTON("Load Script").
  set loadScriptButton:STYLE:HSTRETCH to false.
  set loadScriptButton:STYLE:WIDTH to 85.
  set loadScriptButton:ENABLED to false.
  set loadSelectPopup:OPTIONS to archiveList.
  set loadSelectPopup:ONTOGGLE to loadSelect@.
  set loadScriptButton:ONCLICK to loadClick@.
}

function createRunLayout {
  local runLayout is consoleGUI:ADDHLAYOUT().
  local runLabel is runLayout:ADDLABEL("Select a Script to Run:").
  global runSelectPopup is runLayout:ADDPOPUPMENU().
  set runSelectPopup:STYLE:WIDTH to 140.
  global runScriptButton is runLayout:ADDBUTTON("Run Script").
  set runScriptButton:STYLE:HSTRETCH to false.
  set runScriptButton:STYLE:WIDTH to 85.
  set runScriptButton:ENABLED to false.
  set runSelectPopup:OPTIONS to fileList.
  set runSelectPopup:ONTOGGLE to runSelected@.
  set runScriptButton:ONCLICK to runClicked@.
}

function createDeleteLayout {
  local deleteLayout is consoleGUI:ADDHLAYOUT().
  local deleteLabel is deleteLayout:ADDLABEL("Select a Script to Delete:").
  global deleteSelectPopup is deleteLayout:ADDPOPUPMENU().
  set deleteSelectPopup:STYLE:WIDTH to 140.
  global deleteScriptButton is deleteLayout:ADDBUTTON("Delete Script").
  set deleteScriptButton:STYLE:HSTRETCH to false.
  set deleteScriptButton:STYLE:WIDTH to 85.
  set deleteScriptButton:ENABLED to false.
  set deleteSelectPopup:OPTIONS to fileList.
  set deleteSelectPopup:ONTOGGLE to deleteSelect@.
  set deleteScriptButton:ONCLICK to deleteClick@.
}

function createScriptsBox {
  global scriptTitlesBox is consoleGUI:ADDHLAYOUT().
  set scriptTitlesBox:STYLE:WIDTH to 400.
  local cpuVolumeTitle is scriptTitlesBox:ADDLABEL("Volume: 1:/").
  local internalScriptsAreaTitle is scriptTitlesBox:ADDLABEL("Internal Automation:").
  set internalScriptsAreaTitle:STYLE:ALIGN to "RIGHT".
  local scriptsArea is consoleGUI:ADDHLAYOUT().
  global cpuFilesBox is scriptsArea:ADDSCROLLBOX().
  set cpuFilesBox:STYLE:WIDTH to 192.
  reListFiles(). //from enchantOSguiDelegates.lib.ks
  global internalScriptsArea is scriptsArea:ADDVLAYOUT().
  set internalScriptsArea:STYLE:WIDTH to 192.
}

function createInternalAutomationBox {
  global internalAutomationListStack is internalScriptsArea:ADDSTACK().
  global internalAutomationBox is internalAutomationListStack:ADDSCROLLBOX().
  for key in internalScriptOptions:KEYS {
    local automationButton is internalAutomationBox:ADDBUTTON(key).
    set automationButton:ONCLICK to internalScriptDelegates[key].
    automationButton:HIDE.
    internalScriptStackInits[key]:call().
  }
}

function createAutomationListEditButton {
  global automationListEdit is scriptTitlesBox:ADDBUTTON("EDIT").
  set automationListEdit:TOGGLE to true.
  set automationListEdit:STYLE:FONTSIZE to 12.
  set automationListEdit:STYLE:WIDTH to 65.
  set automationListEdit:STYLE:HEIGHT to 15.
  set automationListEdit:STYLE:MARGIN:TOP to 10.
  set automationListEdit:ONCLICK to automationListEditClick@.
}

function createAutomationListEditBox {
  global automationListEditStack is internalScriptsArea:ADDSTACK().
  local automationListEditBox is automationListEditStack:ADDSCROLLBOX.
  local sampleButton is automationListEditBox:ADDBUTTON("Sample Button").
  set sampleButton:STYLE:HSTRETCH to false.
  set buttonStyle to sampleButton:STYLE.

  for key in internalScriptOptions:KEYS {
    local layoutLine is automationListEditBox:ADDHLAYOUT().
    local automationOptionLabel is layoutLine:ADDLABEL(key).
    if internalScriptOptions[key] = true {
      local automationShowButton is layoutLine:ADDRADIOBUTTON("Show", true).
      local automationHideButton is layoutLine:ADDRADIOBUTTON("Hide", false).
      set automationShowButton:STYLE to buttonStyle.
      set automationHideButton:STYLE to buttonStyle.
    } else {
      local automationShowButton is layoutLine:ADDRADIOBUTTON("Show", false).
      local automationHideButton is layoutLine:ADDRADIOBUTTON("Hide", true).
      set automationShowButton:STYLE to buttonStyle.
      set automationHideButton:STYLE to buttonStyle.
    }
    set layoutLine:ONRADIOCHANGE to automationVisToggled@.
  }
  sampleButton:DISPOSE.
  automationButtonListRefresh().
}

function createMnvLockBox {
  global mnvLockStack is internalScriptsArea:ADDSTACK().
  local mnvLockBox is mnvLockStack:ADDVBOX().
  set mnvLockBox:STYLE:HEIGHT to 312.

  local closeButtonSpacer is mnvLockBox:ADDSPACING(-1).
  local mnvCloseButton is mnvLockBox:ADDBUTTON("Close").
  set mnvCloseButton:ONCLICK to closeAutomationClicked@.
}

function createLaunchBox {
  global launchStack is internalScriptsArea:ADDSTACK().
  global launchBox is launchStack:ADDVBOX().
  set launchBox:STYLE:HEIGHT to 312.
  initLaunchDefaults().//from enchantLaunchDelegates.lib.ks
  initHeadingOptions().//needed to control runtime of lexicons

  createApoapsisSelectWidgets().//from enchantLaunchGUIs.lib.ks
  createAscentHeadingSelectWidgets().
  createGLoadLimitSelectWidgets().
  createResetConfirmCloseButtons().
  createPostLiftoffReadouts().
  createPostLiftoffButtons().

  switchToPrelaunch().//from enchantLaunchDelegates.lib.ks
}

function createHvrslamBox {
  global hoverslamStack is internalScriptsArea:ADDSTACK().
  local hoverslamBox is hoverslamStack:ADDVBOX().
  set hoverslamBox:STYLE:HEIGHT to 312.

  local closeButtonSpacer is hoverslamBox:ADDSPACING(-1).
  local closeHvrslamAutomation is hoverslamBox:ADDBUTTON("Close").
  set closeHvrslamAutomation:ONCLICK to closeAutomationClicked@.
}
