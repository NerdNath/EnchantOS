//enchantOSguiDraw.lib.ks
//this will hold all the functions which draw the guis in Enchant OS.

function createTitleBar {
  //Make a collection of widgets for the enchantOS title bar
  set titleLayout to consoleGUI:ADDHLAYOUT().

  //Make a button to minimize the enchantOS console
  set minimizeButton to titleLayout:ADDBUTTON("Shrink").
  set minimizeButton:STYLE:HSTRETCH to false.
  set minimizeButton:ONCLICK to minimizeToggle@. //in the delegate library
  
  set titleText to titleLayout:ADDLABEL("<size=20>Welcome to EnchantOS!</size>").
  set titleText:STYLE:HSTRETCH to true.
  set titleText:STYLE:ALIGN to "CENTER".

  //Make a button to end the program
  set quitButton to titleLayout:ADDBUTTON("Exit").
  set quitButton:STYLE:HSTRETCH to false.
  //attach the terminate function from guiTools.lib to a delegate variable
  set quitDelegate to terminateProgram@.
  //use the delegate variable in an anonymous funtion to call it with console 
  set quitButton:ONCLICK to {quitDelegate:CALL(consoleGUI).}.
}

function createLoadLayout {
  set loadLayout to consoleGUI:ADDHLAYOUT().
  set loadSelectLabel to loadLayout:ADDLABEL("Select a Script to Load:").
  set loadSelectPopup to loadLayout:ADDPOPUPMENU().
  set loadSelectPopup:STYLE:WIDTH to 140.
  set loadScriptButton to loadLayout:ADDBUTTON("Load Script").
  set loadScriptButton:STYLE:HSTRETCH to false.
  set loadScriptButton:STYLE:WIDTH to 85.
  set loadScriptButton:ENABLED to false.
  set loadSelectPopup:OPTIONS to archiveList.
  set loadSelectPopup:ONCHANGE to loadSelect@.
  set loadScriptButton:ONCLICK to loadClick@.
}

function createRunLayout {
  set runLayout to consoleGUI:ADDHLAYOUT().
  set runSelectLabel to runLayout:ADDLABEL("Select a Script to Run:").
  set runSelectPopup to runLayout:ADDPOPUPMENU().
  set runSelectPopup:STYLE:WIDTH to 140.
  set runScriptButton to runLayout:ADDBUTTON("Run Script").
  set runScriptButton:STYLE:HSTRETCH to false.
  set runScriptButton:STYLE:WIDTH to 85.
  set runScriptButton:ENABLED to false.
  set runSelectPopup:OPTIONS to fileList.
  set runSelectPopup:ONCHANGE to runSelect@.
  set runScriptButton:ONCLICK to runClick@.
}

function createDeleteLayout {
  set deleteLayout to consoleGUI:ADDHLAYOUT().
  set deleteSelectLabel to deleteLayout:ADDLABEL("Select a Script to Delete:").
  set deleteSelectPopup to deleteLayout:ADDPOPUPMENU().
  set deleteSelectPopup:STYLE:WIDTH to 140.
  set deleteScriptButton to deleteLayout:ADDBUTTON("Delete Script").
  set deleteScriptButton:STYLE:HSTRETCH to false.
  set deleteScriptButton:STYLE:WIDTH to 85.
  set deleteScriptButton:ENABLED to false.
  set deleteSelectPopup:OPTIONS to fileList.
  set deleteSelectPopup:ONCHANGE to deleteSelect@.
  set deleteScriptButton:ONCLICK to deleteClick@.
}

function createScriptsBox {
  set scriptTitlesBox to consoleGUI:ADDHLAYOUT().
  set scriptTitlesBox:STYLE:WIDTH to 400.
  set cpuVolumeTitle to scriptTitlesBox:ADDLABEL("Volume: 1:/").
  set internalScriptsAreaTitle to scriptTitlesBox:ADDLABEL("Internal Automation:").
  set internalScriptsAreaTitle:STYLE:ALIGN to "RIGHT".
  set scriptsArea to consoleGUI:ADDHLAYOUT().
  set cpuFilesBox to scriptsArea:ADDSCROLLBOX().
  set cpuFilesBox:STYLE:WIDTH to 192.
  reListFiles(). //from enchantOSguiDelegates.lib.ks
}

function createInternalScriptsArea {
  set internalScriptsArea to scriptsArea:ADDVLAYOUT().
  set internalScriptsArea:STYLE:WIDTH to 192.
}

function createInternalAutomationBox {
  set internalAutomationListStack to internalScriptsArea:ADDSTACK().
  set internalAutomationBox to internalAutomationListStack:ADDSCROLLBOX().
  for key in internalScriptOptions:KEYS {
    set automationButton to internalAutomationBox:ADDBUTTON(key).
    set automationButton:ONCLICK to internalScriptDelegates[key].
    automationButton:HIDE.
    internalScriptStackInits[key]:call().
  }
}

function createAutomationListEditButton {
  set automationListEdit to scriptTitlesBox:ADDBUTTON("EDIT").
  set automationListEdit:TOGGLE to true.
  set automationListEdit:STYLE:FONTSIZE to 12.
  set automationListEdit:STYLE:WIDTH to 65.
  set automationListEdit:STYLE:HEIGHT to 15.
  set automationListEdit:STYLE:MARGIN:TOP to 10.
  set automationListEdit:ONCLICK to automationListEditClick@.
}

function createAutomationListEditBox {
  set automationListEditStack to internalScriptsArea:ADDSTACK().
  set automationListEditBox to automationListEditStack:ADDSCROLLBOX.
  set sampleButton to automationListEditBox:ADDBUTTON("Sample Button").
  set sampleButton:STYLE:HSTRETCH to false.
  set buttonStyle to sampleButton:STYLE.

  for key in internalScriptOptions:KEYS {
    set layoutLine to automationListEditBox:ADDHLAYOUT().
    set automationOptionLabel to layoutLine:ADDLABEL(key).
    if internalScriptOptions[key] = true {
      set automationShowButton to layoutLine:ADDRADIOBUTTON("Show", true).
      set automationHideButton to layoutLine:ADDRADIOBUTTON("Hide", false).
    } else {
      set automationShowButton to layoutLine:ADDRADIOBUTTON("Show", false).
      set automationHideButton to layoutLine:ADDRADIOBUTTON("Hide", true).
    }
    set automationShowButton:STYLE to buttonStyle.
    set automationHideButton:STYLE to buttonStyle.
    set layoutLine:ONRADIOCHANGE to automationVisToggled@.
  }
  sampleButton:DISPOSE.
  automationButtonListRefresh().
}

function createMnvLockBox {
  set mnvLockStack to internalScriptsArea:ADDSTACK().
  set mnvLockBox to mnvLockStack:ADDVBOX().
  set mnvLockBox:STYLE:HEIGHT to 312.

  set closeButtonSpacer to mnvLockBox:ADDSPACING(-1).
  set mnvCloseButton to mnvLockBox:ADDBUTTON("Close").
  set mnvCloseButton:ONCLICK to closeAutomationClicked@.
}

function createLaunchBox {
  set launchStack to internalScriptsArea:ADDSTACK().
  set launchBox to launchStack:ADDVBOX().
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
  set hoverslamStack to internalScriptsArea:ADDSTACK().
  set hoverslamBox to hoverslamStack:ADDVBOX().
  set hoverslamBox:STYLE:HEIGHT to 312.

  set closeButtonSpacer to hoverslamBox:ADDSPACING(-1).
  set closeHvrslamAutomation to hoverslamBox:ADDBUTTON("Close").
  set closeHvrslamAutomation:ONCLICK to closeAutomationClicked@.
}