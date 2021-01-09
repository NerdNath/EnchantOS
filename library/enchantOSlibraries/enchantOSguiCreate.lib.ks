//enchantOSguiDraw.lib.ks
//this will hold all the functions which draw the guis in Enchant OS.

function createTitleBar {
  //Make a collection of widgets for the enchantOS title bar
  local titleLayout is consoleGUI:ADDHLAYOUT().

  //Make a button to minimize the enchantOS console
  local minimizeButton is titleLayout:ADDBUTTON("Shrink").
  set minimizeButton:STYLE:HSTRETCH to false.
  set minimizeButton:ONCLICK to minimizeToggle@:BIND(minimizeButton).
  
  local titleText is titleLayout:ADDLABEL("Welcome to EnchantOS!").
  set titleText:STYLE:FONTSIZE to 23.
  set titleText:STYLE:HSTRETCH to true.
  set titleText:STYLE:ALIGN to "CENTER".

  //Make a button to end the program
  local quitButton is titleLayout:ADDBUTTON("Exit").
  set quitButton:STYLE:HSTRETCH to false.
  set quitButton:ONCLICK to terminateProgram@:BIND(consoleGUI).
}

function createLoadLayout {
  local  loadLayout is consoleGUI:ADDHLAYOUT().
  local loadLabel is loadLayout:ADDLABEL("Select a Script to Load:").
  local loadSelectPopup is loadLayout:ADDPOPUPMENU().
  set loadSelectPopup:STYLE:WIDTH to 140.
  local loadScriptButton is loadLayout:ADDBUTTON("Load Script").
  set loadScriptButton:STYLE:HSTRETCH to false.
  set loadScriptButton:STYLE:WIDTH to 85.
  set loadScriptButton:ENABLED to false.
  set loadSelectPopup:OPTIONS to archiveList.
  set loadSelectPopup:ONCLICK to loadSelect@:BIND(loadSelectPopup).
  set loadScriptButton:ONCLICK to loadClick@:BIND(loadScriptButton).
}

function createRunLayout {
  local runLayout is consoleGUI:ADDHLAYOUT().
  local runLabel is runLayout:ADDLABEL("Select a Script to Run:").
  local runSelectPopup is runLayout:ADDPOPUPMENU().
  set runSelectPopup:STYLE:WIDTH to 140.
  local runScriptButton is runLayout:ADDBUTTON("Run Script").
  set runScriptButton:STYLE:HSTRETCH to false.
  set runScriptButton:STYLE:WIDTH to 85.
  set runScriptButton:ENABLED to false.
  set runSelectPopup:OPTIONS to fileList.
  set runSelectPopup:ONCLICK to runSelected@:BIND(runSelectPopup).
  set runScriptButton:ONCLICK to runClicked@:BIND(runScriptButton).
}

function createDeleteLayout {
  local deleteLayout is consoleGUI:ADDHLAYOUT().
  local deleteLabel is deleteLayout:ADDLABEL("Select a Script to Delete:").
  local deleteSelectPopup is deleteLayout:ADDPOPUPMENU().
  set deleteSelectPopup:STYLE:WIDTH to 140.
  local deleteScriptButton is deleteLayout:ADDBUTTON("Delete Script").
  set deleteScriptButton:STYLE:HSTRETCH to false.
  set deleteScriptButton:STYLE:WIDTH to 85.
  set deleteScriptButton:ENABLED to false.
  set deleteSelectPopup:OPTIONS to fileList.
  set deleteSelectPopup:ONCLICK to deleteSelect@:BIND(deleteSelectPopup).
  set deleteScriptButton:ONCLICK to deleteClick@:BIND(deleteScriptButton).
}

function createScriptsBox {
  local scriptTitlesBox is consoleGUI:ADDHLAYOUT().
  set scriptTitlesBox:STYLE:WIDTH to 400.
  local cpuVolumeTitle is scriptTitlesBox:ADDLABEL("Volume: 1:/").
  local internalScriptsAreaTitle is scriptTitlesBox:ADDLABEL("Internal Automation:").
  set internalScriptsAreaTitle:STYLE:ALIGN to "RIGHT".
  local autoListEdit is scriptTitlesBox:ADDBUTTON("EDIT").
  set autoListEdit:TOGGLE to true.
  set autoListEdit:STYLE:FONTSIZE to 12.
  set autoListEdit:STYLE:WIDTH to 65.
  set autoListEdit:STYLE:HEIGHT to 15.
  set autoListEdit:STYLE:MARGIN:TOP to 10.
  set autoListEdit:ONCLICK to automationListEditClick@:BIND(autoListEdit).

  local scriptsArea is consoleGUI:ADDHLAYOUT().
  local cpuFilesBox is scriptsArea:ADDSCROLLBOX().
  set cpuFilesBox:STYLE:WIDTH to 192.
  reListFiles(). //from enchantOSguiDelegates.lib.ks
  local internalScriptsArea is scriptsArea:ADDVLAYOUT().
  set internalScriptsArea:STYLE:WIDTH to 192.
}

function createInternalAutomationBox {
  local internalAutoListStack is consoleGUI:WIDGETS[5]:WIDGETS[1]:ADDSTACK().
  local internalAutomationBox is internalAutoListStack:ADDSCROLLBOX().
  for key in internalScriptOptions:KEYS {
    local autoBtn is internalAutomationBox:ADDBUTTON(key).
    set autoBtn:ONCLICK to internalScriptDelegates[key]:BIND(autoBtn).
    autoBtn:HIDE.
    internalScriptStackInits[key]:call().
  }
}

function createAutomationListEditBox {
  local automationListEditStack is consoleGUI:WIDGETS[5]:WIDGETS[1]:ADDSTACK().
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
  local mnvLockStack is consoleGUI:WIDGETS[5]:WIDGETS[1]:ADDSTACK().
  local mnvLockBox is mnvLockStack:ADDVBOX().
  set mnvLockBox:STYLE:HEIGHT to 312.

  local closeButtonSpacer is mnvLockBox:ADDSPACING(-1).
  local mnvCloseButton is mnvLockBox:ADDBUTTON("Close").
  set mnvCloseButton:ONCLICK to closeAutomationClicked@:BIND(mnvCloseButton).
}

function createLaunchBox {
  local launchStack is consoleGUI:WIDGETS[5]:WIDGETS[1]:ADDSTACK().
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
  local hoverslamStack is consoleGUI:WIDGETS[5]:WIDGETS[1]:ADDSTACK().
  local hoverslamBox is hoverslamStack:ADDVBOX().
  set hoverslamBox:STYLE:HEIGHT to 312.

  local closeButtonSpacer is hoverslamBox:ADDSPACING(-1).
  local closeHvrslam is hoverslamBox:ADDBUTTON("Close").
  set closeHvrslam:ONCLICK to closeAutomationClicked@:BIND(closeHvrslam).
}
